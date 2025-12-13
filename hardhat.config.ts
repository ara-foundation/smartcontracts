import { defineConfig } from "hardhat/config";
import hardhatVerify from "@nomicfoundation/hardhat-verify";
// TODO: @openzeppelin/hardhat-upgrades not yet compatible with Hardhat v3
// Re-enable when compatible version is available
// import "@openzeppelin/hardhat-upgrades";
import "dotenv/config";

const BASE_SEPOLIA_PRIVATE_KEY = process.env.BASE_SEPOLIA_PRIVATE_KEY || "";
const ETHERSCAN_KEY = process.env.ETHERSCAN_KEY || "";

export default defineConfig({
  plugins: [hardhatVerify],
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  networks: {
    baseSepolia: {
      type: "http",
      chainId: 84532,
      url: process.env.BASE_SEPOLIA_RPC_URL || "https://base-sepolia.publicnode.com",
      accounts: BASE_SEPOLIA_PRIVATE_KEY ? [BASE_SEPOLIA_PRIVATE_KEY] : [],
      timeout: 120000,
    },
  },
  verify: {
    etherscan: {
        apiKey: ETHERSCAN_KEY,
    },
    sourcify: {
      enabled: false,
    },
    blockscout: {
      enabled: false,
    },
  }
});

