# Ara SmartContracts
Representing open-source projects as galaxies, while users as stars.

### What is Ara?
In Ara, every open-source project is called a galaxy. Once the user's issue is resolved, galaxy distributes the stars to the user, maintainer and contributor. Your goal as the project community is to gather as much stars as possible. Once, star amount exceeds a certain threshold, open-source project in Ara changes it's owner to the star owners: users, collaborators along with the maintainers.

To learn more, and what benefit it has for open-source projects Check the website: https://ara.foundation/


### Sepolia Base Network
Smartcontracts to track on blockchain explorers:
- Etherscan: [All Stars](https://sepolia.basescan.org/address/0xf689f76d8f060c7472b1f0b71c191a1605ab3568)
- Blockscout: [All Stars](https://base-sepolia.blockscout.com/address/0xf689f76d8f060c7472b1f0b71c191a1605ab3568#code)
- Sourcify: [All Stars](https://sourcify.dev/server/repo-ui/84532/0xf689f76d8f060c7472b1f0b71c191a1605ab3568)

# Deploy

Firstly, set the .env based on `.env.example`.

Then deploy the smartcontracts:

```shell
npx hardhat run ./scripts/deploy-all-stars.js --network [network_name]
```
---

Then verify the smartcontracts.

```shell
npx hardhat verify --network [network_name] [deployed_contract_address]
```

---

# Connecting to Smartcontracts
Let's create the Javascript interface for the smartcontracts.
For that we will use the `wagmi`.

- First add the addresses and network in the `/wagmi.config.ts`
- Then, run `npm run wagmi` to re-generate the abi files.
- finally share the `./abis.ts`