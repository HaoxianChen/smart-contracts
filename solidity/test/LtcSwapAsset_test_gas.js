const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var LtcSwapAsset = artifacts.require("LtcSwapAsset");


contract("LtcSwapAsset", async accounts => {
    it("test LtcSwapAsset.changeDCRMOwner gas consumption", async () => {
      const instance = await LtcSwapAsset.new({from: accounts[0]});
      const result = await instance.changeDCRMOwner(accounts[1], {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("LtcSwapAsset.changeDCRMOwner Gas Used: ", gasUsed);
    });

    // added mint and burn tests
    it("test LtcSwapAsset.mint gas consumption", async () => {
      const instance = await LtcSwapAsset.new({from: accounts[0]});
      const result = await instance.mint(accounts[0], 30);
      const gasUsed = await result.receipt.gasUsed;
      console.log("LtcSwapAsset.mint Gas Used: ", gasUsed);
    });      


    it("test LtcSwapAsset.burn gas consumption", async () => {
      const instance = await LtcSwapAsset.new({from: accounts[0]});
      await instance.mint(accounts[0], 30);
      const result = await instance.burn(accounts[0], 30);
      const gasUsed = await result.receipt.gasUsed;
      console.log("LtcSwapAsset.burn Gas Used: ", gasUsed);
    });  

    // parent contracts tests ()
    it("test LtcSwapAsset.transfer gas consumption", async () => {
      const instance = await LtcSwapAsset.new({from: accounts[0]});
      await instance.mint(accounts[0], 30);
      const result = await instance.transfer(accounts[1], 30, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("LtcSwapAsset.transfer Gas Used: ", gasUsed);
    });    

    it("test LtcSwapAsset.approve gas consumption", async () => {
      const instance = await LtcSwapAsset.new({from: accounts[0]});
      await instance.mint(accounts[0], 30);
      const result = await instance.approve(accounts[1], 30, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("LtcSwapAsset.approve Gas Used: ", gasUsed);
    });    


    it("test LtcSwapAsset.transferFrom gas consumption", async () => {
      const instance = await LtcSwapAsset.new({from: accounts[0]});
      await instance.mint(accounts[0], 30);
      await instance.approve(accounts[1], 30, {from: accounts[0]});
      const result = await instance.transferFrom(accounts[0], accounts[2], 30, {from: accounts[1]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("LtcSwapAsset.transferFrom Gas Used: ", gasUsed);
    });    


    it("test LtcSwapAsset.increaseAllowance gas consumption", async () => {
      const instance = await LtcSwapAsset.new({from: accounts[0]});
      await instance.mint(accounts[0], 30);
      await instance.approve(accounts[1], 10, {from: accounts[0]});
      const result = await instance.increaseAllowance(accounts[1], 20, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("LtcSwapAsset.increaseAllowance Gas Used: ", gasUsed);
    });    


    it("test LtcSwapAsset.decreaseAllowance gas consumption", async () => {
      const instance = await LtcSwapAsset.new({from: accounts[0]});
      await instance.mint(accounts[0], 30);
      await instance.approve(accounts[1], 30, {from: accounts[0]});
      const result = await instance.decreaseAllowance(accounts[1], 10, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("LtcSwapAsset.decreaseAllowance Gas Used: ", gasUsed);
    });



});

