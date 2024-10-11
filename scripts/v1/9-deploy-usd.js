// scripts/create-box.js
const { ethers } = require('hardhat')

// temporary on the testnets
const contractName = `Usd`;

async function main() {
  const accounts = await ethers.getSigners()
  let Contract = await ethers.getContractFactory(contractName)
  let contract = await Contract.deploy()
  await contract.waitForDeployment()
  console.log(`Usd token deployed address ${await contract.getAddress()}`)
}

main()
