// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

async function main() {
  let accounts = await ethers.getSigners()
  const ARAAddr = '0x040eEE6D8da3092381Bc9DFaB8fD4A0A9D8eEBDa'
  const MAINToken = await ethers.getContractFactory('MAINToken')
  const contract = await upgrades.deployProxy(MAINToken, [accounts[0].address, ARAAddr])
  await contract.waitForDeployment()
  console.log('MAINToken deployed to:', await contract.getAddress())
}

main()
