// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

const contractName = `TreasuryV1`;
const contractAddr = "0xD6dffF953AF507C7934F431d7b020d7C253377c3";

async function main() {
  let accounts = await ethers.getSigners()
  const Contract = await ethers.getContractFactory(contractName)
  const contract = await upgrades.upgradeProxy(contractAddr, Contract, [])
  await contract.waitForDeployment()
  console.log(`${contractName} upgraded address ${await contract.getAddress()}`)
}

main()
