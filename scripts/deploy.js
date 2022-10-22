const { BigNumber } = require("ethers");
const { getNamedAccounts, ethers } = require("hardhat");
async function main() {
  const { deployer } = await getNamedAccounts();
  const erc721 = await ethers.getContract("BBVANFTRewards", deployer);
  const erc20 = await ethers.getContract("BBVAToken", deployer);
  const BBVA = await ethers.getContract("BBVA", deployer);
  await erc20.mint(deployer, "10000000000000000000")
  const balanceERC20 = await erc20.balanceOf(deployer)
  console.log(balanceERC20.toString())
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
     process.exit(1);
  });
