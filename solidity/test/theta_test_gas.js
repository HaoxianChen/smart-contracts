const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var ThetaToken = artifacts.require("ThetaToken");


contract("ThetaToken", async accounts => {
    it("test ThetaToken.transfer gas consumption", async () => {
      const instance = await ThetaToken.new(10);
      await instance.mint(accounts[0], 30);
      const result = await instance.transfer(accounts[1], 10, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ThetaToken.transfer Gas Used: ", gasUsed);
    });     

    it("test ThetaToken.transferFrom gas consumption", async () => {
      const instance = await ThetaToken.new(10);
      await instance.mint(accounts[0], 30);
      await instance.approve(accounts[1], 30, {from: accounts[0]});
      const result = await instance.transferFrom(accounts[0],accounts[2], 10, {from: accounts[1]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ThetaToken.transferFrom Gas Used: ", gasUsed);
    });        

    it("test ThetaToken.mint gas consumption", async () => {
      const instance = await ThetaToken.new(10);
      const result = await instance.mint(accounts[0], 30);
      const gasUsed = await result.receipt.gasUsed;
      console.log("ThetaToken.mint Gas Used: ", gasUsed);
    });    

    it("test ThetaToken.allowPrecirculation gas consumption", async () => {
      const instance = await ThetaToken.new(10);
      const result = await instance.allowPrecirculation(accounts[1],{from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ThetaToken.allowPrecirculation Gas Used: ", gasUsed);
    });      

    it("test ThetaToken.disallowPrecirculation gas consumption", async () => {
      const instance = await ThetaToken.new(10);
      await instance.allowPrecirculation(accounts[1],{from: accounts[0]});
      const result = await instance.disallowPrecirculation(accounts[1],{from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ThetaToken.disallowPrecirculation Gas Used: ", gasUsed);
    }); 

    it("test ThetaToken.changeUnlockTime gas consumption", async () => {
      const instance = await ThetaToken.new(10);
      const result = await instance.changeUnlockTime(20,{from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ThetaToken.changeUnlockTime Gas Used: ", gasUsed);
    });  

    // test parent contracts (Controlled)
    it("test ThetaToken.changeController gas consumption", async () => {
      const instance = await ThetaToken.new(10);
      const result = await instance.changeController(accounts[1],{from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ThetaToken.changeController Gas Used: ", gasUsed);
    });  
    // test parent contracts (StandardToken)
    it("test ThetaToken.approve gas consumption", async () => {
      const instance = await ThetaToken.new(10);
      await instance.mint(accounts[0], 30);
      const result = await instance.approve(accounts[1],30, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ThetaToken.approve Gas Used: ", gasUsed);
    });  



});

