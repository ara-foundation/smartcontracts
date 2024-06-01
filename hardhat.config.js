require("@nomicfoundation/hardhat-toolbox");
require('@openzeppelin/hardhat-upgrades');
require('dotenv').config();

const INFURA_KEY=process.env.INFURA_KEY;
const PRIVATE_KEY=process.env.PRIVATE_KEY; 	

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    testnet: {
      url: "https://sepolia.infura.io/v3/" + INFURA_KEY,
      accounts: [PRIVATE_KEY]
    }
  },
};
                                          	