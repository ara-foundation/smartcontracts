const { ethers } = require('hardhat')

async function main() {
  let accounts = await ethers.getSigners()

  const DaoAddr = process.env.PROJECT_DAO
  const name = 'FrogWifCat Maintainer'
  const symbol = 'wfMAIN'

  const MAINToken = await ethers.getContractFactory('ProjectMainToken')
  const contract = await MAINToken.deploy(accounts[0].address, DaoAddr, name, symbol, { gasPrice: '72750007' })
  await contract.waitForDeployment()
  console.log('Project Main token deployed to:', await contract.getAddress())
}

main()
