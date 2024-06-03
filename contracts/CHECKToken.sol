// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IMAINToken} from "./IMAINToken.sol";
import {IMinter} from "./IMinter.sol";

contract CHECKToken is ERC20Upgradeable {

      uint256 public constant REVOKE_PERIOD = 864000;
      uint256 public constant LIMIT = 2592000;
      uint256 public constant HALF_SUPPLY = 37500000000000000000000000;

      IERC20 public ara;
      IERC20 public main;
      IMinter public minter;

      struct NewProject {
        Project params;
        uint256 timeStart;
        bool actionTaken;
        uint256 countYes;
        uint256 countNo;
        mapping (address => bool) voted;
      }

      struct Project {
        address maintainer;
        uint256 amount;
        uint256 period;
        uint256 startTime;
        uint256 minted;
        bool cancelled;
      }

      uint256 public projectId;

      mapping (uint256 => Project) public projects;
      mapping (uint256 => NewProject) public newProjectVotings;

      event Mint(uint256 indexed projectId, address to, uint256 amount, bytes payload);

      event NewProjectInit(address indexed maintainer, uint256 indexed projectId, uint256 period, uint256 budget);
      event NewProjectVote(address indexed voter, uint256 projectId, uint256 votePower, bool agree);
      event NewProjectAction(uint256 projectId, bool agree);

      modifier onlyMaintainer() { 
        require(main.balanceOf(msg.sender) > 0, "no mainteiner tokens");
        _;
      }

      modifier onlyAra() {
        require(ara.balanceOf(msg.sender) > 0, "no mainteiner tokens");
        _;
      }

      modifier onlyAllowed(uint256 projectId_) {
        require(msg.sender == projects[projectId_].maintainer, "not allowed");
        _;
      }

      modifier onlyLeader() {
        require(msg.sender == IMAINToken(address(main)).leader(), "not a leader");
        _;
      }

      function initialize(address ara_, address main_, address minter_) initializer public {
        __ERC20_init("Ara Check", "CHECK");
        ara = IERC20(ara_);
        main = IERC20(main_);
        minter = IMinter(minter_);
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
        
        if (project.period <= LIMIT) {
          quota = project.amount - project.minted;
        } else {
          uint256 sprintAmount = project.period / LIMIT;
          uint256 quotaPerSprint = project.amount / sprintAmount;

          uint256 projectActivePeriod = (block.timestamp - project.startTime);
          uint256 currentSprint = 1;
          if (projectActivePeriod > LIMIT) {
            currentSprint = projectActivePeriod / LIMIT;
          }

          quota = (currentSprint * quotaPerSprint) - project.minted;
        }

        require(amount <= quota, "exceeds the quota limit");

        _mint(to, amount);

        emit Mint(projectId_, to, amount, payload);
      }

      function newProjectInit(address projectLeader, uint256 period, uint256 budget) public returns (uint256) {
        require(IERC20(main).balanceOf(projectLeader) > 0, "project leader is not a maintainer");
        require(period > 86400, "at least a day");
        require(budget > 0, "0 budget");

        projectId++;
        
        newProjectVotings[projectId].params.maintainer = projectLeader;
        newProjectVotings[projectId].params.amount = budget;
        newProjectVotings[projectId].params.period = period;
        newProjectVotings[projectId].timeStart = block.timestamp;

        emit NewProjectInit(projectLeader, projectId, period, budget);
      
        return projectId;
      }

      function newProjectVote(uint256 projectId_, bool agree) public onlyAra {
        NewProject storage thisProject = newProjectVotings[projectId_];
        require(thisProject.timeStart > 0, "session not found");
        require(thisProject.voted[msg.sender] == false, "you already voted");
        require(thisProject.timeStart + REVOKE_PERIOD > block.timestamp
        || thisProject.actionTaken == false, "voting finished");

        uint256 userBalance = IERC20(ara).balanceOf(msg.sender);

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
          projects[projectId_] = thisProject.params;
          projects[projectId_].startTime = block.timestamp;
        }
        thisProject.actionTaken = true;

        emit NewProjectAction(projectId_, thisProject.countYes > thisProject.countNo);
      }

      function canTakeAction(NewProject storage thisProject) internal view returns (bool) {
        if (thisProject.timeStart + REVOKE_PERIOD > block.timestamp) return true;   
        return (thisProject.countNo > HALF_SUPPLY || thisProject.countYes > HALF_SUPPLY);
      }

      function cancelProject(uint256 projectId_) public {
        require(projects[projectId_].startTime > 0, "no project");
        require(projects[projectId_].cancelled == false, "already cancelled");
        require(IMAINToken(address(main)).leader() == msg.sender || projects[projectId_].maintainer == msg.sender, "not allowed");
      
        projects[projectId_].cancelled = true;
      }

      function redeemFromTreasury(address to, uint256 amount, address collateral) external {
        require(balanceOf(msg.sender) >= amount, "not enough tokens");
        require(minter.isCollateral(collateral), "invalid address");

        uint256 usdAmount = minter.getUsdAmount(1000000000000000000, collateral);
        require(usdAmount > 0, "0 usd amount");
        uint256 collateralAmount = amount / usdAmount;

        if (collateral == address(0)) {
          payable(to).transfer(collateralAmount);
        } else {
          IERC20(collateral).transfer(to, collateralAmount);
        }

        _burn(msg.sender, amount);
      }

      function reedemAra(address to, uint256 amount, uint8 round) external {
        require(balanceOf(msg.sender) >= amount, "not enough tokens");

        minter.redeem(to, amount, round);

        _burn(msg.sender, amount);
      }

      receive() external payable {}
}