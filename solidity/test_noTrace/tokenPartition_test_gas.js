const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var TokenPartition = artifacts.require("TokenPartition");


contract("TokenPartition", async accounts => {
    it("test TokenPartition.issueByPartition gas consumption", async () => {
      const instance = await TokenPartition.new();
      const result = await instance.issueByPartition(accounts[1], 10, 200, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TokenPartition.issueByPartition Gas Used: ", gasUsed);
    });    

    it("test TokenPartition.redeemByPartition gas consumption", async () => {
      const instance = await TokenPartition.new();
      await instance.issueByPartition(accounts[1], 10, 200, {from: accounts[0]});
      const result = await instance.redeemByPartition(accounts[1], 10, 200, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TokenPartition.redeemByPartition Gas Used: ", gasUsed);
    });         

    it("test TokenPartition.transferByPartition gas consumption", async () => {
      const instance = await TokenPartition.new();
      await instance.issueByPartition(accounts[1], 10, 200, {from: accounts[0]});
      const result = await instance.transferByPartition(accounts[1], accounts[2], 10, 100, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("TokenPartition.transferByPartition Gas Used: ", gasUsed);
    });     

   

});

