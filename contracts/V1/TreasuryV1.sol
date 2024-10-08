// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {ReentrancyGuardUpgradeable}  from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SharedV1} from "./SharedV1.sol";
import {OwnershipTokenV1} from "./OwnershipTokenV1.sol";
import {VotingV1} from "./VotingV1.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title Treasury has the mint permission to mint tokens.
 * @author Medet Ahmetson <milayter@gmail.com>
 * @notice Ara Sangha governs this smartcontract.
 */
contract TreasuryV1 is SharedV1, OwnableUpgradeable, ReentrancyGuardUpgradeable {
    // Price feeds are taken from
    // https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum
    struct Collateral {
        uint8 feedDecimals;
        uint8 tokenDecimals;
        address feedAddr;
        uint256 votingId;
        bool approved;
    }

    struct OwnershipLedger {
        uint256 cap;            // max supply of ownership tokens. we assume that token decimals are 18
        uint256 pricePerToken; // in USD;
        uint256 minted;
    }

    Sangha public araSangha;
    address public maydone;
    VotingV1 public voting;
    address public cashier;
    
    mapping (uint256 => OwnershipLedger) public balances;
    mapping (uint256 => Sangha) public sanghas;
    mapping (address => Collateral) public collaterals;

    // The following is the temporary.
    // We need to transfer fee to all Ara holders in the future.
    uint256 public araFee;
    address public araFeeReceiver;

    event CollateralVotingInit(address indexed initializer, address indexed token, uint8 decimals, address feed, uint8 feedDecimals);
    event CollateralVote(address indexed token, address voter, bool agree);
    event CollateralVotingAction(address indexed token, bool agree);

    event SetProject(uint256 indexed projectId, uint256 tokenAmount, uint256 usdAmount);
    event Mint(uint256 indexed projectId_, address ownershipToken, uint256 ownershipAmount, address to, uint256 usdAmount, address collateral, uint256 collateralAmount);

    modifier onlyMaintainer() {
        require(IERC20(araSangha.maintainer).balanceOf(msg.sender) > 0, "no maintainer");
        _;
    }

    modifier onlyMaydone() {
        require(msg.sender == maydone, "not maydone");
        _;
    }

    modifier onlyAra() {
        require(IERC20(araSangha.ownership).balanceOf(msg.sender) > 0, "no ara");
        _;
    }

    modifier onlyCashier() {
        require(msg.sender == cashier, "not cashier");
        _;
    }

    modifier validProjectId(uint256 projectId) {
        require(balances[projectId].cap > 0, "invalid");
        _;
    }

    modifier validCollateral(address tokenAddress) {
        require(collaterals[tokenAddress].approved, "not approved collateral");
        _;
    }

    function initialize() initializer public {
        // Once we deploy the client to allow deploying upgradeable contracts,
        // we will change the owner.
        __Ownable_init(msg.sender);
        __ReentrancyGuard_init();

        araFee = 10; // in percents from 100
        araFeeReceiver = msg.sender;
    }

    function getAraFee() external view returns(uint256) {
        return araFee;
    }

    function setMaydone(address maydone_) external onlyOwner {
        maydone = maydone_;
    }

    function setVoting(address voting_) external onlyOwner {
        voting = VotingV1(voting_);
    }

    function setCashier(address cashier_) external onlyOwner {
        cashier = cashier_;
    }

    function setProject(uint256 projectId_, uint256 cap_, uint256 cost_, Sangha calldata sangha_) external onlyMaydone {
        sanghas[projectId_] = sangha_;
        balances[projectId_].cap = cap_;
        balances[projectId_].pricePerToken = cost_ * (10 ** 18)/cap_;

        emit SetProject(projectId_, cap_, cost_);
    }

    function setPricePerToken(uint256 projectId_, uint256 cap_, uint256 cost_) external onlyOwner {
        require(balances[projectId_].pricePerToken == 0, "already set");
        balances[projectId_].pricePerToken = cost_ * (10 ** 18)/cap_;
        emit SetProject(projectId_, cap_, cost_);
    }

    function setAraSangha(Sangha calldata sangha_) external onlyOwner {
        araSangha = sangha_;
    }

    /**
     * Mint ownership tokens by usd amount
     */
    function mintByUsd(uint256 projectId_, address to_, uint256 usdAmount_, address collateral_) public validProjectId(projectId_) validCollateral(collateral_) nonReentrant payable {
        require(usdAmount_ > 0, "zero amount");
        uint256 totalCollateralAmount = getCollateralAmount(usdAmount_, collateral_);
        require(totalCollateralAmount > 0, "0 collateral was given");

        OwnershipLedger storage balance = balances[projectId_];

        uint256 ownershipTokenAmount = usdAmount_ / balance.pricePerToken * 1e18;
        require(balance.minted + ownershipTokenAmount <= balance.cap, "exceeds the cap");

        balance.minted += ownershipTokenAmount;

        uint256 collateralAmount = totalCollateralAmount;
        uint256 feeAmount = 0;
        if (araFee > 0) {
            collateralAmount = totalCollateralAmount / 100 * (100 - araFee);
            feeAmount = totalCollateralAmount / 100 * araFee;
        }
        
        // Let's receive the collaterals first.
        if (collateral_ == address(0)) {
            require(msg.value >= totalCollateralAmount, "invalid collateralAmount for eth");
            uint256 remaining = msg.value - totalCollateralAmount;
            if (remaining > 0) {
                owner().call{value: remaining}("");
            }
            if (feeAmount > 0)
                araFeeReceiver.call{value: feeAmount}("");
        } else {
            require(IERC20(collateral_).transferFrom(msg.sender, address(this), collateralAmount), "failed to transfer");
            if (feeAmount > 0) {
                require(IERC20(collateral_).transferFrom(msg.sender, araFeeReceiver, feeAmount), "failed to transfer");
            }
        }

        OwnershipTokenV1(sanghas[projectId_].ownership).mint(to_, ownershipTokenAmount);

        emit Mint(projectId_, sanghas[projectId_].ownership, ownershipTokenAmount, to_, usdAmount_, collateral_, totalCollateralAmount);
    
    }

    /**
     * Mint ownership tokens of the project by the collateral that user provides.
     * 
     * TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST decimals
     * @param to_ receiver of the minted tokens
     * @param totalCollateralAmount of tokens user wants to put in collateral.
     */
    function mintByCollateral(uint256 projectId_, address to_, uint256 totalCollateralAmount, address collateral) public validProjectId(projectId_) validCollateral(collateral) nonReentrant payable {
        require(totalCollateralAmount > 0, "zero amount");
        uint256 usdAmount = getUsdAmount(totalCollateralAmount, collateral);
        require(usdAmount > 0, "0 dollar was given");

        OwnershipLedger storage balance = balances[projectId_];

        uint256 ownershipTokenAmount = usdAmount / balance.pricePerToken * 1e18;
        require(balance.minted + ownershipTokenAmount <= balance.cap, "exceeds the cap");

        balance.minted += ownershipTokenAmount;

        uint256 collateralAmount = totalCollateralAmount;
        uint256 feeAmount = 0;
        if (araFee > 0) {
            collateralAmount = totalCollateralAmount / 100 * (100 - araFee);
            feeAmount = totalCollateralAmount / 100 * araFee;
        }

        // Let's receive the collaterals first.
        if (collateral == address(0)) {
            require(msg.value >= totalCollateralAmount, "invalid collateralAmount for eth");
            uint256 remaining = msg.value - totalCollateralAmount;
            if (remaining > 0) {
                owner().call{value: remaining}("");
            }
            if (feeAmount > 0)
                araFeeReceiver.call{value: feeAmount}("");
        } else {
            require(IERC20(collateral).transferFrom(msg.sender, address(this), collateralAmount), "failed to transfer");
            if (feeAmount > 0) {
                require(IERC20(collateral).transferFrom(msg.sender, araFeeReceiver, feeAmount), "failed to transfer");
            }
        }

        OwnershipTokenV1(sanghas[projectId_].ownership).mint(to_, ownershipTokenAmount);

        emit Mint(projectId_, sanghas[projectId_].ownership, ownershipTokenAmount, to_, usdAmount, collateral, collateralAmount);
    }

    function redeem(address to_, uint256 usdAmount_, address collateral_) external onlyCashier() returns(uint) {
        require(isCollateral(collateral_), "not collateral");

        uint256 collateralAmount = getCollateralAmount(usdAmount_, collateral_);
        require(collateralAmount > 0, "0 collateral was given");

        if (address(0) == collateral_) {
            (bool sent, ) = (to_).call{value: collateralAmount}("");
            require(sent, "not sent");
        } else {
            IERC20(collateral_).transfer(to_, collateralAmount);
        }

        return collateralAmount;
    }

    /////////////////////////////////////////////////////////////////////////////////
    //
    // Sangha functionality
    //
    /////////////////////////////////////////////////////////////////////////////////

    /**
     * Start a voting to add a new collateral.
     */
    function setCollateralInit(address token, uint8 decimals, address feed, uint8 feedDecimals) public onlyMaintainer {
        require(decimals > 0 && feedDecimals > 0 && feed != address(0), "0 parameter");
        require(collaterals[token].approved == false && collaterals[token].votingId == 0, "already added");

        string memory payload = string.concat("add a new collateral: ", Strings.toHexString(token));

        collaterals[token] = Collateral(feedDecimals, decimals, feed, 0, false);
        collaterals[token].votingId = voting.startVoting(msg.sender, araSangha.maintainer, araSangha.ownership, payload);

        emit CollateralVotingInit(msg.sender, token, decimals, feed, feedDecimals);
    }

    function setCollateralVote(address token, bool agree) public onlyAra {
        require(collaterals[token].votingId > 0, "no voting");
        require(voting.vote(collaterals[token].votingId, msg.sender, agree), "failed to vote");

        emit CollateralVote(token, msg.sender, agree);
    }

    function setCollateralAction(address token) public onlyMaintainer {
        Collateral storage collateral = collaterals[token];
        require(collateral.votingId > 0, "no voting");
        require(voting.isEndable(collateral.votingId), "not endable");

        collateral.approved = voting.endVoting(collateral.votingId, msg.sender); 
        collateral.votingId = 0;       
        
        emit CollateralVotingAction(token, collateral.approved);
    }

    function isCollateral(address addr_) public view returns(bool) {
        return collaterals[addr_].approved;
    }

    /////////////////////////////////////////////////////////////////////////////////
    //
    // Helper functions
    //
    /////////////////////////////////////////////////////////////////////////////////

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
            require(usdAmount > 0, "0usd");
            if (collateralData.feedDecimals != 18) {
                uint8 dif = 18 - collateralData.feedDecimals;
                usdAmount *= 10 ** uint256(dif);
            }
        } else {
            if (collateralData.feedDecimals > collateralData.tokenDecimals) {
                uint8 dif = collateralData.feedDecimals - collateralData.tokenDecimals;
                usdAmount = uint256(answer) * (collateralAmount * 10 ** uint256(dif)) / (10**uint256(collateralData.feedDecimals));
                if (collateralData.feedDecimals != 18) {
                    uint8 dif18 = 18 - collateralData.feedDecimals;
                    usdAmount *= 10 ** uint256(dif18);
                }
            } else {
                uint8 dif = collateralData.tokenDecimals - collateralData.feedDecimals;
                usdAmount = (uint256(answer) * 10 ** uint256(dif)) * collateralAmount / (10**uint256(collateralData.tokenDecimals));
                if (collateralData.tokenDecimals != 18) {
                    uint8 dif18 = 18 - collateralData.tokenDecimals;
                    usdAmount *= 10 ** uint256(dif18);
                }
            }
        }

        return usdAmount;
    }

    /**
     * Returns collateral equivalent of the usd dollars.
     * 
     * For example in ETH. Assume 1 Eth is $3806.39.
     * User passed $300.
     * This function will return 0.079 ETH
     * @param usdAmount_ amount of USD
     * @param collateral_ collateral that user puts in.
     * @notice It depends on the PriceFeeds of the Chainlink.
     * @dev It converts the digits to 10**18
     */
    function getCollateralAmount(uint256 usdAmount_, address collateral_) public view returns(uint256) {
        Collateral memory collateralData = collaterals[collateral_];

        // get price of token
        AggregatorV3Interface dataFeed = AggregatorV3Interface(collateralData.feedAddr);
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();

        require(answer > 0, "0 price feed");
        uint256 price = uint256(answer);
        if (collateralData.feedDecimals != 18) {
            uint8 dif = 18 - collateralData.feedDecimals;
            price *= 10 ** uint256(dif);
        }

        uint256 collateralAmount = (usdAmount_ * 10 ** 18) / uint256(price);

        if (collateralData.tokenDecimals != 18) {
            uint8 dif18 = 18 - collateralData.tokenDecimals;
            collateralAmount /= 10 ** uint256(dif18);
        }

        return collateralAmount;
    }

}