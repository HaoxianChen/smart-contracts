const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var NFT = artifacts.require("NFT");


contract("NFT", async accounts => {
    it("test NFT.transferFrom gas consumption", async () => {
      const instance = await NFT.deployed();
      await instance.mint(accounts[0], 123)
      const result = await instance.transferFrom(accounts[0], accounts[1], 123,
        { gas: 5000000, gasPrice: 500000000 });
      const gasUsed = await result.receipt.gasUsed;
      console.log("NFT.transferFrom Gas Used: ", gasUsed);


    });

    it("test NFT.approve gas consumption", async () => {
        const instance = await NFT.deployed();
        await instance.mint(accounts[0], 124)
        await instance.setApprovalForAll(accounts[1], true);
        const result = await instance.approve(accounts[1], 124);
        const gasUsed = await result.receipt.gasUsed;
        console.log("NFT.approve Gas Used: ", gasUsed);
  
  
      });

    it("test NFT.setApprovalForAll gas consumption", async () => {
      const instance = await NFT.deployed();
      const result = await instance.setApprovalForAll(accounts[1], true);
      const gasUsed = await result.receipt.gasUsed;
      console.log("NFT.setApprovalForAll Gas Used: ", gasUsed);


    });    

    it("test NFT.mint gas consumption", async () => {
      const instance = await NFT.deployed();
      const result = await instance.mint(accounts[1], 1);
      const gasUsed = await result.receipt.gasUsed;
      console.log("NFT.mint Gas Used: ", gasUsed);
    });    

    it("test NFT.burn gas consumption", async () => {
      const instance = await NFT.deployed();
      await instance.mint(accounts[1], 2);
      const result = await instance.burn(2);
      const gasUsed = await result.receipt.gasUsed;
      console.log("NFT.burn Gas Used: ", gasUsed);
    });

});

