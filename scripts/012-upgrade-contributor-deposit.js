// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

async function main() {
  const Contract = await ethers.getContractFactory('ContributorDeposit')
  const contract = await upgrades.upgradeProxy('0x82CB92b8492FA45b2AaF30d362B6E3feaC9c8E71', Contract, [])
  await contract.waitForDeployment()
  console.log('Contributor Deposit upgraded:', await contract.getAddress())
}

main()
