// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Bridge interface.
 * @author Medet Ahmetson <milayter@gmail.com>
 * @notice In the future our bridge to Aranet must be implementing this interface.
 */
interface IBridge {
    function transferOut(uint256, address) external returns (bool);
}