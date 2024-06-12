const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var TokenMintERC20Token = artifacts.require("TokenMintERC20Token");


contract("TokenMintERC20Token", async accounts => {
    it("test TokenMintERC20Token.burn gas consumption", async () => {
      const instance = await TokenMintERC20Token.new("tokenName", "tokenSymbol", 18, 100, accounts[0], accounts[1]);
      const result = await instance.burn(10, {from: accounts[1]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TokenMintERC20Token.burn Gas Used: ", gasUsed);
    });

    // test parent contracts (ERC20)
    it("test TokenMintERC20Token.transfer gas consumption", async () => {
      const instance = await TokenMintERC20Token.new("tokenName", "tokenSymbol", 18, 100, accounts[0], accounts[1]);
      const result = await instance.transfer(accounts[0], 10, {from: accounts[1]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TokenMintERC20Token.transfer Gas Used: ", gasUsed);
    });     


    it("test TokenMintERC20Token.approve gas consumption", async () => {
      const instance = await TokenMintERC20Token.new("tokenName", "tokenSymbol", 18, 100, accounts[0], accounts[1]);
      const result = await instance.approve(accounts[0], 100, {from: accounts[1]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TokenMintERC20Token.approve Gas Used: ", gasUsed);
    });      


    it("test TokenMintERC20Token.transferFrom gas consumption", async () => {
      const instance = await TokenMintERC20Token.new("tokenName", "tokenSymbol", 18, 100, accounts[0], accounts[1]);
      await instance.approve(accounts[0], 100, {from: accounts[1]});
      const result = await instance.transferFrom(accounts[1], accounts[2], 50, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TokenMintERC20Token.transferFrom Gas Used: ", gasUsed);
    });      


    it("test TokenMintERC20Token.transferFrom gas consumption", async () => {
      const instance = await TokenMintERC20Token.new("tokenName", "tokenSymbol", 18, 100, accounts[0], accounts[1]);
      await instance.approve(accounts[0], 100, {from: accounts[1]});
      const result = await instance.transferFrom(accounts[1], accounts[2], 50, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TokenMintERC20Token.transferFrom Gas Used: ", gasUsed);
    });  

    it("test TokenMintERC20Token.increaseAllowance gas consumption", async () => {
      const instance = await TokenMintERC20Token.new("tokenName", "tokenSymbol", 18, 100, accounts[0], accounts[1]);
      await instance.approve(accounts[0], 50, {from: accounts[1]});
      const result = await instance.increaseAllowance(accounts[0],50, {from: accounts[1]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TokenMintERC20Token.increaseAllowance Gas Used: ", gasUsed);
    });      


    it("test TokenMintERC20Token.decreaseAllowance gas consumption", async () => {
      const instance = await TokenMintERC20Token.new("tokenName", "tokenSymbol", 18, 100, accounts[0], accounts[1]);
      await instance.approve(accounts[0], 100, {from: accounts[1]});
      const result = await instance.decreaseAllowance(accounts[0], 50, {from: accounts[1]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TokenMintERC20Token.decreaseAllowance Gas Used: ", gasUsed);
    });  

    








});

