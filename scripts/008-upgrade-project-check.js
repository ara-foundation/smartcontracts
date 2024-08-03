// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

async function main() {
  const Contract = await ethers.getContractFactory('ProjectCheckToken')
  const contract = await upgrades.upgradeProxy('0x1cEB3c60e2E74D6FDDAcDFEE23b8f2C91BBB6996', Contract, [])
  await contract.waitForDeployment()
  console.log('Project Contract upgraded:', await contract.getAddress())
}

main()
