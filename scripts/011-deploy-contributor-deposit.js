// scripts/create-box.js
const { ethers, upgrades } = require('hardhat')

async function main() {
  const owner = '0x7708302f84d225979D55d6857F74837B3d93e30C';
  const ara = '0x040eEE6D8da3092381Bc9DFaB8fD4A0A9D8eEBDa';
  const main = '0x58035DC04D0c05b43396a2d7436F87E5C9F380f6'; // Mad Frogs for the Frog Wars game. Addon allows users to convert there game assets into item

  const Contract = await ethers.getContractFactory('ContributorDeposit')
  const contract = await upgrades.deployProxy(Contract, [owner, main, ara])
  await contract.waitForDeployment()
  console.log('Contributor deposit deployed to:', await contract.getAddress())
}

main()
