// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  let accounts = await ethers.getSigners();
  const ARAAddr = "0x080f9A2FA8996d54ff62Ce841C9390Dc26f6dEf5";
  const MAINToken = await ethers.getContractFactory("MAINToken");
  const contract = await upgrades.deployProxy(MAINToken, [accounts[0].address, ARAAddr]);
  await contract.waitForDeployment();
  console.log("MAINToken deployed to:", await contract.getAddress());
}

main();