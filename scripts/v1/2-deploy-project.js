// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

const contractName = `ProjectV1`;

async function main() {
  let accounts = await ethers.getSigners()
  const Contract = await ethers.getContractFactory(contractName)
  const contract = await upgrades.deployProxy(Contract, [])
  await contract.waitForDeployment()
  console.log(`${contractName} deployed address ${await contract.getAddress()}`)
}

main()
