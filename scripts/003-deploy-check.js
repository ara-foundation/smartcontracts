// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const ARAAddr = "0x080f9A2FA8996d54ff62Ce841C9390Dc26f6dEf5";
  const MAINAddr = "0x6B56DafFfA364E1163d5D6cD2487dBeFaE64D115";
  const MinterAddr = "0x6e7F3BD30c9aacFf37e07E790f156D95b52b0834";
  const Contract = await ethers.getContractFactory("CHECKToken");
  const contract = await upgrades.deployProxy(Contract, [ARAAddr, MAINAddr, MinterAddr]);
  await contract.waitForDeployment();
  console.log("Contract deployed to:", await contract.getAddress());
}

main();