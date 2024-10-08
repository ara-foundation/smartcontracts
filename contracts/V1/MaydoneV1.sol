// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { ProjectV1 } from "./ProjectV1.sol";
import { TreasuryV1 } from "./TreasuryV1.sol";
import { OwnershipTokenV1 } from "./OwnershipTokenV1.sol";
import { MaintainerTokenV1 } from "./MaintainerTokenV1.sol";
import { CheckTokenV1 } from "./CheckTokenV1.sol";
import { SharedV1 } from "./SharedV1.sol";
import { CashierV1 } from "./CashierV1.sol";
import { ActV1 } from "./ActV1.sol";

contract MaydoneV1 is SharedV1, OwnableUpgradeable {
    struct Token {
        uint256 maxSupply;
        string symbol;
        string name;
    }

    ProjectV1 public project;
    TreasuryV1 public treasury;
    CashierV1 public cashier;
    ActV1 public act;

    function initialize() initializer public {
 	    // As we add proxy deployment from the client, let's change the admin to 
        // another DAO.
        __Ownable_init(msg.sender);
    }

    function setProject(address project_) external onlyOwner {
        project = ProjectV1(project_);
    }

    function setTreasury(address treasury_) external onlyOwner {
        treasury = TreasuryV1(treasury_);
    }

    function setCashier(address cashier_) external onlyOwner {
        cashier = CashierV1(cashier_);
    }

    function setAct(address act_) external onlyOwner {
        act = ActV1(act_);
    }

    /**
     * Launch a new project by providing a project plan.
     * Arguments:
     * - logos
     * - user-scenario
     * - plan
     * - sangha (Token parameters for ownership), the maintainer parameters too
     * - launchpad parameters: start time, end time.
     * 
     * Plan of project is converted into a project.
     * Upon success, returns a launchpad that users can use to invest.
     */
    function launch(
        Token calldata token,
        Project calldata projectData
    ) external {
        // TODO: validate the arguments
        
        // save the logos, user-scenario and plan on db
        uint256 projectId = project.newProject(projectData);
        project.setInitialLeader(projectId, msg.sender);
        
        bytes32 salt = keccak256(
            abi.encodePacked(
                address(this), block.chainid, projectId, token.name, token.symbol
            )
        );
        // create and mint tokens. All maintainer tokens send to the caller.
        Sangha memory sangha;
        sangha.ownership = address(new OwnershipTokenV1{salt: salt}(projectId, token.maxSupply, address(treasury), token.name, token.symbol));
        sangha.maintainer = address(new MaintainerTokenV1{salt: salt}(projectId, msg.sender, sangha.ownership, string.concat(token.name, " Maintainer"), string.concat(token.symbol, "m")));
        sangha.check = address(new CheckTokenV1{salt: salt}(projectId, address(cashier), address(act), string.concat(token.name, " check"), string.concat(token.symbol, "c")));
        project.setSangha(projectId, sangha);

        // register in treasury and bank, so that project can accept tokens.
        // create a launchpad automatically
        treasury.setProject(projectId, token.maxSupply, projectData.costUsd, sangha);
        cashier.setProject(projectId, sangha);
        uint256 araFee = treasury.getAraFee();
        uint256 checkLimit = projectData.costUsd;
        if (araFee > 0) {
            checkLimit = projectData.costUsd / 100 * (100 - araFee);
        }
        act.setProject(projectId, checkLimit, projectData.duration, sangha);
    }
}