// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IMAINToken} from "../IMAINToken.sol";

/**
 * @title ProjectCheckToken is the payment check issued to contributors by MAINToken holders
 * @author Medet Ahmetson <medet@ara.foundation>
 * @dev Requires ARAToken, MAINToken smartcontracts
 */
interface IAddon {
  function setProjectId(uint256 projectId_) external;
}