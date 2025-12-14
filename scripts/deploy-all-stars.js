import hre from 'hardhat';

const contractName = `AllStars`;

async function main() {
  // Use ethers v6 directly with Hardhat artifacts
  const { ethers } = await import('ethers');
  const rpcUrl = process.env.BASE_SEPOLIA_RPC_URL || hre.config.networks.baseSepolia.url || 'https://base-sepolia.publicnode.com';
  const provider = new ethers.JsonRpcProvider(String(rpcUrl));
  const wallet = new ethers.Wallet(process.env.BASE_SEPOLIA_PRIVATE_KEY || '', provider);
  const deployer = wallet;
  
  console.log(`Deploying ${contractName} with account:`, deployer.address);
  console.log(`Account balance:`, (await provider.getBalance(deployer.address)).toString());
  
  // Get contract factory using Hardhat artifacts
  const artifact = await hre.artifacts.readArtifact(contractName);
  const Contract = new ethers.ContractFactory(artifact.abi, artifact.bytecode, deployer);
  console.log(`Deploying implementation...`);
  const implementation = await Contract.deploy();
  await implementation.waitForDeployment();
  const implementationAddress = await implementation.getAddress();
  console.log(`${contractName} implementation deployed:`, implementationAddress);
  
  // Deploy TransparentUpgradeableProxy using ProxyWrapper
  const proxyArtifact = await hre.artifacts.readArtifact('ProxyWrapper');
  const ProxyFactory = new ethers.ContractFactory(proxyArtifact.abi, proxyArtifact.bytecode, deployer);
  
  // Initialize data - initialize() takes admin address
  const initData = Contract.interface.encodeFunctionData('initialize', [deployer.address]);
  
  console.log(`Deploying proxy...`);
  // Deploy proxy pointing to implementation
  // admin = deployer, implementation = implementationAddress, _data = initData
  const proxy = await ProxyFactory.deploy(implementationAddress, deployer.address, initData);
  await proxy.waitForDeployment();
  const proxyAddress = await proxy.getAddress();
  console.log(`${contractName} proxy deployed:`, proxyAddress);
  
  console.log(`\n✅ ${contractName} deployed at:`, proxyAddress);
  console.log(`Implementation at:`, implementationAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
