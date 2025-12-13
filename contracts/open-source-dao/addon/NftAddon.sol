// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IMAINToken} from "../IMAINToken.sol";
import {ICheck} from "../ICheck.sol";

/**
 * @title ProjectCheckToken is the payment check issued to contributors by MAINToken holders
 * @author Medet Ahmetson <medet@ara.foundation>
 * @dev Requires ARAToken, MAINToken smartcontracts
 */
contract NftAddon is OwnableUpgradeable {
  IERC721 public nft;
  ICheck public check;

    struct Order {
      uint256 minted;
      bytes payload;
    }

    uint256 public projectId;

    mapping (uint256 => bool) public orders;
    mapping (uint256 => Order) public params;
    mapping (address => uint256) public activeOrders;

    event ProjectIdSet(uint256 projectId);
    event NewOrder(address indexed owner, uint256 nftId, bytes payload);
    event TaskComplete(uint256 indexed nftId, address indexed contributor, uint256 checkAmount, bytes payload);
    event OrderComplete(uint256 indexed nftId);

    modifier onlyCheck() {
      require(msg.sender == address(check), "not a check");
      _;
    }

      modifier onlyMaintainer() {
        require(msg.sender == check.maintainerOf(projectId), "not maintainer");
        _;
      }

      function initialize(address owner_, address check_, address nft_) initializer public {
        __Ownable_init(owner_);
        check = ICheck(check_);
        nft = IERC721(nft_);
      }

      function setProjectId(uint256 projectId_) external onlyCheck {
        require(projectId == 0, "already set");
        projectId = projectId_;

        emit ProjectIdSet(projectId);
      }

      /**
       * Create a new order related to the NFT by the NFT owner
       * @param nftId of NFT
       * @param payload type of task
       */
      function newOrder(uint256 nftId, bytes calldata payload) external {
        require(projectId != 0, "addon project not activated");
        require(!check.isCancelled(projectId), "cancelled");
        // make sure that caller is nft owner
        require(nft.ownerOf(nftId) == msg.sender, "not your nft");
        require(!orders[nftId], "pending order");

        (address collateral, uint256 amount) = check.addonPriceParams(projectId);
        require(collateral != address(0) && amount != 0, "invalid collateral");

        require(IERC20(collateral).transferFrom(msg.sender, address(check), amount), "failed to transfer");
        
        orders[nftId] = true;
        params[nftId] = Order(0, payload);
        activeOrders[msg.sender]++;

        emit NewOrder(msg.sender, nftId, payload);
      }

      /**
       * Issue a CHECK token to mark order task complete
       * @param to A contributor's address
       * @param collateralAmount of collaterals contributor receives
       * @param payload additional information about the order task: draw UI, integrate into game etc.
       */
      function taskComplete(uint256 nftId, address to, uint256 collateralAmount, bytes calldata payload) external onlyMaintainer {        
        require(orders[nftId], "no order");

        (address collateral, uint256 amount) = check.addonPriceParams(projectId);

        require(params[nftId].minted + collateralAmount <= amount, "exceeds the limit");

        uint256 checkAmount = check.checkAmountForCollateral(collateral, collateralAmount);

        require(check.mintByAddon(projectId, to, checkAmount, payload), "failed to mint");

        params[nftId].minted += collateralAmount;

        emit TaskComplete(nftId, to, collateralAmount, payload);

        if (params[nftId].minted == amount) {
          orders[nftId] = false;
          activeOrders[msg.sender]--;

          emit OrderComplete(nftId);
        }
      }
}