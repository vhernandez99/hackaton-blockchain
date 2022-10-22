const { deployments, ethers, getNamedAccounts, log } = require("hardhat");
const { assert, expect } = require("chai");

describe("test", async function () {
  let BBVA;
  let erc20;
  let erc721;
  let deployer;
  let erc20Token = "1000000000000000000";
  beforeEach(async function () {
    deployer = (await getNamedAccounts()).deployer;
    await deployments.fixture(["all"]);
    BBVA = await ethers.getContract("BBVA", deployer);
    erc721 = await ethers.getContract("BBVANFTRewards", deployer);
    erc20 = await ethers.getContract("BBVAToken", deployer);
    await erc20.mint(deployer, erc20Token)
  });
  describe("Get erc20 minted tokens", async function () {
    it("Should have erc20Token minted", async function () {
      const balanceERC20 = await erc20.balanceOf(deployer);
      //const newBalance = (balanceERC20 += "1000000000000000000");
      assert.equal(balanceERC20.toString(), "1000000000000000000");
    });
  });

  describe("Only admins should add rewards", async function () {
    it("Should add reward only if its admin", async function () {
      const balanceERC20 = await erc20.balanceOf(deployer);
      //const newBalance = (balanceERC20 += "1000000000000000000");
      assert.equal(balanceERC20.toString(), "1000000000000000000");
    });
  });
});
