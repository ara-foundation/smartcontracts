// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {SharedV1} from "./SharedV1.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Ara Projects
 * @author Medet Ahmetson
 * @notice Version 1.
 */
contract ProjectV1 is SharedV1, OwnableUpgradeable {
    //
    // Linting with other smartcontracts of Ara
    //
    address public maydone;

    uint256 public lastProjectId;

    mapping(uint256 => Project) public projects;
    mapping(uint256 => Sangha) public sanghas;
    mapping(uint256 => address) public initialLeaders;

    modifier activeProject(uint256 projectId) {
        require(projects[projectId].active, "not active");
        _;
    }

    modifier onlyMaydone() {
        require(msg.sender == maydone, "not maydone");
        _;
    }

    modifier onlyMaydoneOrOwner() {
        require(msg.sender == maydone || msg.sender == owner(), "not maydone or owner");
        _;
    }

    modifier onlyMaintainer(uint256 projectId) {
        require(IERC20(sanghas[projectId].maintainer).balanceOf(msg.sender) > 0, "not maintainer");
        _;
    }

    event NewProject(uint256 indexed projectId, Project project);
    event SetSangha(uint256 indexed projectId, Sangha project);
    event SetInitialLeader(uint256 indexed projectId, address initialLeader);

    function initialize() initializer public {
 	    // As we add proxy deployment from the client, let's change the admin to 
        // another DAO.
        __Ownable_init(msg.sender);
    }

    function setMaydone(address maydone_) external onlyOwner {
        maydone = maydone_;
    }

    function newProject(Project calldata project_) external onlyMaydone returns(uint256) {
        ++lastProjectId;

        projects[lastProjectId].active = true;
        projects[lastProjectId].startTime = block.timestamp;

        emit NewProject(lastProjectId, project_.name);

        return lastProjectId;
    }

    function setInitialLeader(uint256 projectId_, address leader_) external onlyMaydoneOrOwner returns(uint256) {
        initialLeaders[projectId_] = leader_;
        emit SetInitialLeader(projectId_, leader_);
    }
    function setSangha(uint256 projectId_, Sangha calldata sangha_) external onlyMaydone {
        sanghas[projectId_] = sangha_;
    }

    function setCheck(uint256 projectId_, address check_) external onlyMaintainer(projectId_) {
        sanghas[projectId_].check = check_;
    }
}