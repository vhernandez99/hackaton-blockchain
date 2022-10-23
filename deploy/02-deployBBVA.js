const { getNamedAccounts, deployments, network } = require("hardhat");
const {
  networkConfig,
  developmentChains,
} = require("../helper-hardhat-config");
require("dotenv").config();
const { verify } = require("../utils/verify");
module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log("----------------------------------------------------");
  log("Deploying BBVA and waiting for confirmations...");
  const erc20 = await deployments.get("BBVAToken");
  const erc721 = await deployments.get("BBVANFTRewards");
  const arguments = [erc721.address, erc20.address];
  const BBVA = await deploy("BBVA", {
    from: deployer,
    args: arguments,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });

  log("verifying------------------------------------------");
  if (
    !developmentChains.includes(network.name) &&
    process.env.ETHERSCAN_API_KEY
  ) {
    await verify(erc20.address);
    await verify(erc721.address);
    await verify(BBVA, arguments);
  }
};

module.exports.tags = ["all", "BBVA"];
