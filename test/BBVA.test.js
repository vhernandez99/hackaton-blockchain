const { deployments, ethers, getNamedAccounts, log } = require("hardhat");
const { assert, expect } = require("chai");

describe("Testing BBVA main smart contract", async function () {
  let BBVA;
  let erc20;
  let erc721;
  let deployer;
  let user;
  let amountERC20token = "1000000000000000000";

  beforeEach(async function () {
    deployer = (await getNamedAccounts()).deployer;
    user = (await getNamedAccounts()).user;
    await deployments.fixture(["all"]);
    BBVA = await ethers.getContract("BBVA", deployer);
    erc721 = await ethers.getContract("BBVANFTRewards", deployer);
    erc20 = await ethers.getContract("BBVAToken", deployer);

    await BBVA.addAdmin(deployer);
    await erc20.addController(BBVA.address);
    await BBVA.addPointsToAcount(deployer, amountERC20token);
    await BBVA.addAdmin(deployer);
    await BBVA.addReward();
  });
  describe("Get erc20 minted tokens", async function () {
    it("Should have amountERC20token minted", async function () {
      const balanceERC20 = await erc20.balanceOf(deployer);
      assert.equal(balanceERC20.toString(), "1000000000000000000");
    });
  });
  describe("Buy reward", async function () {
    it("Should add a erc721 reward to my wallet", async function () {
      await erc20.approve(BBVA.address, amountERC20token);
      await BBVA.buyReward(deployer, 1, amountERC20token);
      const balanceOfErc721 = await erc721.balanceOf(deployer);
      assert.equal(balanceOfErc721.toString(), "1");
    });
  });
  describe("Mint erc20", async function () {
    it("Should be able to mint if you are admin and the call is made from the contract", async function () {
      await BBVA.addPointsToAcount(user, amountERC20token);
    });
  });
});
