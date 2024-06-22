// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

async function main() {
  const DaoAddr = process.env.PROJECT_DAO
  const MAINAddr = '0x6921482cEf17ecd8382A96B4e6E3749a9B6fcFd0'

  const name = 'FrogWifCat Check'
  const symbol = 'wfCHECK'

  const Contract = await ethers.getContractFactory('ProjectCheckToken')
  const contract = await upgrades.deployProxy(Contract, [DaoAddr, MAINAddr, name, symbol])
  await contract.waitForDeployment()
  console.log('Project Check Token deployed to:', await contract.getAddress())
}

main()
