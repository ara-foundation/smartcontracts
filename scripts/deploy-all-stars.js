import { ethers, upgrades } from 'hardhat';

const contractName = `AllStars`;

async function main() {
  const Contract = await ethers.getContractFactory(contractName)
  
  // Deploy with unsafeAllow option to bypass some checks
  const contract = await upgrades.deployProxy(
    Contract, 
    [],
    { 
      unsafeAllow: ['constructor'],
      kind: 'transparent'
    }
  )
  await contract.waitForDeployment()
  console.log(`${contractName} deployed: ${await contract.getAddress()}`)
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
