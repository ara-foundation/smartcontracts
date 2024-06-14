// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVesting {
    function initVesting(address to, uint256 amount) external returns(uint256);
}