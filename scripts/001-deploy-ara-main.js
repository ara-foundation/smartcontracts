// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

async function main() {
  let accounts = await ethers.getSigners()
  const ARAAddr = '0x8fAd4d86b6cc14798882B607cD62fbdc3b5a258c'
  const MAINToken = await ethers.getContractFactory('MAINToken')
  const contract = await upgrades.deployProxy(MAINToken, [accounts[0].address, ARAAddr])
  await contract.waitForDeployment()
  console.log('MAINToken deployed to:', await contract.getAddress())
}

main()
