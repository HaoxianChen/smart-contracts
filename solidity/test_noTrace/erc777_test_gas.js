const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var ERC777 = artifacts.require("ERC777");


contract("ERC777", async accounts => {
    it("test ERC777.send gas consumption", async () => {
      let emptyArr = [];
      const instance = await ERC777.new("ERC777_name", "ERC777_symbol", emptyArr);
      await instance.mint(accounts[0], 30, 0x100, 0x200);
      const result = await instance.send(accounts[1], 20, 0x300, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ERC777.send Gas Used: ", gasUsed);
    });    

    it("test ERC777.transfer gas consumption", async () => {
      let emptyArr = [];
      const instance = await ERC777.new("ERC777_name", "ERC777_symbol", emptyArr);
      await instance.mint(accounts[0], 30, 0x100, 0x200);
      const result = await instance.transfer(accounts[1], 20, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ERC777.transfer Gas Used: ", gasUsed);
    });    

    it("test ERC777.burn gas consumption", async () => {
      let emptyArr = [];
      const instance = await ERC777.new("ERC777_name", "ERC777_symbol", emptyArr);
      await instance.mint(accounts[0], 30, 0x100, 0x200);
      const result = await instance.burn(30, 0x100, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ERC777.burn Gas Used: ", gasUsed);
    });    

    it("test ERC777.authorizeOperator gas consumption", async () => {
      let emptyArr = [];
      const instance = await ERC777.new("ERC777_name", "ERC777_symbol", emptyArr);
      const result = await instance.authorizeOperator(accounts[1], {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ERC777.authorizeOperator Gas Used: ", gasUsed);
    });    

    it("test ERC777.revokeOperator gas consumption", async () => {
      let emptyArr = [];
      const instance = await ERC777.new("ERC777_name", "ERC777_symbol", emptyArr);
      await instance.authorizeOperator(accounts[1], {from: accounts[0]});
      const result = await instance.revokeOperator(accounts[1], {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ERC777.revokeOperator Gas Used: ", gasUsed);
    });   

    it("test ERC777.operatorSend gas consumption", async () => {
      let emptyArr = [];
      const instance = await ERC777.new("ERC777_name", "ERC777_symbol", emptyArr);
      await instance.mint(accounts[0], 30, 0x100, 0x200);
      await instance.authorizeOperator(accounts[1], {from: accounts[0]});
      const result = await instance.operatorSend(accounts[0], accounts[2], 30, 0x100, 0x200, {from: accounts[1]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ERC777.operatorSend Gas Used: ", gasUsed);
    });    

    it("test ERC777.operatorBurn gas consumption", async () => {
      let emptyArr = [];
      const instance = await ERC777.new("ERC777_name", "ERC777_symbol", emptyArr);
      await instance.mint(accounts[0], 30, 0x100, 0x200);
      await instance.authorizeOperator(accounts[1], {from: accounts[0]});
      const result = await instance.operatorBurn(accounts[0], 30, 0x100, 0x200, {from: accounts[1]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ERC777.operatorBurn Gas Used: ", gasUsed);
    });    

    it("test ERC777.approve gas consumption", async () => {
      let emptyArr = [];
      const instance = await ERC777.new("ERC777_name", "ERC777_symbol", emptyArr);
      await instance.mint(accounts[0], 30, 0x100, 0x200);
      const result = await instance.approve(accounts[1], 20, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ERC777.approve Gas Used: ", gasUsed);
    });    

    it("test ERC777.transferFrom gas consumption", async () => {
      let emptyArr = [];
      const instance = await ERC777.new("ERC777_name", "ERC777_symbol", emptyArr);
      await instance.mint(accounts[0], 30, 0x100, 0x200);
      await instance.approve(accounts[1], 30, {from: accounts[0]});
      const result = await instance.transferFrom(accounts[0], accounts[2], 30, {from: accounts[1]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("ERC777.transferFrom Gas Used: ", gasUsed);
    });    

    it("test ERC777.mint gas consumption", async () => {
      let emptyArr = [];
      const instance = await ERC777.new("ERC777_name", "ERC777_symbol", emptyArr);
      const result = await instance.mint(accounts[0], 30, 0x100, 0x200);
      const gasUsed = await result.receipt.gasUsed;
      console.log("ERC777.mint Gas Used: ", gasUsed);
    });













});