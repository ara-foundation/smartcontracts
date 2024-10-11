// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MaintainerTokenV1 is ERC20 {
  uint256 public projectId;   // The project its associated with
  address public ownership;

  constructor(uint256 projectId_, address leader, address ownership_, string memory name_, string memory symbol_) ERC20(name_, symbol_) {
    projectId = projectId_;
    _mint(leader, 100000000000000000000000); // 100_000 MAINTAINER tokens
    ownership = ownership_;
  }
}