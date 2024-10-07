// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CheckTokenV1 is ERC20 {
  uint256 public projectId;   // The project its associated with
  address public cashier;
  address public act;

  modifier onlyCashier() {
    require(msg.sender == cashier, "not cashier");
    _;
  }

  modifier onlyAct() {
    require(msg.sender == act, "not act");
    _;
  }

  constructor(uint256 projectId_, address cashier_, address act_, string memory name_, string memory symbol_) ERC20(name_, symbol_) {
    projectId = projectId_;
    cashier = cashier_;
    act = act_;
  }

  function burnByCashier(address owner_, uint256 amount_) external onlyCashier() returns(bool) {
    if (balanceOf(owner_) < amount_) {
      return false;
    }
    _burn(owner_, amount_);

    return true;
  }

  function mintByAct(address owner_, uint256 amount_) external onlyAct() returns(bool) {
    _mint(owner_, amount_);
    return true;
  }
}