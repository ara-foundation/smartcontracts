// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { ProjectV1 } from "./ProjectV1.sol";
import { TreasuryV1 } from "./TreasuryV1.sol";
import { OwnershipTokenV1 } from "./OwnershipTokenV1.sol";
import { MaintainerTokenV1 } from "./MaintainerTokenV1.sol";
import { CheckTokenV1 } from "./CheckTokenV1.sol";
import {SharedV1} from "./SharedV1.sol";
import {CashierV1} from "./CashierV1.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ActV1 is SharedV1, OwnableUpgradeable {
    struct Task {
        uint256 checkAmount;
        uint256 startTime;
        uint256 endTime;
        string payload;
    }

    struct DevelopmentLedger {
        uint256 minted;
        uint256 cap;
        uint256 duration;
        uint256 taskId;
    }

    address public maydone;

    mapping(uint256 => Sangha) public sanghas;
    mapping(uint256 => DevelopmentLedger) public developments;
    mapping(uint256 => mapping(uint256 => Task)) public tasks;

    event SetProject(uint256 indexed projectId);
    event NewTask(uint256 indexed projectId, uint256 indexed taskId, uint256 checkAmount_, string payload);
    event CompleteTask(uint256 indexed projectId, uint256 indexed taskId, address contributor, string payload);
    event CancelTask(uint256 indexed projectId, uint256 indexed taskId, string payload);

    modifier onlyMaydone() {
        require(msg.sender == maydone, "not a maydone");
        _;
    }

    modifier onlyMaintainer(uint256 projectId_) {
        require(IERC20(sanghas[projectId_].maintainer).balanceOf(msg.sender) > 0, "not maintainer");
        _;
    }

    function initialize() initializer public {
 	    // As we add proxy deployment from the client, let's change the admin to 
        // another DAO.
        __Ownable_init(msg.sender);
    }

    function setMaydone(address maydone_) external onlyOwner {
        maydone = maydone_;
    }

    /**
     */
    function setProject(
        uint256 projectId_,
        uint256 checkLimit_,
        uint256 duration_,
        Sangha calldata sangha_
    ) external onlyMaydone {
        sanghas[projectId_] = sangha_;
        developments[projectId_].cap = checkLimit_;
        developments[projectId_].duration = duration_;

        emit SetProject(projectId_);
    }

    function newTask(uint256 projectId_, uint256 checkAmount_, uint256 duration_, string calldata payload_) external onlyMaintainer(projectId_) {
        developments[projectId_].taskId++;
        require(developments[projectId_].minted + checkAmount_ <= developments[projectId_].cap, "exceeds the max");
        tasks[projectId_][developments[projectId_].taskId] = Task(checkAmount_, block.timestamp, block.timestamp + duration_, payload_);
        developments[projectId_].minted += checkAmount_;

        emit NewTask(projectId_, developments[projectId_].taskId, checkAmount_, payload_);
    }

    function completeTask(uint256 projectId_, uint256 taskId_, address contributor_, string calldata payload_) external onlyMaintainer(projectId_) {
        require(tasks[projectId_][taskId_].startTime > 0, "failed");
        require(block.timestamp > tasks[projectId_][taskId_].startTime && block.timestamp <= tasks[projectId_][taskId_].endTime, "timeout");
        require(CheckTokenV1(sanghas[projectId_].check).mintByAct(contributor_, tasks[projectId_][taskId_].checkAmount));

        delete tasks[projectId_][taskId_];

        emit CompleteTask(projectId_, taskId_, contributor_, payload_);
    }

    function cancelTask(uint256 projectId_, uint256 taskId_, string calldata payload_) external onlyMaintainer(projectId_) {
        require(tasks[projectId_][taskId_].startTime > 0, "failed");

        developments[projectId_].minted -= tasks[projectId_][taskId_].checkAmount;
        delete tasks[projectId_][taskId_];

        emit CancelTask(projectId_, taskId_, payload_);
    }
}