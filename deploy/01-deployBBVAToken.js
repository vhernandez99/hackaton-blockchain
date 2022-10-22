const { getNamedAccounts, deployments, network } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  log("----------------------------------------------------");
  log("Deploying erc720 and waiting for confirmations...");
  const erc720 = await deploy("BBVAToken", {
    from: deployer,
    args: [],
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });
  log(`erc20 deployed at ${erc720.address}`);
};

module.exports.tags = ["all", "erc20"];
