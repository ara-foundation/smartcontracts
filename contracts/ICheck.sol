// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Minter is the bridge between Treasury and Ara token.
 * @author Medet Ahmetson <milayter@gmail.com>
 * @notice Ara Sangha governs this smartcontract.
 */
interface ICheck {
    function addonPriceParams(uint256 projectId) external view returns(address collateral, uint256 amount);
    function maintainerOf(uint256 projectId) external view returns(address);
    function isCancelled(uint256 projectId) external view returns(bool);
    function mintByAddon(uint256 projectId_, address to, uint256 amount, bytes calldata payload) external returns(bool);
    function checkAmountForCollateral(address collateral, uint256 amount) external view returns(uint256);
}