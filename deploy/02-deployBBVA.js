const { getNamedAccounts, deployments, network } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log("----------------------------------------------------");
  log("Deploying BBVA and waiting for confirmations...");
  const erc720 = await deployments.get("BBVAToken");
  const erc721 = await deployments.get("BBVANFTRewards");
  await deploy("BBVA", {
    from: deployer,
    args: [erc721.address, erc720.address],
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });


};

module.exports.tags = ["all", "BBVA"];
