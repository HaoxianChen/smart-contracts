const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var Auction = artifacts.require("SimpleAuction");


contract("SimpleAuction", async accounts => {

    it("test SimpleAuction.withdraw gas consumption", async () => {
        const instance = await Auction.new(30, accounts[0]);
        await instance.bid({from: accounts[1], value: 100})
        const result = await instance.withdraw({from: accounts[1]});
        const gasUsed = await result.receipt.gasUsed;
        console.log("SimpleAuction.withdraw Gas Used: ", gasUsed);
  
  
      });


});