import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

require('solidity-coverage')

const PRIVATE_KEY = "37b101a3c67aaf0dbcf6f73d2722466222cc909dad639c43edbc78d49223376a";

 
  module.exports = {
    solidity: {
      version: "0.8.18",
      settings: {
        optimizer: { 
          enabled: true,
          runs: 200,
        },
      },

    },
    
    networks: {
      sepolia: {
        url: "https://sepolia.infura.io/v3/81f9f06a4ae846e9982697a73a051425",
        chainId: 11155111,
        accounts: [PRIVATE_KEY],
      }
    },

    etherscan: {
      apiKey: {
        sepolia: "GGAZD4UWPR13RARGH6XPEVXMHIPDSA5I8Y"
      }
    }
  };