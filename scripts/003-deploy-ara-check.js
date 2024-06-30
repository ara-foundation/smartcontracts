// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

async function main() {
  const ARAAddr = '0x040eEE6D8da3092381Bc9DFaB8fD4A0A9D8eEBDa'
  const MAINAddr = '0x58035DC04D0c05b43396a2d7436F87E5C9F380f6'
  const MinterAddr = '0x2470aEf262166d338788Fef932dCeCCfdDC60206'
  const Contract = await ethers.getContractFactory('CHECKToken')
  const contract = await upgrades.deployProxy(Contract, [ARAAddr, MAINAddr, MinterAddr])
  await contract.waitForDeployment()
  console.log('Contract deployed to:', await contract.getAddress())
}

main()
