const { deployments, ethers, getNamedAccounts, log } = require("hardhat");
const { assert, expect } = require("chai");

describe("Testing only admin functions", async function () {
  let BBVA;
  let erc20;
  let erc721;
  let deployer;

  beforeEach(async function () {
    deployer = (await getNamedAccounts()).deployer;
    user = (await getNamedAccounts()).user;
    await deployments.fixture(["all"]);
    BBVA = await ethers.getContract("BBVA", deployer);
    erc721 = await ethers.getContract("BBVANFTRewards", deployer);
    erc20 = await ethers.getContract("BBVAToken", deployer);
  });
  describe("Only admins should add rewards", async function () {
    it("Fails if you are not admin", async function () {
      await expect(BBVA.addReward()).to.be.revertedWith(
        "Acount is not admin or owner"
      );
    });
  });
  describe("Only admins should delete rewards", async function () {
    it("Fails if you are not an admin", async function () {
      await expect(BBVA.deleteReward(1)).to.be.revertedWith(
        "Acount is not admin or owner"
      );
    });
  });
  describe("Only main smart contract can mint ERC20 ", async function () {
    it("Fails if you are not a controller/registered to mint", async function () {
      await expect(erc20.mint(user, "1000000000000000000")).to.be.revertedWith(
        "Only controllers can mint"
      );
    });
  });
});
