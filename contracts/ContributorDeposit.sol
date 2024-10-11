// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title ContributorDeposit is the payment check issued to contributors by MAINToken holders
 * @author Medet Ahmetson <medet@ara.foundation>
 * @dev Requires ARAToken, MAINToken smartcontracts
 */
contract ContributorDeposit is OwnableUpgradeable {
  IERC20 public ara;
  IERC20 public main;

  struct Deposit {
    uint256 amount;
    string projectId;
    string checkProjectId;
    string taskId;
  }

  mapping(address => Deposit) public deposits;
  // project id  => check project id => task id      => msg.sender
  mapping(string => mapping(string => mapping(string => address))) public reverseDeposits;

  event LockTask(address indexed owner, uint256 amount, string projectId, string checkProjectId, string taskId);
  event CancelLock(address indexed owner, uint256 amount, string projectId, string checkProjectId, string taskId, bool succeed);

  modifier onlyMaintainer() {
    require(main.balanceOf(msg.sender) > 0, "not maintainer");
    _;
  }

  function initialize(address owner_, address main_, address ara_) initializer public {
    __Ownable_init(owner_);
    main = IERC20(main_);
    ara = IERC20(ara_);
  }

  // A user allocates the tokens
  function deposit(uint256 amount, string calldata projectId, string calldata checkProjectId, string calldata taskId) external {
    require(amount > 0, "no ara"); 
    require(deposits[msg.sender].amount == 0, "has a task");
    require(reverseDeposits[projectId][checkProjectId][taskId] == address(0), "task is used");

    require(ara.transferFrom(msg.sender, address(this), amount), "failed to transfer");

    deposits[msg.sender] = Deposit(amount, projectId, checkProjectId, taskId);
    reverseDeposits[projectId][checkProjectId][taskId] = msg.sender;

    emit LockTask(msg.sender, amount, projectId, checkProjectId, taskId);
  }

  function withdraw(address user, address to, bool succeed) external onlyMaintainer {
    require(deposits[user].amount > 0, "no user");

    ara.transfer(to, deposits[user].amount);

    string memory projectId = deposits[user].projectId;
    string memory checkProjectId = deposits[user].checkProjectId;
    string memory taskId = deposits[user].taskId;

    delete reverseDeposits[projectId][checkProjectId][taskId];

    delete deposits[user];
    emit CancelLock(user, deposits[user].amount, projectId, checkProjectId, taskId, succeed);
  }
}