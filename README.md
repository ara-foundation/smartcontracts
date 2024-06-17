# ARA Project SmartContracts

Script to deploy ARA Token:

```shell
npx hardhat run ./scripts/deploy-ara.js --network testnet
```

- ARA Token deployed to sepolia testnet address: [0x080f9A2FA8996d54ff62Ce841C9390Dc26f6dEf5](https://sepolia.etherscan.io/address/0x080f9A2FA8996d54ff62Ce841C9390Dc26f6dEf5)

- MAIN Token deployed to sepolia testnet address: [0x6B56DafFfA364E1163d5D6cD2487dBeFaE64D115](https://sepolia.etherscan.io/address/0x6B56DafFfA364E1163d5D6cD2487dBeFaE64D115)

- Minter of ARA deployed to sepolia testnet address: [0x6e7F3BD30c9aacFf37e07E790f156D95b52b0834](https://sepolia.etherscan.io/address/0x6e7F3BD30c9aacFf37e07E790f156D95b52b0834)

- CHECK Token deployed to sepolia testnet address: [0xac95cFE35355C90765b5129F0AB1B890DE53bA22](https://sepolia.etherscan.io/address/0xac95cFE35355C90765b5129F0AB1B890DE53bA22)

### Setup

In the minter smartcontract:

1. Set the ara token by calling `setAra`.
2. Set the check token by calling `setCheck`.
3. Set the maintainer token by calling `setMaintainer`.

Then the minter must accept the collaterals.

1. Start accepting collateral by calling `setCollateralInit`.
   As the `feed` use the [Chainlink PriceFeed address](https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1&search=EH#sepolia-testnet) along with it's decimals. Only those who are paired to the USD.

For the native token use the address(0): `0x0000000000000000000000000000000000000000`.

---

## Project Smartcontracts

> Example deployed smartcontracts are:
> `0xe40c7856B6D0e1B01dECBF9976BB706B9Cd1229f` &ndash; WEF (dao) token
> `0x0011764BfeeB78859dD044023AF6b6b6e17715f7` &ndash; frog wars check token
> `0x9e90f6ad0E1916995b8fd6A0AEE36732f7A2A20a` &ndash; frog wars maintainer token

Edit the deployment scripts and set the DAO contract address, and maintainer address

Script to deploy Maintainer Contract:

```shell
npx hardhat run ./scripts/004-deploy-project-main.js --network [network_name]
```

Script to deploy Check Contract:

```shell
npx hardhat run ./scripts/005-deploy-project-check.js --network [network_name]
```

---

Then verify the smartcontracts.

```shell
npx hardhat verify --network mainnet DEPLOYED_CONTRACT_ADDRESS
```

---

Initiate a collateral
