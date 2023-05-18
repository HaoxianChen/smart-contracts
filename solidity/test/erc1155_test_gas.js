const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var ERC1155 = artifacts.require("ERC1155");


contract("ERC1155", async accounts => {
  it("test ERC1155.setApprovalForAll gas consumption", async() => {
    const instance = await ERC1155.new("https://token-cdn-domain/01.json");
    const result = await instance.setApprovalForAll(accounts[1], true);
    const gasUsed = await result.receipt.gasUsed;
    console.log("ERC1155.setApprovalForAll Gas Used: ", gasUsed);
  }); 

  it("test ERC1155.safeTransferFrom gas consumption", async() => {
    const instance = await ERC1155.new("https://token-cdn-domain/01.json");
    await instance.mint(accounts[0], 1, 30, 0x1155);
    const result = await instance.safeTransferFrom(accounts[0],accounts[1],1, 10, 0x1155, {from: accounts[0]});
    const gasUsed = await result.receipt.gasUsed;
    console.log("ERC1155.safeTransferFrom Gas Used: ", gasUsed);
  });    

  it("test ERC1155.mint gas consumption", async() => {
    const instance = await ERC1155.new("https://token-cdn-domain/01.json");
    const result = await instance.mint(accounts[0], 1, 30, 0x1155);
    const gasUsed = await result.receipt.gasUsed;
    console.log("ERC1155.mint Gas Used: ", gasUsed);
  });   

  it("test ERC1155.burn gas consumption", async() => {
    const instance = await ERC1155.new("https://token-cdn-domain/01.json");
    await instance.mint(accounts[0], 1, 30, 0x1155);
    const result = await instance.burn(accounts[0], 1, 30);
    const gasUsed = await result.receipt.gasUsed;
    console.log("ERC1155.burn Gas Used: ", gasUsed);
  });  



  // the rest of the functions are interal/private/view


})