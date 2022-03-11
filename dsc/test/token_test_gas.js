const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var Token = artifacts.require("Erc20");


contract("Erc20", async accounts => {
    it("test Erc20.transfer gas consumption", async () => {
      const instance = await Token.deployed();
      await instance.mint(accounts[0], 100);
      const result = await instance.transfer(accounts[1], 10);
      const gasUsed = await result.receipt.gasUsed;
      console.log("Erc20.transfer Gas Used: ", gasUsed);


    });

    it("test Erc20.approve gas consumption", async () => {
      const instance = await Token.deployed();
      //await instance._mint(accounts[0], 100);
      const result = await instance.approve(accounts[1], 10);
      const gasUsed = await result.receipt.gasUsed;
      console.log("Erc20.approve Gas Used: ", gasUsed);
  
  
      });

    it("test Erc20.transferFrom gas consumption", async () => {
      const instance = await Token.deployed();
      await instance.mint(accounts[0], 100);
      await instance.approve(accounts[0], 50);
      await instance.mint(accounts[1], 100);
      const result = await instance.transferFrom(accounts[0], accounts[1], 10);
      const gasUsed = await result.receipt.gasUsed;
      console.log("Erc20.transferFrom Gas Used: ", gasUsed);


      //const x = await instance.getAllowance(accounts[0], accounts[1]);
      //const y = await instance.getBalanceOf(accounts[0]);
      //const z = await instance.getBalanceOf(accounts[1]);
      //console.log(x);
      //console.log(y);
      //console.log(z);


    });

});

