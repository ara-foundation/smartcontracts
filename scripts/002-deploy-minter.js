// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const Contract = await ethers.getContractFactory("Minter");
  const contract = await upgrades.deployProxy(Contract, []);
  await contract.waitForDeployment();
  console.log("Minter deployed to:", await contract.getAddress());
}

main();