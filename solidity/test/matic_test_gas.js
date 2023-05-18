const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var MaticToken = artifacts.require("MaticToken");


contract("MaticToken", async accounts => {
    it("test MaticToken.transfer gas consumption", async () => {
      const instance = await MaticToken.new("tokenName", "tokenSymbol",18, 100);
      const result = await instance.transfer(accounts[0], 30, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("MaticToken.transfer Gas Used: ", gasUsed);
    });         


    it("test MaticToken.transferFrom gas consumption", async () => {
      const instance = await MaticToken.new("tokenName", "tokenSymbol",18, 100);
      await instance.transfer(accounts[0], 30, {from: accounts[0]});
      await instance.approve(accounts[1], 30, {from: accounts[0]})
      const result = await instance.transferFrom(accounts[0],accounts[2], 30, {from: accounts[1]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("MaticToken.transferFrom Gas Used: ", gasUsed);
    });       

    it("test MaticToken.approve gas consumption", async () => {
      const instance = await MaticToken.new("tokenName", "tokenSymbol",18, 100);
      await instance.transfer(accounts[0], 30, {from: accounts[0]});
      const result = await instance.approve(accounts[1],30, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("MaticToken.approve Gas Used: ", gasUsed);
    });     

    it("test MaticToken.increaseAllowance gas consumption", async () => {
      const instance = await MaticToken.new("tokenName", "tokenSymbol",18, 100);
      await instance.transfer(accounts[0], 30, {from: accounts[0]});
      await instance.approve(accounts[1],10, {from: accounts[0]});
      const result = await instance.increaseAllowance(accounts[1],10, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("MaticToken.increaseAllowance Gas Used: ", gasUsed);
    });     


    it("test MaticToken.decreaseAllowance gas consumption", async () => {
      const instance = await MaticToken.new("tokenName", "tokenSymbol",18, 100);
      await instance.transfer(accounts[0], 30, {from: accounts[0]});
      await instance.approve(accounts[1], 30, {from: accounts[0]});
      const result = await instance.decreaseAllowance(accounts[1],10, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("MaticToken.decreaseAllowance Gas Used: ", gasUsed);
    });         


    it("test MaticToken.pause gas consumption", async () => {
      const instance = await MaticToken.new("tokenName", "tokenSymbol",18, 100);
      const result = await instance.pause({from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("MaticToken.pause Gas Used: ", gasUsed);
    });      

    it("test MaticToken.unpause gas consumption", async () => {
      const instance = await MaticToken.new("tokenName", "tokenSymbol",18, 100);
      await instance.pause({from: accounts[0]});
      const result = await instance.unpause({from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("MaticToken.unpause Gas Used: ", gasUsed);
    });      

    it("test MaticToken.addPauser gas consumption", async () => {
      const instance = await MaticToken.new("tokenName", "tokenSymbol",18, 100);
      const result = await instance.addPauser(accounts[1], {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("MaticToken.addPauser Gas Used: ", gasUsed);
    });      


    it("test MaticToken.renouncePauser gas consumption", async () => {
      const instance = await MaticToken.new("tokenName", "tokenSymbol",18, 100);
      await instance.addPauser(accounts[1], {from: accounts[0]});
      const result = await instance.renouncePauser({from: accounts[1]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("MaticToken.renouncePauser Gas Used: ", gasUsed);
    });     

  


});

