// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IMAINToken} from "../IMAINToken.sol";
import {IAddon} from "../addon/IAddon.sol";
import {ICheck} from "../ICheck.sol";

/**
 * @title ProjectCheckToken is the payment check issued to contributors by MAINToken holders
 * @author Medet Ahmetson <medet@ara.foundation>
 * @dev Requires ARAToken, MAINToken smartcontracts
 */
contract ProjectCheckToken is ERC20Upgradeable, ICheck {
    ERC20 public dao;
    ERC20 public main;

      struct NewProject {
        Project params;
        uint256 timeStart;
        bool actionTaken;
        uint256 countYes;
        uint256 countNo;
        uint256 votingPeriod;
        mapping (address => bool) voted;
        Addon addonParams;
      }

      struct Addon {
        address maintainer;
        address collateral;
        address addon;
        uint256 amount;
        uint256 minted;
        bool cancelled;
      }

      struct Project {
        address maintainer;
        uint256 amount;
        uint256 period;
        uint256 startTime;
        uint256 minted;
        uint256 limit;
        bool cancelled;
      }

      struct CollateralVoting {
        uint256 votingPeriod;
        uint256 timeStart;
        bool actionTaken;
        uint256 countYes;
        uint256 countNo;
        mapping (address => bool) voted;
      }

      mapping (address => bool) public collaterals;

      uint256 public projectId;

      mapping (uint256 => Project) public projects;
      mapping (uint256 => NewProject) public newProjectVotings;

      mapping (address => CollateralVoting) public collateralVotings;
      mapping (address => uint256) public checkPerCollateral; // per CHECK

    address public priceSetter;
      mapping (uint256 => Addon) public addons;

      event CollateralVotingInit(address indexed initializer, address indexed token, uint256 votingPeriod);
      event CollateralVote(address indexed voter, address token, uint256 votePower, bool agree);
      event CollateralVotingAction(address token, bool agree);

      event Mint(uint256 indexed projectId, address to, uint256 amount, bytes payload);

      event NewProjectInit(address indexed maintainer, uint256 indexed projectId, uint256 period, uint256 budget);
      event NewAddonInit(address indexed maintainer, uint256 indexed projectId, address addon, address collateral, uint256 amount);
      event NewProjectVote(address indexed voter, uint256 projectId, uint256 votePower, bool agree);
      event NewProjectAction(uint256 projectId, bool agree);

      modifier onlyMaintainer() { 
        require(main.balanceOf(msg.sender) > 0, "no mainteiner tokens");
        _;
      }

      modifier onlyDao() {
        require(dao.balanceOf(msg.sender) > 0, "no mainteiner tokens");
        _;
      }

      modifier onlyAllowed(uint256 projectId_) {
        require(msg.sender == projects[projectId_].maintainer, "not allowed");
        _;
      }

      modifier onlyAddon(uint256 projectId_) {
        require(addons[projectId_].addon == msg.sender, "not allowed");
        _;
      }

      modifier onlyLeader() {
        require(msg.sender == IMAINToken(address(main)).leader(), "not a leader");
        _;
      }

      modifier onlyPriceSetter() {
        require(msg.sender == priceSetter, "not a price setter");
        _;
      }

      function initialize(address ara_, address main_, string memory name_, string memory symbol_) initializer public {
        __ERC20_init(name_, symbol_);
        dao = ERC20(ara_);
        main = ERC20(main_);
      }

      function setPriceSetter(address _priceSetter) external onlyLeader {
        priceSetter = _priceSetter;
      }

      function setCheckPerCollateral(address collateral, uint256 perCheck) external onlyPriceSetter {
        require(isCollateral(collateral), "not collateral");
        checkPerCollateral[collateral] = perCheck;
      }

      /**
       * Mint Check token for the user
       * @param projectId_ Each project has it's own allocation
       * @param to receiver of the check token
       * @param amount amount of check tokens user receives
       */
      function mint(uint256 projectId_, address to, uint256 amount, bytes calldata payload) external onlyAllowed(projectId_) {
        Project storage project = projects[projectId_];
        require(project.cancelled == false, "cancelled");

        uint256 quota = 0;
        
        if (project.period <= project.limit) {
          quota = project.amount - project.minted;
        } else {
          uint256 sprintAmount = project.period / project.limit;
          uint256 quotaPerSprint = project.amount / sprintAmount;
          require(quotaPerSprint > 0, "0 quota per sprint");

          uint256 projectActivePeriod = (block.timestamp - project.startTime);
          uint256 currentSprint = 1;
          if (projectActivePeriod > project.limit) {
            currentSprint = projectActivePeriod / project.limit;
          }

          quota = (currentSprint * quotaPerSprint) - project.minted;
        }

        require(amount <= quota, "exceeds the quota limit");

        project.minted += amount;
        _mint(to, amount);

        emit Mint(projectId_, to, amount, payload);
      }

      /**
       * Mint a token for the addon issuer
       * @param projectId_ Addon Project ID
       * @param to A contributor's address
       * @param amount of CHECK contributor receives
       * @param payload additional information about the addon task
       */
      function mintByAddon(uint256 projectId_, address to, uint256 amount, bytes calldata payload) external onlyAddon(projectId_) returns(bool) {
        Addon storage addon = addons[projectId_];
        require(addon.cancelled == false, "cancelled");

        addon.minted += amount;
        _mint(to, amount);

        emit Mint(projectId_, to, amount, payload);

        return true;
      }

      function newProjectInit(address projectLeader, uint256 period, uint256 budget, uint256 votingPeriod, uint256 limit) public onlyLeader returns (uint256) {
        require(main.balanceOf(projectLeader) > 0, "project leader is not a maintainer");
        require(period > 86400, "at least a day");
        require(budget > 0, "0 budget");

        projectId++;
        
        newProjectVotings[projectId].params.maintainer = projectLeader;
        newProjectVotings[projectId].params.amount = budget;
        newProjectVotings[projectId].params.period = period;
        newProjectVotings[projectId].timeStart = block.timestamp;
        newProjectVotings[projectId].votingPeriod = votingPeriod;
        newProjectVotings[projectId].params.limit = limit;

        emit NewProjectInit(projectLeader, projectId, period, budget);
      
        return projectId;
      }

      /**
       * Initiate a voting to add a new project as an addon.
       * Unlike another project, the addon doesn't have a budget or a time limit.
       * Instead it allows everybody issue what kind of addon they want by providing fixed collateral amount.
       * @param projectLeader The maintainer who is overseeing everything
       * @param addon The addon smartcontract
       * @param votingPeriod Voting to confirm that addon is accepted
       * @param collateral From addon askers what we ask for
       * @param amount Amount of tokens to ask from addon requesters
       */
      function newAddonInit(address projectLeader, address addon, uint256 votingPeriod, address collateral, uint256 amount) public onlyLeader returns (uint256) {
        require(main.balanceOf(projectLeader) > 0, "project leader is not a maintainer");
        require(votingPeriod > 0, "empty voting period");

        projectId++;

        newProjectVotings[projectId].addonParams.maintainer = projectLeader;
        newProjectVotings[projectId].addonParams.amount = amount;
        newProjectVotings[projectId].addonParams.collateral = collateral;
        newProjectVotings[projectId].addonParams.addon = addon;
        newProjectVotings[projectId].timeStart = block.timestamp;
        newProjectVotings[projectId].votingPeriod = votingPeriod;

        emit NewAddonInit(projectLeader, projectId, addon, collateral, amount);

        return projectId;
      }

      function newProjectVote(uint256 projectId_, bool agree) public onlyDao {
        NewProject storage thisProject = newProjectVotings[projectId_];
        require(thisProject.timeStart > 0, "session not found");
        require(thisProject.voted[msg.sender] == false, "you already voted");
        require(thisProject.timeStart + thisProject.votingPeriod > block.timestamp
        || thisProject.actionTaken == false, "voting finished");

        uint256 userBalance = dao.balanceOf(msg.sender);

        if (agree) {
          thisProject.countYes += userBalance;
        }
        else {
          thisProject.countNo += userBalance;
        }
        
        thisProject.voted[msg.sender] = true;
        
        emit NewProjectVote(msg.sender, projectId_, userBalance, agree);
      }

      function newProjectAction(uint256 projectId_) public onlyMaintainer {
        NewProject storage thisProject = newProjectVotings[projectId_];
        require(thisProject.timeStart > 0, "session not found");
        require(canTakeAction(thisProject),  "can't take action");
        require(thisProject.actionTaken == false, "voting finished");
        
        if (thisProject.countYes > thisProject.countNo) {
          if (thisProject.addonParams.maintainer != address(0)) {
            addons[projectId_] = thisProject.addonParams;
            IAddon addon = IAddon(thisProject.addonParams.addon);
            addon.setProjectId(projectId_);
          } else {
            projects[projectId_] = thisProject.params;
            projects[projectId_].startTime = block.timestamp;
          }
        }
        thisProject.actionTaken = true;

        emit NewProjectAction(projectId_, thisProject.countYes > thisProject.countNo);
      }

      function canTakeAction(NewProject storage thisProject) internal view returns (bool) {
        if (thisProject.timeStart + thisProject.votingPeriod > block.timestamp) return true;   
        uint256 halfSupply = dao.totalSupply() / 2;
        return (thisProject.countNo > halfSupply || thisProject.countYes > halfSupply);
      }

      function cancelProject(uint256 projectId_) external {
        if (projects[projectId_].startTime > 0) {
          _cancelProject(projectId_);
        } else {
          _cancelAddon(projectId_);
        }
      }

      function _cancelProject(uint256 projectId_) internal {
        require(projects[projectId_].cancelled == false, "already cancelled");
        require(IMAINToken(address(main)).leader() == msg.sender || projects[projectId_].maintainer == msg.sender, "not allowed");
      
        projects[projectId_].cancelled = true;
      }

      function _cancelAddon(uint256 projectId_) internal {
        require(addons[projectId_].maintainer != address(0), "not addon");
        require(addons[projectId_].cancelled == false, "already cancelled");
        require(IMAINToken(address(main)).leader() == msg.sender || addons[projectId_].maintainer == msg.sender, "not allowed");
      
        addons[projectId_].cancelled = true;
        
      }

      function isCollateral(address addr_) public view returns(bool) {
        return collaterals[addr_];
      }

      function addonPriceParams(uint256 projectId_) external view returns(address, uint256) {
        Addon storage addon = addons[projectId_];
        if (addon.maintainer == address(0) || addon.cancelled) {
          return (address(0), 0);
        }

        return (addon.collateral, addon.amount);
      }

      function maintainerOf(uint256 projectId_) external view returns(address) {
        if (projects[projectId_].maintainer != address(0)) {
          return projects[projectId_].maintainer;
        }

        return addons[projectId_].maintainer;
      }

      function isCancelled(uint256 projectId_) external view returns(bool) {
        if (projects[projectId_].maintainer != address(0)) {
          return projects[projectId_].cancelled;
        }

        return addons[projectId_].cancelled;
      }

      function checkAmountForCollateral(address collateral, uint256 amount) external view returns(uint256) {
        require(checkPerCollateral[collateral] > 0, "no collateral price");

        if (collateral != address(0)) {
          ERC20 token = ERC20(collateral);

          uint8 decimals = token.decimals();
          if (decimals != 18) {
            amount *= 10 ** (18-decimals);
          }
        }

        // 0.5 ETH / 0.0029 ETH = 1724.1379310344828 CHECK
        return amount * (10 ** 18) / checkPerCollateral[collateral];
      }

      // COLLATERAL functions
      function setCollateralInit(address token, uint256 votingPeriod) public onlyMaintainer {
        require(!collaterals[token], "already added");
        if (collateralVotings[token].timeStart > 0) {
            require(collateralVotings[token].actionTaken, "voting goes on");
        }

        collateralVotings[token].timeStart = block.timestamp;
        collateralVotings[token].votingPeriod = votingPeriod;

        emit CollateralVotingInit(msg.sender, token, votingPeriod);
      }

      function setCollateralVote(address token, bool agree) public onlyDao {
          CollateralVoting storage collateralVoting = collateralVotings[token];
          require(collateralVoting.timeStart > 0, "!session");
          require(collateralVoting.voted[msg.sender] == false, "you already voted");
          require(collateralVoting.timeStart + collateralVoting.votingPeriod > block.timestamp
          || collateralVoting.actionTaken == false, "voting_end");

          uint256 votePower = dao.balanceOf(msg.sender);

          if (agree) {
            collateralVoting.countYes += votePower;
          }
          else {
            collateralVoting.countNo += votePower;
          }
          
          collateralVoting.voted[msg.sender] = true;
          
          emit CollateralVote(msg.sender, token, votePower, agree);
      }

      function setCollateralAction(address token) public onlyMaintainer {
          CollateralVoting storage collateralVoting = collateralVotings[token];
          require(collateralVoting.timeStart > 0, "!session");
          require(canCollateralTakeAction(collateralVoting),  "!act");
          require(collateralVoting.actionTaken == false, "voting_end");
          
          if (collateralVoting.countYes > collateralVoting.countNo) {
              collaterals[token] = true;
          }
          collateralVoting.actionTaken = true;
          
          emit CollateralVotingAction(token, collateralVotings[token].countYes > collateralVotings[token].countNo);
      }

      function redeemFromTreasury(address to, uint256 checkAmount, address collateral) external {
        require(balanceOf(msg.sender) >= checkAmount, "not enough tokens");
        require(isCollateral(collateral), "invalid address");
        require(checkPerCollateral[collateral] > 0, "price not set");

        if (collateral == address(0)) {
          uint256 amount = checkAmount * checkPerCollateral[collateral] / (10 ** 18);
          payable(to).transfer(amount);
        } else {
          ERC20 token = ERC20(collateral);
          uint256 amount = checkAmount * checkPerCollateral[collateral] / (10 ** 18);

          uint8 decimals = token.decimals();
          if (decimals != 18) {
            amount /= 10 ** (18-decimals);
          }
          require(token.transfer(to, amount), "failed to transfer");
        }

        _burn(msg.sender, checkAmount);
      }

      function canCollateralTakeAction(CollateralVoting storage collateralVoting) internal view returns (bool) {
        uint256 halfSupply = dao.totalSupply() / 2;
        if (collateralVoting.timeStart + collateralVoting.votingPeriod > block.timestamp) return true;   
        return (collateralVoting.countNo > halfSupply || collateralVoting.countYes > halfSupply);
    }

      receive() external payable {}
}