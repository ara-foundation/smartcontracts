import { ethers, upgrades } from 'hardhat';

const contractName = `AllStars`;
const contractAddr = "0xD6dffF953AF507C7934F431d7b020d7C253377c3";

async function main() {
  const Contract = await ethers.getContractFactory(contractName)
  const contract = await upgrades.upgradeProxy(contractAddr, Contract, [])
  await contract.waitForDeployment()
  console.log(`${contractName} upgraded: ${await contract.getAddress()}`)
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
