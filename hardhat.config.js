require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-verify");
require('@openzeppelin/hardhat-upgrades');
require('dotenv').config();

const INFURA_KEY=process.env.INFURA_KEY;
const PRIVATE_KEY=process.env.PRIVATE_KEY;
const ETHERSCAN_KEY=process.env.ETHERSCAN_KEY; 	

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    testnet: {
      url: "https://sepolia.infura.io/v3/" + INFURA_KEY,
      accounts: [PRIVATE_KEY]
    }
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at 	
    apiKey: ETHERSCAN_KEY
  },
  sourcify: {
    enabled: false
  }
};
                                          	