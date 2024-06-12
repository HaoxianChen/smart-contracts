const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var Controllable = artifacts.require("Controllable");


contract("Controllable", async accounts => {
  it("test Controllable.controllerTransfer gas consumption", async() => {
    const instance = await Controllable.new({from: accounts[0]});
    await instance.mint(accounts[0], 30);
    const result = await instance.controllerTransfer(accounts[0], accounts[1], 10);
    const gasUsed = await result.receipt.gasUsed;
    console.log("Controllable.controllerTransfer Gas Used: ", gasUsed);
  });  

  it("test Controllable.controllerRedeem gas consumption", async() => {
    const instance = await Controllable.new({from: accounts[0]});
    await instance.mint(accounts[0], 30);
    const result = await instance.controllerRedeem(accounts[0], 20);
    const gasUsed = await result.receipt.gasUsed;
    console.log("Controllable.controllerTransfer Gas Used: ", gasUsed);
  });
  
  it("test Controllable.mint gas consumption", async() => {
    const instance = await Controllable.new();
    const result = await instance.mint(accounts[0], 30);
    const gasUsed = await result.receipt.gasUsed;
    console.log("Controllable.mint Gas Used: ", gasUsed);
  });  

  it("test Controllable.burn gas consumption", async() => {
    const instance = await Controllable.new();
    await instance.mint(accounts[0],30);
    const result = await instance.burn(accounts[0], 20);
    const gasUsed = await result.receipt.gasUsed;
    console.log("Controllable.burn Gas Used: ", gasUsed);
  });  

  // Parent contract (ERC20) function tests
  it("test Controllable.transfer gas consumption", async() => {
    const instance = await Controllable.new();
    await instance.mint(accounts[0],30);
    const result = await instance.transfer(accounts[1], 20, {from: accounts[0]});
    const gasUsed = await result.receipt.gasUsed;
    console.log("Controllable.transfer Gas Used: ", gasUsed);
  });     

  it("test Controllable.approve gas consumption", async() => {
    const instance = await Controllable.new();
    await instance.mint(accounts[0],30);
    const result = await instance.approve(accounts[1], 30, {from: accounts[0]});
    const gasUsed = await result.receipt.gasUsed;
    console.log("Controllable.approve Gas Used: ", gasUsed);
  });     

  it("test Controllable.transferFrom gas consumption", async() => {
    const instance = await Controllable.new();
    await instance.mint(accounts[0],30);
    await instance.approve(accounts[1], 30, {from: accounts[0]});
    const result = await instance.transferFrom(accounts[0], accounts[2], 30, {from: accounts[1]});
    const gasUsed = await result.receipt.gasUsed;
    console.log("Controllable.transferFrom Gas Used: ", gasUsed);
  });  


  it("test Controllable.increaseAllowance gas consumption", async() => {
    const instance = await Controllable.new();
    await instance.mint(accounts[0],30);
    await instance.approve(accounts[1], 10, {from: accounts[0]});
    const result = await instance.increaseAllowance(accounts[1], 20, {from: accounts[0]});
    const gasUsed = await result.receipt.gasUsed;
    console.log("Controllable.increaseAllowance Gas Used: ", gasUsed);
  });    

  it("test Controllable.decreaseAllowance gas consumption", async() => {
    const instance = await Controllable.new();
    await instance.mint(accounts[0],30);
    await instance.approve(accounts[1], 30, {from: accounts[0]});
    const result = await instance.decreaseAllowance(accounts[1], 10, {from: accounts[0]});
    const gasUsed = await result.receipt.gasUsed;
    console.log("Controllable.decreaseAllowance Gas Used: ", gasUsed);
  });  





})





