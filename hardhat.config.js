require('@nomicfoundation/hardhat-toolbox')
require('@nomicfoundation/hardhat-verify')
require('@openzeppelin/hardhat-upgrades')
require('dotenv').config()

const BASE_SEPOLIA_PRIVATE_KEY = process.env.BASE_SEPOLIA_PRIVATE_KEY
const BASE_SEPOLIA_SCAN_KEY = process.env.BASE_SEPOLIA_SCAN_KEY

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: '0.8.20',
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  networks: {
    BASE_SEPOLIA: {
      chainId: 84532,
      url: 'https://sepolia.base.org',
      accounts: [BASE_SEPOLIA_PRIVATE_KEY],
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at
    apiKey: {
      BASE_SEPOLIA: BASE_SEPOLIA_SCAN_KEY,
    },
    customChains: [
      {
        network: 'BASE_SEPOLIA',
        chainId: 84532,
        urls: {
          apiURL: 'https://api-sepolia.basescan.org/api',
          browserURL: 'https://sepolia.basescan.org/',
        },
      },
    ],
  },
  sourcify: {
    enabled: false,
  },
}
