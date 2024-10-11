// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

const contractName = `MaydoneV1`;
const contractAddr = "0x50059999373F4FbD5b522A2AdC42aEc69EAbadDD";

async function main() {
  let accounts = await ethers.getSigners()
  const Contract = await ethers.getContractFactory(contractName)
  const contract = await upgrades.upgradeProxy(contractAddr, Contract, [])
  await contract.waitForDeployment()
  console.log(`${contractName} upgraded address ${await contract.getAddress()}`)
}

main()
