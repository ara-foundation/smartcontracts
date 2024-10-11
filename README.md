# ARA Project SmartContracts

## Visit [Version v1 documentation](./V1.md) as its recent smartcontracts.

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



#### Testnet (BNB Smartchain)

- [Voting V1](https://testnet.bscscan.com/address/0x854b1CB04296594427db0f7e96bcCBC35a05638B)
- [Project V1](https://testnet.bscscan.com/address/0x88be435E8a4cad3cE6E7ABE3468199F03b97B9B3)
- [Treasury V1](https://testnet.bscscan.com/address/0xD6dffF953AF507C7934F431d7b020d7C253377c3)
- [Cashier V1](https://testnet.bscscan.com/address/0x51AED4dC4F45125Db25B5D7FF141D528e8A853B3)
- [Maydone V1](https://testnet.bscscan.com/address/0x50059999373F4FbD5b522A2AdC42aEc69EAbadDD)
- [Act V1](https://testnet.bscscan.com/address/0x959f18544660b8D144D82028faF04d0AD95E9a85)

--- Custom ARA Sangha tokens
- [ARA Token](https://testnet.bscscan.com/token/0x8938B0963333083e6FEBBC350fbf731bFD0401A8)
- [Maintainer Token](https://testnet.bscscan.com/token/0x0f7967Ed6286d1AA03939836a43F3845eb76c690)
- [Check Token](https://testnet.bscscan.com/token/0xF53dc83E9cE56612dd47cA24e7439C204B602A22)

- [Usd](https://testnet.bscscan.com/token/0xE1EA187d652A4496285A971d40bfc346BDf9b854) &ndash; used to test Stable coin with a smaller decimal than Wei.

##### Supported Collateral Tokens (BNB Testnet)
Documentation to add collateral parameters on (Chainlink Price Feed Docs On BNB](https://docs.chain.link/data-feeds/price-feeds/addresses?network=bnb-chain&page=1#bnb-chain-testnet)

#### Polygon Mainnet

- [Voting V1](https://polygonscan.com/address/0x4BAb3be1e10b8601B00032bFf135429fF0AE4B10)
- [Project V1](https://polygonscan.com/address/0x3a93C3A6AF3900b08d01B31c028DA8Aeb7f4CCdA)
- [Treasury V1](https://polygonscan.com/address/0x4a64f4f3536a8486dDb1A72B641AbA6bFa42b952)
- [Cashier V1](https://polygonscan.com/address/0x727d078F25da927e21af87E7FfAB8abdb6E04413)
- [Maydone V1](https://polygonscan.com/address/0x90BB6A77E69a0274Acf5215196De0Bd70F4D7572)
- [Act V1](https://polygonscan.com/address/0x573ce6cbD55E4d05a3b9A6c46C12E4A66Eb24881)

--- Custom ARA Sangha tokens
- [ARA Token](https://polygonscan.com/token/0xFD1629508DE02d9658Bbea0c713884adEdDb1cC0)
- [Maintainer Token](https://polygonscan.bscscan.com/token/0xbA320584bdf861C0a82750f5eF5e2298c81333a5)
- [Check Token](https://polygonscan.bscscan.com/token/0xDF194e4D3d72ba6c6Ce6B2EcbC04AC8Ba399C6A1)

###### Supported Collateral Tokens (Polygon Mainnet)
Documentation to add collateral parameters on (Chainlink Price Feed Docs](https://docs.chain.link/data-feeds/price-feeds/addresses?network=polygon)

#### Mainnet (Base L2)

- ARA Token deployed to Base network: [0x040eEE6D8da3092381Bc9DFaB8fD4A0A9D8eEBDa](https://basescan.org/token/0x040eEE6D8da3092381Bc9DFaB8fD4A0A9D8eEBDa)

- MAIN Token deployed to Base network: [0x58035DC04D0c05b43396a2d7436F87E5C9F380f6](https://basescan.org/token/0x58035DC04D0c05b43396a2d7436F87E5C9F380f6)

- Minter of ARA deployed to Base network: [0x2470aEf262166d338788Fef932dCeCCfdDC60206](https://basescan.org/address/0x2470aEf262166d338788Fef932dCeCCfdDC60206)

- CHECK Token deployed to Base network: [0x9C0aCC45CEcB50444c0Ce3f29e822fEFF64ff401](https://basescan.org/token/0x9C0aCC45CEcB50444c0Ce3f29e822fEFF64ff401)

- Contributor Deposit deployed to Base network: [0x82CB92b8492FA45b2AaF30d362B6E3feaC9c8E71](https://basescan.org/address/0x82CB92b8492FA45b2AaF30d362B6E3feaC9c8E71)

##### Supported Collateral Tokens (BASE)

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

# For other projects (but Ara)

### Setup

1. Deploy Project Check
2. Deploy Project Maintainer
3. Set price setter in Check
3. Set collateral in Check
4. Set collateral price in Check
4. Set new project in Check

3. *Optionally* Deploy Addon

In the minter smartcontract:

1. Set the ara token by calling `setAra`.
2. Set the check token by calling `setCheck`.
3. Set the maintainer token by calling `setMaintainer`.

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

---

## Addon
Addons for the projects, where every user requests specific type of the request.