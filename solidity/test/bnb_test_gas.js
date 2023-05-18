const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var BNB = artifacts.require("BNB");


contract("BNB", async accounts => {
  it("test BNB.transfer gas consumption", async() => {
    const instance = await BNB.new(30, "BNB Token", 18, "BNB");
    const result = await instance.transfer(accounts[0], 10);
    const gasUsed = await result.receipt.gasUsed;
    console.log("BNB.transfer Gas Used: ", gasUsed);
  });

  it("test BNB.approve gas consumption", async() => {
    const instance = await BNB.new(30, "BNB Token", 18, "BNB");
    const result = await instance.approve(accounts[0], 20);
    const gasUsed = await result.receipt.gasUsed;
    console.log("BNB.approve Gas Used: ", gasUsed);
  });  

  it("test BNB.transferFrom gas consumption", async() => {
    const instance = await BNB.new(30, "BNB Token", 18, "BNB");
    await instance.transfer(accounts[0], 10);
    await instance.approve(accounts[0], 10);
    const result = await instance.transferFrom(accounts[0], accounts[1], 5);
    const gasUsed = await result.receipt.gasUsed;
    console.log("BNB.transferFrom Gas Used: ", gasUsed);

  });  

  it("test BNB.burn gas consumption", async() => {
    const instance = await BNB.new(30, "BNB Token", 18, "BNB");
    await instance.transfer(accounts[0], 10);
    // call burn from accounts[0]
    const result = await instance.burn(5, {from: accounts[0]})
    const gasUsed = await result.receipt.gasUsed;
    console.log("BNB.burn Gas Used: ", gasUsed);
  });  

  it("test BNB.freeze gas consumption", async() => {
    const instance = await BNB.new(30, "BNB Token", 18, "BNB");
    await instance.transfer(accounts[0], 10);
    // call freeze from accounts[0]
    const result = await instance.freeze(8, {from: accounts[0]})
    const gasUsed = await result.receipt.gasUsed;
    console.log("BNB.freeze Gas Used: ", gasUsed);
  });  

  it("test BNB.unfreeze gas consumption", async() => {
    const instance = await BNB.new(30, "BNB Token", 18, "BNB");
    await instance.transfer(accounts[0], 10);
    // call freeze from accounts[0]
    await instance.freeze(8, {from: accounts[0]})
    // call unfreeze from account[0]
    const result = await instance.unfreeze(8, {from: accounts[0]})
    const gasUsed = await result.receipt.gasUsed;
    console.log("BNB.unfreeze Gas Used: ", gasUsed);
  }); 

  it("test BNB.withdrawEther gas consumption", async() => {
    const instance = await BNB.new(30, "BNB Token", 18, "BNB"); 
    const result = await instance.withdrawEther(1, {value: web3.utils.toWei('1', "ether")});
    const gasUsed = await result.receipt.gasUsed;
    console.log("BNB.withdrawEther Gas Used: ", gasUsed);
  });

})

