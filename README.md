# ARA Project SmartContracts


Script to deploy ARA Token:

```shell
npx hardhat run ./scripts/deploy-ara.js --network testnet
```
* ARA Token deployed to sepolia testnet address: [0x080f9A2FA8996d54ff62Ce841C9390Dc26f6dEf5](https://sepolia.etherscan.io/address/0x080f9A2FA8996d54ff62Ce841C9390Dc26f6dEf5)

* MAIN Token deployed to sepolia testnet address: [0x6B56DafFfA364E1163d5D6cD2487dBeFaE64D115](https://sepolia.etherscan.io/address/0x6B56DafFfA364E1163d5D6cD2487dBeFaE64D115)

* Minter of ARA deployed to sepolia testnet address: [0x6e7F3BD30c9aacFf37e07E790f156D95b52b0834](https://sepolia.etherscan.io/address/0x6e7F3BD30c9aacFf37e07E790f156D95b52b0834)

* CHECK Token deployed to sepolia testnet address: [0xac95cFE35355C90765b5129F0AB1B890DE53bA22](https://sepolia.etherscan.io/address/0xac95cFE35355C90765b5129F0AB1B890DE53bA22)

### Setup

In the minter smartcontract:

1. Set the ara token by calling `setAra`.
2. Set the check token by calling `setCheck`.
3. Set the maintainer token by calling `setMaintainer`.

Then the minter must accept the collaterals.
1. Start accepting collateral by calling `setCollateralInit`.
As the `feed` use the [Chainlink PriceFeed address](https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1&search=EH#sepolia-testnet) along with it's decimals. Only those who are paired to the USD.

For the native token use the address(0): `0x0000000000000000000000000000000000000000`.