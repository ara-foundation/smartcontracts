// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SharedV1} from "./SharedV1.sol";
import {TreasuryV1} from "./TreasuryV1.sol";
import {CheckTokenV1} from "./CheckTokenV1.sol";

/**
 * @title CHECKToken is the payment check issued to contributors by MAINToken holders
 * @author Medet Ahmetson <medet@ara.foundation>
 * @dev Requires ARAToken, MAINToken, Minter smartcontracts
 */
contract CashierV1 is SharedV1, OwnableUpgradeable {
  address public maydone;
  TreasuryV1 public treasury;
  mapping(uint256 => Sangha) public sanghas;

  event SetProject(uint256 indexed projectId);
  event Redeem(address indexed check, address indexed collateral, address to, uint256 usdAmount, uint256 collateralAmount);

  modifier onlyMaydone() {
    require(msg.sender == maydone, "not a maydone");
    _;
  }

  modifier onlyCheckHodler(uint256 projectId_) {
    require(IERC20(sanghas[projectId_].check).balanceOf(msg.sender) > 0, "not a check");
    _;
  }

  function initialize() initializer public {
 	  // As we add proxy deployment from the client, let's change the admin to 
    // another DAO.
    __Ownable_init(msg.sender);
  }

  function setMaydone(address maydone_) external onlyOwner() {
    maydone = maydone_;
  }

  function setTreasury(address treasury_) external onlyOwner() {
    treasury = TreasuryV1(treasury_);
  }

  function setProject(uint256 projectId_, Sangha calldata sangha_) external onlyMaydone {
    sanghas[projectId_] = sangha_;

    emit SetProject(projectId_);
  }

  /**
   * @param usdAmount_ is one to one with Check token.
  */
  function redeem(uint256 projectId_, uint256 usdAmount_, address collateral_) external onlyCheckHodler(projectId_) {
    require(CheckTokenV1(sanghas[projectId_].check).burnByCashier(msg.sender, usdAmount_), "cant burn check tokens");
    uint256 redeemedAmount = treasury.redeem(msg.sender, usdAmount_, collateral_);
    
    emit Redeem(sanghas[projectId_].check, collateral_, msg.sender, usdAmount_, redeemedAmount);
  }
}