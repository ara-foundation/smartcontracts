// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

async function main() {
  const Contract = await ethers.getContractFactory('CHECKToken')
  const contract = await upgrades.upgradeProxy('0x9C0aCC45CEcB50444c0Ce3f29e822fEFF64ff401', Contract, [])
  await contract.waitForDeployment()
  console.log('Minter deployed to:', await contract.getAddress())
}

main()
