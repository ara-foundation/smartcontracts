// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title Star
 * @notice ERC20 token representing stars in the open source project galaxy
 * @author Medet Ahmetson <medet@ara.foundation>
 */
contract Star is ERC20 {
    // Open source project galaxy address
    address public galaxy;
    // Whether the stars can be transferred
    bool public transfersEnabled;

    struct Coord {
        uint256 x;
        uint256 y;
    }

    // User's position on the galaxy map
    mapping(address => Coord) public coords;

    event PositionSet(address indexed user, uint256 x, uint256 y);

    constructor(string memory name, string memory symbol, address galaxy_) ERC20(name, symbol) {
        galaxy = galaxy_;
        transfersEnabled = false;
    }

    function enableTransfers() external {
        require(msg.sender == galaxy, "only galaxy");
        transfersEnabled = true;
    }

    function setPosition(address user, uint256 x, uint256 y) external returns (bool) {
        require(msg.sender == galaxy, "only galaxy");
        coords[user] = Coord(x, y);
        emit PositionSet(user, x, y);
        return true;
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        require(transfersEnabled, "Transfers disabled");
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        require(transfersEnabled, "Transfers disabled");
        return super.transferFrom(from, to, amount);
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == galaxy, "only galaxy");
        _mint(to, amount);
    }
}

