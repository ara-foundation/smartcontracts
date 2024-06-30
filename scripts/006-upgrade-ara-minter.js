// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

async function main() {
  const Contract = await ethers.getContractFactory('Minter')
  const contract = await upgrades.upgradeProxy('0x2470aEf262166d338788Fef932dCeCCfdDC60206', Contract, [])
  await contract.waitForDeployment()
  console.log('Minter deployed to:', await contract.getAddress())
}

main()
