// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title MAINToken is the maintainer's soulbound NFT
 * @author Medet Ahmetson <medet@ara.foundation>
 * @dev Depends on ARAToken
 */
contract MAINToken is ERC20Upgradeable {

      uint256 public constant REVOKE_PERIOD = 259200;
      uint256 public constant HALF_SUPPLY = 37500000000000000000000000;

      IERC20 public ara;
      struct Revoke {
        address from;
        address to;
        uint256 timeStart;
        bool actionTaken;
        uint256 countYes;
        uint256 countNo;
        mapping (address => bool) voted;
        uint256 amount;
      }

      uint256 public sessionId;
      uint256 public receivershipId;
      address public leader;

      mapping (uint256 => Revoke) public revokes;

      event RevokeInit(address indexed initializer, uint256 sessionId, address indexed from, address to);
      event RevokeVote(address indexed voter, uint256 sessionId, uint256 votePower, bool agree);
      event RevokeAction(uint256 sessionId, bool agree);

      modifier onlyMaintainer() { 
        require(balanceOf(msg.sender) > 0, "no mainteiner tokens");
        _;
      }

      modifier onlyAra() {
        require(ara.balanceOf(msg.sender) > 0, "no mainteiner tokens");
        _;
      }

      function initialize(address to, address ara_) initializer public {
        __ERC20_init("Ara Maintainer", "MAIN");
      	_mint(to, 75000000000000000000000000);
        leader = to;
        ara = IERC20(ara_);
      }
                       	
      function transfer(address, uint256) public pure override returns (bool) {
      	revert("Disabled");
      }

      function transferFrom(address, address, uint256) public pure override returns (bool) {
        revert("Disabled");
      }

      function revokeInit(address from, address to) public onlyMaintainer returns (uint256) {
        require(balanceOf(from) > 0, "no from tokens");
        sessionId++;
        revokes[sessionId].from = from;
        revokes[sessionId].to = to;
        revokes[sessionId].timeStart = block.timestamp;
        revokes[sessionId].amount = balanceOf(from);

        emit RevokeInit(msg.sender, sessionId, from, to);

        return sessionId;
      }

      function revokeVote(uint256 sessionId_, bool agree) public onlyMaintainer {
        Revoke storage thisRevoke = revokes[sessionId_];
        require(thisRevoke.timeStart > 0, "session not found");
        require(thisRevoke.voted[msg.sender] == false, "you already voted");
        require(thisRevoke.timeStart + REVOKE_PERIOD > block.timestamp
        || thisRevoke.actionTaken == false, "voting finished");

        uint256 userBalance = balanceOf(msg.sender);

        if (agree) {
          thisRevoke.countYes += userBalance;
        }
        else {
          thisRevoke.countNo += userBalance;
        }
        
        thisRevoke.voted[msg.sender] = true;
        emit RevokeVote(msg.sender, sessionId_, userBalance, agree);
      }

      function revokeAction(uint256 sessionId_) public onlyMaintainer {
        Revoke storage thisRevoke = revokes[sessionId_];
        require(thisRevoke.timeStart > 0, "session not found");
        require(canTakeAction(thisRevoke),  "can't take action");
        require(thisRevoke.actionTaken == false, "voting finished");
        
        if (thisRevoke.countYes > thisRevoke.countNo) {
          _update(thisRevoke.from, thisRevoke.to, thisRevoke.amount);
          if (balanceOf(thisRevoke.to) > balanceOf(leader)) {
            leader = thisRevoke.to;
          }
        }
        thisRevoke.actionTaken = true;
        emit RevokeAction(sessionId_, thisRevoke.countYes > thisRevoke.countNo);
      }

      function canTakeAction(Revoke storage thisRevoke) internal view returns (bool) {
        if (thisRevoke.timeStart + REVOKE_PERIOD > block.timestamp) return true;   
        return (thisRevoke.countNo > HALF_SUPPLY || thisRevoke.countYes > HALF_SUPPLY);

      }

      function transferInit(address from, address to, uint256 amount) public onlyMaintainer returns (uint256) {
        require(balanceOf(from) > 0, "no from tokens");
        sessionId++;
        revokes[sessionId].from = from;
        revokes[sessionId].to = to;
        revokes[sessionId].timeStart = block.timestamp;
        revokes[sessionId].amount = amount;

        emit RevokeInit(msg.sender, sessionId, from, to);

        return sessionId;
      }
      
      function receivershipInit(address from, address to) public onlyAra returns (uint256){
        require(balanceOf(from) > 0, "no from tokens");
        receivershipId++;
        revokes[receivershipId].from = from;
        revokes[receivershipId].to = to;
        revokes[receivershipId].timeStart = block.timestamp;
        revokes[receivershipId].amount = balanceOf(from);

        emit RevokeInit(msg.sender, receivershipId, from, to);

        return receivershipId; 
      }

      function receivershipVote(uint256 receivershipId_, bool agree) public onlyAra {
        Revoke storage thisRevoke = revokes[receivershipId_];
        require(thisRevoke.timeStart > 0, "session not found");
        require(thisRevoke.voted[msg.sender] == false, "you already voted");
        require(thisRevoke.timeStart + REVOKE_PERIOD > block.timestamp
        || thisRevoke.actionTaken == false, "voting finished");

        uint256 userBalance = balanceOf(msg.sender);

        if (agree) {
          thisRevoke.countYes += userBalance;
        }
        else {
          thisRevoke.countNo += userBalance;
        }
        
        thisRevoke.voted[msg.sender] = true;
        emit RevokeVote(msg.sender, receivershipId_, userBalance, agree);
      }

      function receivershipAction(uint256 receivershipId_) public onlyAra {
        Revoke storage thisRevoke = revokes[receivershipId_];
        require(thisRevoke.timeStart > 0, "session not found");
        require(canTakeAction(thisRevoke),  "can't take action");
        require(thisRevoke.actionTaken == false, "voting finished");
        
        if (thisRevoke.countYes > thisRevoke.countNo) {
          _update(thisRevoke.from, thisRevoke.to, thisRevoke.amount);

          if (balanceOf(thisRevoke.to) > balanceOf(leader)) {
            leader = thisRevoke.to;
          }
        }
        thisRevoke.actionTaken = true;
        emit RevokeAction(receivershipId_, thisRevoke.countYes > thisRevoke.countNo);
      }
}