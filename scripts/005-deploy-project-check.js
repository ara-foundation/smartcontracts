// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

async function main() {
  const DaoAddr = '0xe40c7856B6D0e1B01dECBF9976BB706B9Cd1229f'
  const MAINAddr = '0x9e90f6ad0E1916995b8fd6A0AEE36732f7A2A20a'

  const name = 'FrogWifCat Check'
  const symbol = 'wfCHECK'

  const Contract = await ethers.getContractFactory('ProjectCheckToken')
  const contract = await upgrades.deployProxy(Contract, [DaoAddr, MAINAddr, name, symbol])
  await contract.waitForDeployment()
  console.log('Project Check Token deployed to:', await contract.getAddress())
}

main()
