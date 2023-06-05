const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var TetherToken = artifacts.require("TetherToken");


contract("TetherToken", async accounts => {
    it("test TetherToken.transfer gas consumption", async () => {
      const instance = await TetherToken.new(100, "tokenName", "tokenSymbol", 18);
      const result = await instance.transfer(accounts[1], 10, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TetherToken.transfer Gas Used: ", gasUsed);
    });    

    it("test TetherToken.transferFrom gas consumption", async () => {
      const instance = await TetherToken.new(100, "tokenName", "tokenSymbol", 18);
      await instance.approve(accounts[1], 100, {from: accounts[0]});
      const result = await instance.transferFrom(accounts[0], accounts[2], 50, {from: accounts[1]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TetherToken.transferFrom Gas Used: ", gasUsed);
    });    

    it("test TetherToken.issue gas consumption", async () => {
      const instance = await TetherToken.new(100, "tokenName", "tokenSymbol", 18);
      const result = await instance.issue(100, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TetherToken.issue Gas Used: ", gasUsed);
    });    

    it("test TetherToken.redeem gas consumption", async () => {
      const instance = await TetherToken.new(100, "tokenName", "tokenSymbol", 18);
      const result = await instance.redeem(50, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TetherToken.redeem Gas Used: ", gasUsed);
    });    

    it("test TetherToken.setParams gas consumption", async () => {
      const instance = await TetherToken.new(100, "tokenName", "tokenSymbol", 18);
      const result = await instance.setParams(10, 25);
      const gasUsed = await result.receipt.gasUsed;
      console.log("TetherToken.setParams Gas Used: ", gasUsed);
    });

    // parent contracts tests (Blacklist)
    it("test TetherToken.addBlackList gas consumption", async () => {
      const instance = await TetherToken.new(100, "tokenName", "tokenSymbol", 18);
      const result = await instance.addBlackList(accounts[2], {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TetherToken.addBlackList Gas Used: ", gasUsed);
    });       

    it("test TetherToken.removeBlackList gas consumption", async () => {
      const instance = await TetherToken.new(100, "tokenName", "tokenSymbol", 18);
      await instance.addBlackList(accounts[2], {from: accounts[0]});
      const result = await instance.removeBlackList(accounts[2], {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TetherToken.removeBlackList Gas Used: ", gasUsed);
    });       

    it("test TetherToken.destroyBlackFunds gas consumption", async () => {
      const instance = await TetherToken.new(100, "tokenName", "tokenSymbol", 18);
      await instance.transfer(accounts[2], 20, {from: accounts[0]});
      await instance.addBlackList(accounts[2], {from: accounts[0]});
      const result = await instance.destroyBlackFunds(accounts[2], {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TetherToken.destroyBlackFunds Gas Used: ", gasUsed);
    });    

    // parent contracts tests (Pausable)
    it("test TetherToken.pause gas consumption", async () => {
      const instance = await TetherToken.new(100, "tokenName", "tokenSymbol", 18);
      const result = await instance.pause({from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TetherToken.pause Gas Used: ", gasUsed);
    })    

    it("test TetherToken.unpause gas consumption", async () => {
      const instance = await TetherToken.new(100, "tokenName", "tokenSymbol", 18);
      await instance.pause({from: accounts[0]});
      const result = await instance.unpause({from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TetherToken.unpause Gas Used: ", gasUsed);
    });

    // parent contracts tests (StandardToken)
    it("test TetherToken.approve gas consumption", async () => {
      const instance = await TetherToken.new(100, "tokenName", "tokenSymbol", 18);
      const result = await instance.approve(accounts[1], 100, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TetherToken.approve Gas Used: ", gasUsed);
    });

    // parent contracts tests (Ownable)
    it("test TetherToken.transferOwnership gas consumption", async () => {
      const instance = await TetherToken.new(100, "tokenName", "tokenSymbol", 18);
      const result = await instance.transferOwnership(accounts[1],{from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TetherToken.transferOwnership Gas Used: ", gasUsed);
    }); 





    
    








});

