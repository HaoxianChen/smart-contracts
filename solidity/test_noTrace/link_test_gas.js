const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var Link = artifacts.require("LinkToken");


contract("Link", async accounts => {
  it("test Link.transfer gas consumption", async() => {
    const instance = await Link.new();
    const result = await instance.transfer(accounts[1], 100);
    const gasUsed = await result.receipt.gasUsed;
    console.log("Link.transfer Gas Used: ", gasUsed);
  });  

  it("test Link.approve gas consumption", async() => {
    const instance = await Link.new();
    const result = await instance.approve(accounts[1], 100, {from: accounts[0]});
    const gasUsed = await result.receipt.gasUsed;
    console.log("Link.approve Gas Used: ", gasUsed);
  });

  it("test Link.transferFrom gas consumption", async() => {
    const instance = await Link.new();
    // transfer 30 from accounts[0] to accounts[1]
    await instance.transfer(accounts[1], 30);
    // allow accounts[0] to spend 30 on behalf of accounts[1]
    await instance.approve(accounts[0], 30, {from: accounts[1]});
    // accounts[0] spend 30 and transfer it to accounts[0] on behalf of accounts[1]
    const result = await instance.transferFrom(accounts[1], accounts[2], 30, {from: accounts[0]});
    const gasUsed = await result.receipt.gasUsed;
    console.log("Link.transferFrom Gas Used: ", gasUsed);
  });

  // tests for parent contracts (StandardToken)  
  it("test Link.increaseApproval gas consumption", async() => {
    const instance = await Link.new();
    await instance.approve(accounts[1], 50, {from: accounts[0]});
    const result = await instance.increaseApproval(accounts[1], 50, {from: accounts[0]});
    const gasUsed = await result.receipt.gasUsed;
    console.log("Link.increaseApproval Gas Used: ", gasUsed);
  });  

  it("test Link.decreaseApproval gas consumption", async() => {
    const instance = await Link.new();
    await instance.approve(accounts[1], 100, {from: accounts[0]});
    const result = await instance.decreaseApproval(accounts[1], 50, {from: accounts[0]});
    const gasUsed = await result.receipt.gasUsed;
    console.log("Link.decreaseApproval Gas Used: ", gasUsed);
  });





})



