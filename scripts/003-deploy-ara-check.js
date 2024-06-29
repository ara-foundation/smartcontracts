// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

async function main() {
  const ARAAddr = '0x8fAd4d86b6cc14798882B607cD62fbdc3b5a258c'
  const MAINAddr = '0xE20A78EFA6A6f14CE1229f2CF34082ABb78e92Fd'
  const MinterAddr = '0x72Ed11B14C69D6C9faE5544dE44e2f9E27D1f81C'
  const Contract = await ethers.getContractFactory('CHECKToken')
  const contract = await upgrades.deployProxy(Contract, [ARAAddr, MAINAddr, MinterAddr])
  await contract.waitForDeployment()
  console.log('Contract deployed to:', await contract.getAddress())
}

main()
