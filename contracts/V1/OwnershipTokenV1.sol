// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Capped} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract OwnershipTokenV1 is ERC20Capped {
  uint256 public projectId;   // The project its associated with
  address treasury;

  modifier onlyTreasury {
    require(msg.sender == treasury, "not treasury");
    _;
  }

  constructor(uint256 projectId_, uint256 maxSupply_, address treasury_, string memory name_, string memory symbol_) ERC20(name_, symbol_) ERC20Capped(maxSupply_) {
    projectId = projectId_;
    treasury = treasury_;
  }

  function mint(address to_, uint256 amount_) external onlyTreasury {
    _mint(to_, amount_);
  }

}