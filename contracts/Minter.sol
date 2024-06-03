// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {IARAToken} from "./IARAToken.sol";
import {IVesting} from "./IVesting.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Minter is the bridge between Treasury and Ara token.
 * @author Medet Ahmetson <milayter@gmail.com>
 * @notice Ara Sangha governs this smartcontract.
 */
contract Minter is Ownable {
    uint256 public constant VOTING_PERIOD = 864000;

    // Price feeds are taken from
    // https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum
    struct Collateral {
        uint8 feedDecimals;
        uint8 tokenDecimals;
        address feedAddr;
    }

    struct Round {
        uint256 cap;
        uint256 pricePerToken; // in USD;
        uint256 minted;
        uint256 minUsd;         // minimum amount of collateral that user must invest
        uint256 maxUsd;         // maximum amount of collateral that user must invest
    }

    struct BridgeVoting {
        address bridge;
        uint256 timeStart;
        bool actionTaken;
        uint256 countYes;
        uint256 countNo;
        mapping (address => bool) voted;
    }

    struct CollateralVoting {
        Collateral params;
        uint256 timeStart;
        bool actionTaken;
        uint256 countYes;
        uint256 countNo;
        mapping (address => bool) voted;
    }

    uint256 public noBridgeEndTime;
    address public bridge;
    address public araToken;
    address public checkToken;
    address public mainToken;
    address public treasury;        // same as check token
    address[8] public vestingContracts;
    BridgeVoting public bridgeVoting;

    mapping (address => Collateral) public collaterals;
    mapping (uint8 => Round) public rounds;
    mapping (uint8 => address) public vestings;
    mapping (address => CollateralVoting) public collateralVotings;

    event Mint(address indexed to, address collateral, uint256 araAmount, uint256 usdAmount, uint8 round, uint256 vestingId);
    event BridgeVotingInit(address indexed initializer, address indexed bridge);
    event BridgeVote(address indexed voter, uint256 votePower, bool agree);
    event BridgeVotingAction(address bridge, bool agree);

    event CollateralVotingInit(address indexed initializer, address indexed token, uint8 decimals, address feed, uint8 feedDecimals);
    event CollateralVote(address indexed voter, address token, uint256 votePower, bool agree);
    event CollateralVotingAction(address token, bool agree);

    modifier onlyBridge() {
        require(msg.sender == bridge, "not a bridge");
        _;
    }

    modifier onlyMaintainer() {
        require(IERC20(mainToken).balanceOf(msg.sender) > 0, "no maintainer");
        _;
    }

    modifier onlyCheck() {
        require(IERC20(checkToken).balanceOf(msg.sender) > 0, "no check");
        _;
    }

    modifier onlyAra() {
        require(IERC20(araToken).balanceOf(msg.sender) > 0, "no ara");
        _;
    }

    modifier afterTwoYears() {
        require(block.timestamp > noBridgeEndTime, "");
        _;
    }

    modifier validRound(uint8 round) {
        require(round >= 1 && round <= 5 || round == 7, "invalid round");
        _;
    }

    modifier validCollateral(address tokenAddress) {
        require(collaterals[tokenAddress].feedDecimals > 0, "invalid collateral");
        _;
    }

    constructor() Ownable(msg.sender) {
        noBridgeEndTime = block.timestamp + 63072000; // 2 years after today

        // First Round (Testing) = 0.024$/ARA, 12_500 Cap
        rounds[1] = Round(24000000000000000, 12500000000000000000000, 0, 0, 0);

        // Second Round (Initial Set Up/Grant) = 0.1$/ARA, 87_500 Cap
        rounds[2] = Round(100000000000000000, 87500000000000000000000, 0, 0, 0);

        // Third Round (Angel Investment) = 0.18$/ARA, 1_900_000 Cap, 10,000$ min, 45,500$ max
        rounds[3] = Round(180000000000000000, 1900000000000000000000000, 0, 10000000000000000000000, 45500000000000000000000);

        // Fourth Round (A Series) = 0.2$/ARA, 18_000_000 Cap, 10,000$ min, 60,000$ max
        rounds[4] = Round(200000000000000000, 18000000000000000000000000, 0, 10000000000000000000000, 60000000000000000000000);

        // Fifth Round (B Series) = 0.22$/ARA, 12_500_000 Cap
        rounds[5] = Round(220000000000000000, 12500000000000000000000000, 0, 0, 0);

        // Sixth Round (Savings) = 0$/ARA, 10_000_000 Cap, 10,000$ min, 60,000$ max
        rounds[6] = Round(0, 10000000000000000000000000, 0, 10000000000000000000000, 60000000000000000000000);

        // Seventh Round (Public Exchanges) = 0.24$/ARA, 32_500_000 Cap
        rounds[7] = Round(240000000000000000, 32500000000000000000000000, 0, 0, 0);
    }

    /**
     * Mint function is called by anyone.
     * This function mints ARA token in exchange for the collateral.
     * @param to Minting to this smartcontract
     * @param collateralAmount of tokens user wants to put in collateral.
     * @return sessionId if it was send to the Vesting smartcontract.
     */
    function mint(address to, uint256 collateralAmount, uint8 round, address collateral) public validRound(round) validCollateral(collateral) payable returns (uint256) {
        require(treasury != address(0), "no treasury");
        require(collateralAmount > 0, "zero amount");
        // get amount of tokens needed from user as collateral by round
        uint256 usdAmount = getUsdAmount(collateralAmount, collateral);
        require(usdAmount > 0, "0 dollar was given");

        uint256 araAmount = getAraAmount(round, usdAmount);
        require(rounds[round].minted + araAmount < rounds[round].cap, "exceeds the cap");

        if (rounds[round].minUsd > 0) {
            require(usdAmount >= rounds[round].minUsd, "less than minimum");
        }
        if (rounds[round].maxUsd > 0) {
            require(usdAmount <= rounds[round].maxUsd, "exceeds the maximum");
        }

        if (collateral == address(0)) {
            require(msg.value == collateralAmount, "invalid collateralAmount for eth");
            payable(treasury).transfer(collateralAmount);
        } else {
            require(IERC20(collateral).transferFrom(msg.sender, treasury, collateralAmount), "failed to transfer");
        }

        IARAToken(araToken).mint(address(this), araAmount);

        rounds[round].minted += araAmount;

        uint256 vestingId = 0;

        if (isVestingRound(round)) {
            address vestingAddr = vestings[round];
            IERC20(araToken).approve(vestingAddr, araAmount);
            vestingId = IVesting(vestingAddr).initVesting(to, araAmount);
            require(vestingId > 0, "no vesting id");
        } else {
            IERC20(araToken).transfer(to, araAmount);
        }
        
        emit Mint(to, collateral, araAmount, usdAmount, round, vestingId);

        return vestingId;
    }

    /**
     * This function mints tokens and gives them to the user.
     * @param to Mint and give to this account
     * @param amount of ARA token to mint
     */
    function bridgeIn(address to, uint256 amount) public onlyBridge {
        IARAToken(araToken).mint(to, amount);
    }

    /**
     * This function burns the tokens and gives them to the bridge to transfer.
     * @param to Mint and give to this account
     * @param amount of ARA token to mint
     */
    function bridgeOut(address to, uint256 amount) public onlyBridge {
        IERC20(araToken).transferFrom(to, address(this), amount);
        IARAToken(araToken).burn(amount);
    }

    /**
     * This function allows minting ARA tokens from CHECK tokens.
     * Each check token worth 0.24$
     * @param amount is the CHECK token amount each worth 0.24$
     */
    function redeem(address to, uint256 amount, uint8 round) public onlyCheck returns(uint256) {
        uint256 araAmount = amount * 1000000000000000000 / rounds[round].pricePerToken;
        require(rounds[round].minted + araAmount < rounds[round].cap, "exceeds the cap");

        IARAToken(araToken).mint(address(this), araAmount);
        rounds[round].minted += araAmount;

        uint256 vestingId = 0;

        if (isVestingRound(round)) {
            address vestingAddr = vestings[round];
            IERC20(araToken).approve(vestingAddr, araAmount);
            vestingId = IVesting(vestingAddr).initVesting(to, araAmount);
            require(vestingId > 0, "no vesting id");
        } else {
            IERC20(araToken).transfer(to, araAmount);
        }
        
        emit Mint(to, address(0x01), araAmount, amount, round, vestingId);

        return vestingId;
    }

    /////////////////////////////////////////////////////////////////////////////////
    //
    // Sangha functionality
    //
    /////////////////////////////////////////////////////////////////////////////////

    // Bridge Address is set by voting.
    // Duration is 10 days.
    function setBridgeInit(address bridge_) public afterTwoYears onlyMaintainer {
        if (bridgeVoting.timeStart > 0) {
            require(bridgeVoting.actionTaken, "bridge voting goes on");
        }
        bridgeVoting.timeStart = block.timestamp;
        bridgeVoting.bridge = bridge_;

        emit BridgeVotingInit(msg.sender, bridge_);
    }

    function setBridgeVote(bool agree) public onlyAra {
        require(bridgeVoting.timeStart > 0, "session not found");
        require(bridgeVoting.voted[msg.sender] == false, "you already voted");
        require(bridgeVoting.timeStart + VOTING_PERIOD > block.timestamp
        || bridgeVoting.actionTaken == false, "voting finished");

        if (agree) {
          bridgeVoting.countYes += IERC20(araToken).balanceOf(msg.sender);
        }
        else {
          bridgeVoting.countNo += IERC20(araToken).balanceOf(msg.sender);
        }
        
        bridgeVoting.voted[msg.sender] = true;

        emit BridgeVote(msg.sender, IERC20(araToken).balanceOf(msg.sender), agree);
    }

    function setBridgeAction() public onlyMaintainer {
        require(bridgeVoting.timeStart > 0, "session not found");
        require(canBridgeVotingTakeAction(),  "can't take action");
        require(bridgeVoting.actionTaken == false, "voting finished");
        
        if (bridgeVoting.countYes > bridgeVoting.countNo) {
          bridge = bridgeVoting.bridge;
        }
        bridgeVoting.actionTaken = true;

        emit BridgeVotingAction(bridgeVoting.bridge, bridgeVoting.countYes > bridgeVoting.countNo);
    }

    function setCollateralInit(address token, uint8 decimals, address feed, uint8 feedDecimals) public onlyMaintainer {
        require(decimals > 0 && feedDecimals > 0 && feed != address(0), "0 parameter");
        require(collaterals[token].feedDecimals == 0, "already added");
        if (collateralVotings[token].params.feedDecimals > 0) {
            require(collateralVotings[token].actionTaken, "voting goes on");
        }

        collateralVotings[token].params = Collateral(feedDecimals, decimals, feed);
        collateralVotings[token].timeStart = block.timestamp;

        emit CollateralVotingInit(msg.sender, token, decimals, feed, feedDecimals);
    }

    function setCollateralVote(address token, bool agree) public onlyAra {
        CollateralVoting storage collateralVoting = collateralVotings[token];
        require(collateralVoting.timeStart > 0, "session not found");
        require(collateralVoting.voted[msg.sender] == false, "you already voted");
        require(collateralVoting.timeStart + VOTING_PERIOD > block.timestamp
        || collateralVoting.actionTaken == false, "voting finished");

        uint256 votePower = IERC20(araToken).balanceOf(msg.sender);

        if (agree) {
          collateralVoting.countYes += votePower;
        }
        else {
          collateralVoting.countNo += votePower;
        }
        
        collateralVoting.voted[msg.sender] = true;
        
        emit CollateralVote(msg.sender, token, votePower, agree);
    }

    function setCollateralAction(address token) public onlyMaintainer {
        CollateralVoting storage collateralVoting = collateralVotings[token];
        require(collateralVoting.timeStart > 0, "session not found");
        require(canCollateralTakeAction(collateralVoting),  "can't take action");
        require(collateralVoting.actionTaken == false, "voting finished");
        
        if (collateralVoting.countYes > collateralVoting.countNo) {
          bridge = bridgeVoting.bridge;
        }
        collateralVoting.actionTaken = true;
        
        emit CollateralVotingAction(token, collateralVotings[token].countYes > collateralVotings[token].countNo);
    }

    function setCheck(address addr_) public onlyOwner {
        require(checkToken == address(0), "already set");

        checkToken = addr_;
        treasury = addr_;
    }

    function setAra(address addr_) public onlyOwner {
        require(araToken == address(0), "already set");

        araToken = addr_;
    }

    function setVesting(uint8 round, address addr_) public validRound(round) onlyOwner {
        require(isVestingRound(round), "not a vesting round");
        require(vestings[round] == address(0), "already set");

        vestings[round] = addr_;
    }

    function setMaintainer(address addr_) public onlyOwner {
        require(mainToken == address(0), "already set");

        mainToken = addr_;
    }

    function isCollateral(address addr_) external view returns(bool) {
        return collaterals[addr_].feedDecimals > 0;
    }

    /////////////////////////////////////////////////////////////////////////////////
    //
    // Helper functions
    //
    /////////////////////////////////////////////////////////////////////////////////

    function isVestingRound(uint8 round) internal pure returns(bool) {
        return (round >= 3 && round <= 5);
    }

    /**
     * Returns USD equivalent of the collateral.
     * For example collateralAmount is 0.079 ETH, when 1 ETH price equal to $3806.39;
     * This function returns $300.
     * @param collateralAmount amount of tokens
     * @param collateral collateral that user puts in.
     * @notice It depends on the PriceFeeds of the Chainlink.
     * @dev It converts the digits to 10**18
     */
    function getUsdAmount(uint256 collateralAmount, address collateral) public view returns(uint256) {
        Collateral memory collateralData = collaterals[collateral];

        // get price of token
        AggregatorV3Interface dataFeed = AggregatorV3Interface(collateralData.feedAddr);
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();

        uint256 usdAmount = 0;
        if (collateralData.feedDecimals == collateralData.tokenDecimals) {
            usdAmount = uint256(answer) * collateralAmount / (10**collateralData.tokenDecimals);
            if (collateralData.feedDecimals != 18) {
                uint8 dif = 18 - collateralData.feedDecimals;
                usdAmount *= 10 ** uint256(dif);
            }
        } else {
            if (collateralData.feedDecimals > collateralData.tokenDecimals) {
                uint8 dif = collateralData.feedDecimals - collateralData.tokenDecimals;
                usdAmount = uint256(answer) * (collateralAmount * 10 ** uint256(dif)) / 1000000000000000000;
            } else {
                uint8 dif = collateralData.tokenDecimals - collateralData.feedDecimals;
                usdAmount = (uint256(answer) * 10 ** uint256(dif)) * collateralAmount / 1000000000000000000;
            }
        }

        return usdAmount;
    }

    // Returns amount of ARA Token for the given collateral token.
    function getAraAmount(uint8 round, uint256 usdAmount) public view returns(uint256) {
        uint256 araAmount = usdAmount / rounds[round].pricePerToken * 1e18;
        return araAmount;
    }

    function canBridgeVotingTakeAction() internal view returns (bool) {
        uint256 halfSupply = IERC20(araToken).totalSupply() / 2;
        if (bridgeVoting.timeStart + VOTING_PERIOD > block.timestamp) return true;   
        return (bridgeVoting.countNo > halfSupply || bridgeVoting.countYes > halfSupply);
    }

    function canCollateralTakeAction(CollateralVoting storage collateralVoting) internal view returns (bool) {
        uint256 halfSupply = IERC20(araToken).totalSupply() / 2;
        if (collateralVoting.timeStart + VOTING_PERIOD > block.timestamp) return true;   
        return (collateralVoting.countNo > halfSupply || collateralVoting.countYes > halfSupply);
    }
}