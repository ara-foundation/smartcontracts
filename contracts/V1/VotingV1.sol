// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ReentrancyGuardUpgradeable}  from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Treasury has the mint permission to mint tokens.
 * @author Medet Ahmetson <milayter@gmail.com>
 * @notice Ara Sangha governs this smartcontract.
 */
contract VotingV1 is OwnableUpgradeable, ReentrancyGuardUpgradeable {
    uint256 public constant VOTING_PERIOD = 864000;

    struct Voting {
        address maintainerToken;    // for voting, its a part of sangha
        address ownershipToken;     // for voting, its a part of sangha
        address proxy; // smartcontract that initiated voting, all voting must come from this smartcontract.
        uint256 timeStart;
        bool actionTaken;
        uint256 countYes;
        uint256 countNo;
        mapping (address => bool) voted;
    }

    uint256 public lastVotingId;

    mapping (uint256 => Voting) public votings;

    event StartVoting(uint256 votingId, address indexed initializer, address indexed maintainerToken, string payload);
    event Vote(uint256 votingId, address indexed voter, address ownershipToken, uint256 votePower, bool agree);
    event EndVoting(uint256 votingId, bool agree);

    modifier onlyMaintainer(address initializer_, address maintainerToken_) {
        require(IERC20(maintainerToken_).balanceOf(initializer_) > 0, "no maintainer");
        _;
    }

    modifier onlyOwnership(uint256 votingId_, address voter_) {
        if (votings[votingId_].proxy == address(0)) {
            require(IERC20(votings[votingId_].ownershipToken).balanceOf(msg.sender) > 0, "no ara");
        } else {
            require(IERC20(votings[votingId_].ownershipToken).balanceOf(voter_) > 0, "no ara");
        }
        _;
    }

    modifier validProxy(uint256 votingId_) {
        if (votings[votingId_].proxy != address(0)) {
            require(votings[votingId_].proxy == msg.sender, "not from sm");
        }
        _;
    }

    function initialize() initializer public {
        // Once we deploy the client to allow deploying upgradeable contracts,
        // we will change the owner.
        __Ownable_init(msg.sender);
        __ReentrancyGuard_init();
    }

    /////////////////////////////////////////////////////////////////////////////////
    //
    // Sangha functionality
    //
    /////////////////////////////////////////////////////////////////////////////////


    function startVoting(address initializer_, address maintainerToken_, address ownershipToken_, string calldata payload_) external onlyMaintainer(initializer_, maintainerToken_) returns(uint256) {
        lastVotingId++;
        
        Voting storage voting = votings[lastVotingId];
        voting.maintainerToken = maintainerToken_;    // for voting, its a part of sangha
        voting.ownershipToken = ownershipToken_;     // for voting, its a part of sangha
        voting.timeStart = block.timestamp;
        if (initializer_ != msg.sender) {
            voting.proxy = msg.sender;
        }

        emit StartVoting(lastVotingId, initializer_, maintainerToken_, payload_);

        return lastVotingId;
    }

    function vote(uint256 votingId_, address voter_, bool agree_) external validProxy(votingId_) onlyOwnership(votingId_, voter_) returns(bool) {
        Voting storage voting = votings[votingId_];
        require(voting.timeStart > 0, "!session");
        require(voting.timeStart + VOTING_PERIOD > block.timestamp && voting.actionTaken == false, "voting_end");
        require(voting.voted[voter_] == false, "you already voted");

        uint256 votePower = IERC20(voting.ownershipToken).balanceOf(voter_);

        if (agree_) {
          voting.countYes += votePower;
        }
        else {
          voting.countNo += votePower;
        }
        
        voting.voted[voter_] = true;
        
        emit Vote(votingId_, voter_, voting.ownershipToken, votePower, agree_);

        return true;
    }

    function endVoting(uint256 votingId_, address maintainer_) external validProxy(votingId_) returns(bool) {
        if (votings[votingId_].proxy == msg.sender) {
            require(IERC20(votings[votingId_].maintainerToken).balanceOf(maintainer_) > 0, "no ara");
        } else {
            require(IERC20(votings[votingId_].maintainerToken).balanceOf(msg.sender) > 0, "no ara");
        }
        Voting storage voting = votings[votingId_];
        require(voting.timeStart > 0, "!session");
        require(voting.actionTaken == false, "voting_end");
        require(isEndable(votingId_),  "!act");
        
        bool agree = voting.countYes > voting.countNo;

        voting.actionTaken = true;
        
        emit EndVoting(votingId_, agree);
        return agree;
    }

    /////////////////////////////////////////////////////////////////////////////////
    //
    // Helper functions
    //
    /////////////////////////////////////////////////////////////////////////////////

    function isEndable(uint256 votingId_) public view returns (bool) {
        Voting storage voting = votings[votingId_];
        if (voting.timeStart == 0 || voting.actionTaken) {
            return false;
        }
        uint256 halfSupply = IERC20(voting.ownershipToken).totalSupply() / 2;
        if (voting.timeStart + VOTING_PERIOD > block.timestamp) return true;   
        return (voting.countNo > halfSupply || voting.countYes > halfSupply);
    }
}