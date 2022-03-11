const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var Token = artifacts.require("Token");


contract("Token", async accounts => {
    it("test Token.transfer gas consumption", async () => {
      const instance = await Token.deployed();
      await instance.mint(accounts[0], 100);
      const result = await instance.transfer(accounts[1], 10);
      const gasUsed = await result.receipt.gasUsed;
      console.log("Token.transfer Gas Used: ", gasUsed);


    });

    it("test Token.approve gas consumption", async () => {
      const instance = await Token.deployed();
      //await instance._mint(accounts[0], 100);
      const result = await instance.approve(accounts[1], 10);
      const gasUsed = await result.receipt.gasUsed;
      console.log("Token.approve Gas Used: ", gasUsed);
  
  
      });

    it("test Token.transferFrom gas consumption", async () => {
      const instance = await Token.deployed();
      await instance.mint(accounts[0], 100);
      await instance.approve(accounts[0], 50);
      await instance.mint(accounts[1], 100);
      const result = await instance.transferFrom(accounts[0], accounts[1], 10);
      const gasUsed = await result.receipt.gasUsed;
      console.log("Token.transferFrom Gas Used: ", gasUsed);


    });

});

