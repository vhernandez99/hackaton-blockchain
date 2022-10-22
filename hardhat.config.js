require("dotenv").config();
require("@nomiclabs/hardhat-waffle");
require("hardhat-deploy");
/** @type import('hardhat/config').HardhatUserConfig */
const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.4",
      },
      {
        version: "0.8.17",
      },
      {
        version: "0.6.6",
      },
    ],
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 31337,
    },
    localhost: {
      blockConfirmations: 6,
    },
    goerli: {
      url: GOERLI_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: 5,
      blockConfirmations: 6,
    },
    ganache: {
      url: "HTTP://127.0.0.1:7545",
      accounts: [
        "7b64d97212ac176abebaee5002b0f924129774af5e2ddf2a27b503eaa9fbca29",
      ],
      chainId: 1337,
    },
  },
  namedAccounts: {
    deployer: {
      default: 0, // here this will by default take the first account as deployer
    },
    user: {
      default: 0,
    },
  },
};
