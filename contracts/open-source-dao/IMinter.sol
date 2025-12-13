// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Minter is the bridge between Treasury and Ara token.
 * @author Medet Ahmetson <milayter@gmail.com>
 * @notice Ara Sangha governs this smartcontract.
 */
interface IMinter {
    function isCollateral(address addr_) external view returns(bool);
    function redeem(address to, uint256 amount, uint8 round) external returns(uint256);
    function getUsdAmount(uint256, address) external view returns(uint256);
}