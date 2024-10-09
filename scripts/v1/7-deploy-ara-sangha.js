// scripts/create-box.js
const { ethers } = require('hardhat')

// temporary on the testnets
const contractName = `MaintainerTokenV1`;

async function main() {
  const accounts = await ethers.getSigners()
  const projectId = 1;
  const leader = accounts[0].address;
  const ownership = leader;

  const ownershipArgs = [projectId, leader, ownership, "Ara Temporary", "ARAt"]
  let Contract = await ethers.getContractFactory(contractName)
  let contract = await Contract.deploy(...ownershipArgs)
  await contract.waitForDeployment()
  console.log(`Ara token deployed address ${await contract.getAddress()}`)

  const maintainerArgs = [projectId, leader, ownership, "Ara Temporary Maintainer", "ARAtm"]
  contract = await Contract.deploy(...maintainerArgs)
  await contract.waitForDeployment()
  console.log(`Ara Maintainer deployed address ${await contract.getAddress()}`)

  const checkArgs = [projectId, leader, ownership, "Ara Temporary Check", "ARAtc"]
  contract = await Contract.deploy(...checkArgs)
  await contract.waitForDeployment()
  console.log(`Ara Check deployed address ${await contract.getAddress()}`)
}

main()
