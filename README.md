# ARA Project SmartContracts

Script to deploy ARA Token:

```shell
npx hardhat run ./scripts/000-deploy-ara-token.js --network NETWORK_NAME
```

### Deployed smartcontracts

#### Testnet (Sepolia)

- ARA Token deployed to sepolia testnet address: [0x080f9A2FA8996d54ff62Ce841C9390Dc26f6dEf5](https://sepolia.etherscan.io/address/0x080f9A2FA8996d54ff62Ce841C9390Dc26f6dEf5)

- MAIN Token deployed to sepolia testnet address: [0x6B56DafFfA364E1163d5D6cD2487dBeFaE64D115](https://sepolia.etherscan.io/address/0x6B56DafFfA364E1163d5D6cD2487dBeFaE64D115)

- Minter of ARA deployed to sepolia testnet address: [0x6e7F3BD30c9aacFf37e07E790f156D95b52b0834](https://sepolia.etherscan.io/address/0x6e7F3BD30c9aacFf37e07E790f156D95b52b0834)

- CHECK Token deployed to sepolia testnet address: [0xac95cFE35355C90765b5129F0AB1B890DE53bA22](https://sepolia.etherscan.io/address/0xac95cFE35355C90765b5129F0AB1B890DE53bA22)

#### Mainnet (Base L2)

- ARA Token deployed to Base network: [0x040eEE6D8da3092381Bc9DFaB8fD4A0A9D8eEBDa](https://basescan.org/token/0x040eEE6D8da3092381Bc9DFaB8fD4A0A9D8eEBDa)

- MAIN Token deployed to Base network: [0x58035DC04D0c05b43396a2d7436F87E5C9F380f6](https://basescan.org/token/0x58035DC04D0c05b43396a2d7436F87E5C9F380f6)

- Minter of ARA deployed to Base network: [0x2470aEf262166d338788Fef932dCeCCfdDC60206](https://basescan.org/address/0x2470aEf262166d338788Fef932dCeCCfdDC60206)

- CHECK Token deployed to Base network: [0x9C0aCC45CEcB50444c0Ce3f29e822fEFF64ff401](https://basescan.org/token/0x9C0aCC45CEcB50444c0Ce3f29e822fEFF64ff401)

##### Supported Collateral Tokens

- [Circle USD Stablecoin](https://basescan.org/token/0x833589fcd6edb6e08f4c7c32d4f71b54bda02913)
- [ETH](https://basescan.org/chart/price)

### Setup

In the minter smartcontract:

1. Set the ara token by calling `setAra`.
2. Set the check token by calling `setCheck`.
3. Set the maintainer token by calling `setMaintainer`.

Then the minter must accept the collaterals.

1. Start accepting collateral by calling `setCollateralInit`.
   As the `feed` use the [Chainlink PriceFeed address](https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1&search=EH#sepolia-testnet) along with it's decimals. Only those who are paired to the USD.

For the native token use the address(0): `0x0000000000000000000000000000000000000000`.

In the Ara token, grant the Minter a Minter role.

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

Update wagmi config on the UI.

- First add the addresses and network in the `packages/app/wagmi.config.ts`
- Then, head to the `packages/app`, and call `npm run wagmi` to re-generate the abi files.

---

Initiate a collateral
