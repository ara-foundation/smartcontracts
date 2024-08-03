// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

async function main() {
  const Contract = await ethers.getContractFactory('NftAddon')
  const contract = await upgrades.upgradeProxy('0xd3a9368d98EcA6E8d1Cb8C9D46C9fd132C9d469a', Contract, [])
  await contract.waitForDeployment()
  console.log('Nft Addon upgraded:', await contract.getAddress())
}

main()
