// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const ARAToken = await ethers.getContractFactory("ARAToken");
  const ara = await upgrades.deployProxy(ARAToken, []);
  await ara.waitForDeployment();
  console.log("araToken deployed to:", await ara.getAddress());
}

main();