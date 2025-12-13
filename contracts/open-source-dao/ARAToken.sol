// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20CappedUpgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20CappedUpgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract ARAToken is ERC20CappedUpgradeable, AccessControlUpgradeable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    function initialize() initializer public {
      __ERC20_init("ARA", "ARA");
	    __ERC20Capped_init(75000000000000000000000000);
 	    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
      _mint(msg.sender, 1000000000000000000);   // Mint 1 ARA to setup the configurations
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
      _mint(to, amount);
    }

    function burn(uint256 amount) public {
      _burn(msg.sender, amount);
    }
}