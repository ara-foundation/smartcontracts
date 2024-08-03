// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

async function main() {
  const owner = '0x80Cbc1f7fd60B7026C0088e5eD58Fc6Ce1180141';
  const check = '0x1cEB3c60e2E74D6FDDAcDFEE23b8f2C91BBB6996';
  const nft = '0x1D3bd1CfD56954011F9B41085c54389e3161765e'; // Mad Frogs for the Frog Wars game. Addon allows users to convert there game assets into item

  const Contract = await ethers.getContractFactory('NftAddon')
  const contract = await upgrades.deployProxy(Contract, [owner, check, nft])
  await contract.waitForDeployment()
  console.log('Nft Addon deployed to:', await contract.getAddress())
}

main()
