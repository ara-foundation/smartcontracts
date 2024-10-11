// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

const contractName = `ProjectV1`;
const contractAddr = "0x88be435E8a4cad3cE6E7ABE3468199F03b97B9B3";

async function main() {
  let accounts = await ethers.getSigners()
  const Contract = await ethers.getContractFactory(contractName)
  const contract = await upgrades.upgradeProxy(contractAddr, Contract, [])
  await contract.waitForDeployment()
  console.log(`${contractName} upgraded address ${await contract.getAddress()}`)
}

main()
