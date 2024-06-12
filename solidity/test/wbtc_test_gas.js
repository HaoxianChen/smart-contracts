const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var WBTC = artifacts.require("WBTC");
var ERC20 = artifacts.require("ERC20Basic")


contract("WBTC", async accounts => {
    it("test WBTC.burn gas consumption", async () => {
      const instance = await WBTC.new();
      await instance.mint(accounts[0],30, {from: accounts[0]});
      const result = await instance.burn(30, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("WBTC.burn Gas Used: ", gasUsed);
    });      

    it("test WBTC.transfer gas consumption", async () => {
      const instance = await WBTC.new();
      await instance.mint(accounts[0],30, {from: accounts[0]});
      const result = await instance.transfer(accounts[1], 30, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("WBTC.transfer Gas Used: ", gasUsed);
    });  

    it("test WBTC.transferFrom gas consumption", async () => {
      const instance = await WBTC.new();
      await instance.mint(accounts[0],30, {from: accounts[0]});
      await instance.approve(accounts[1], 30, {from: accounts[0]})
      const result = await instance.transferFrom(accounts[0],accounts[2], 30, {from: accounts[1]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("WBTC.transferFrom Gas Used: ", gasUsed);
    });     

    it("test WBTC.transferOwnership gas consumption", async () => {
      const instance = await WBTC.new();
      const result = await instance.transferOwnership(accounts[1], {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("WBTC.transferOwnership Gas Used: ", gasUsed);
    });      

    it("test WBTC.approve gas consumption", async () => {
      const instance = await WBTC.new();
      await instance.mint(accounts[0],30, {from: accounts[0]});
      const result = await instance.approve(accounts[1], 30, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("WBTC.approve Gas Used: ", gasUsed);
    });  

    it("test WBTC.increaseApproval gas consumption", async () => {
      const instance = await WBTC.new();
      await instance.mint(accounts[0],30, {from: accounts[0]});
      await instance.approve(accounts[1], 10, {from: accounts[0]});
      const result = await instance.increaseApproval(accounts[1], 20, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("WBTC.increaseApproval Gas Used: ", gasUsed);
    });  

    it("test WBTC.decreaseApproval gas consumption", async () => {
      const instance = await WBTC.new();
      await instance.mint(accounts[0],30, {from: accounts[0]});
      await instance.approve(accounts[1], 30, {from: accounts[0]});
      const result = await instance.decreaseApproval(accounts[1], 20, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("WBTC.decreaseApproval Gas Used: ", gasUsed);
    });  

    // parent contracts test (CanReclaimToken)
    it("test WBTC.reclaimToken gas consumption", async () => {
      const instance = await WBTC.new();
      const new_instance = await WBTC.new();
      await instance.mint(accounts[0],30);
      await new_instance.mint(accounts[0],30);
      const result = await instance.reclaimToken(new_instance.address);
      const gasUsed = await result.receipt.gasUsed;
      console.log("WBTC.reclaimToken Gas Used: ", gasUsed);
    });  

    // parent contracts test (onlyPendingOwner)
    it("test WBTC.claimOwnership gas consumption", async () => {
      const instance = await WBTC.new();
      await instance.transferOwnership(accounts[1], {from:accounts[0]});
      const result = await instance.claimOwnership({from: accounts[1]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("WBTC.claimOwnership Gas Used: ", gasUsed);
    }); 

    // parent contracts test (Pausable)
    it("test WBTC.pause gas consumption", async () => {
      const instance = await WBTC.new();
      const result = await instance.pause({from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("WBTC.pause Gas Used: ", gasUsed);
    });    

    it("test WBTC.unpause gas consumption", async () => {
      const instance = await WBTC.new();
      await instance.pause({from: accounts[0]});
      const result = await instance.unpause({from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("WBTC.unpause Gas Used: ", gasUsed);
    }); 

    // parent contracts test (MintableToken)
    it("test WBTC.mint gas consumption", async () => {
      const instance = await WBTC.new();
      const result = await instance.mint(accounts[0], 30, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("WBTC.mint Gas Used: ", gasUsed);
    });     





    


   
   

});

