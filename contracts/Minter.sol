// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20CappedUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20CappedUpgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

/**
 * @title Minter is the bridge between Treasury and Ara token.
 * @author Medet Ahmetson <milayter@gmail.com>
 * @notice Ara Sangha governs this smartcontract.
 */
contract Minter is ERC20CappedUpgradeable, AccessControlUpgradeable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    address public bridge;

    modifier onlyBridge() {
        require(msg.sender == bridge, "not a bridge");
        _;
    }

    modifier onlyCheck() {
        require(msg.sender == address(0), "no check");
        _;
    }

    modifier onlyAra() {
        require(msg.sender == address(0), "no ara");
        _;
    }

    modifier afterTwoYears() {
        require(msg.sender == address(0), "");
        _;
    }

    function initialize() initializer public {
 	    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * Mint function is called by anyone.
     * This function mints ARA token in exchange for the collateral.
     * @param to Minting to this smartcontract
     * @param amount of ARA token to mint.
     * @return sessionId if it was send to the Vesting smartcontract.
     */
    function mint(address to, uint256 amount) public returns (uint256) {
      _mint(to, amount);
      return 0;
    }

    /**
     * This function mints tokens and gives them to the user.
     * @param to Mint and give to this account
     * @param amount of ARA token to mint
     */
    function bridgeIn(address to, uint256 amount) public onlyBridge {

    }

    /**
     * This function burns the tokens and gives them to the bridge to transfer.
     * @param to Mint and give to this account
     * @param amount of ARA token to mint
     */
    function bridgeOut(address to, uint256 amount) public onlyBridge {

    }

    /**
     * This function allows minting tokens equivalent to the tokens that user holds.
     */
    function reclaim(address to, uint256 amount) public onlyCheck {

    }

    /////////////////////////////////////////////////////////////////////////////////
    //
    // Sangha functionality
    //
    /////////////////////////////////////////////////////////////////////////////////

    function setBridgeInit() public afterTwoYears onlyAra {

    }

    function setBridgeVote() public onlyAra {

    }

    function setBridgeAction() public onlyAra {

    }

    function setCollateralInit(address token) public onlyAra {

    }

    function setCollateralVote() public onlyAra {

    }

    function setCollateralAction() public onlyAra {

    }

    function setCheck() public {

    }

    function setAra() public {

    }

    function setVesting() public {
        
    }
}