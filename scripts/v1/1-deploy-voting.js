// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

const contractName = `VotingV1`;

async function main() {
  const Contract = await ethers.getContractFactory(contractName)
  const contract = await upgrades.deployProxy(Contract, [])
  await contract.waitForDeployment()
  console.log(`${contractName} deployed address ${await contract.getAddress()}`)
}

main()
