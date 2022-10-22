const { getNamedAccounts, deployments, network } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log("----------------------------------------------------");
  log("Deploying erc721 and waiting for confirmations...");
  const erc721 = await deploy("BBVANFTRewards", {
    from: deployer,
    args: [],
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });
  log(`erc721 deployed at ${erc721.address}`);
};

module.exports.tags = ["all", "erc721"];
