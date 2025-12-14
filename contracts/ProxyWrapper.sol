// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

// This is a wrapper to make the proxy compilable by Hardhat
contract ProxyWrapper is TransparentUpgradeableProxy {
    constructor(
        address implementation,
        address admin,
        bytes memory _data
    ) TransparentUpgradeableProxy(implementation, admin, _data) {}
}

