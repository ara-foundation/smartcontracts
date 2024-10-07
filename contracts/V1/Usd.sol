// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Usd is ERC20 {
  constructor() ERC20("Ara Self Bank", "DOLLAR") {
    _mint(msg.sender, 100000000000); // 100_000 MAINTAINER tokens
  }

   function decimals() public view virtual override returns (uint8) {
        return 6;
    }
}