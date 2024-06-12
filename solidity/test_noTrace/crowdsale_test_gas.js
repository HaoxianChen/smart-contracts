
const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');


const BigNumber = require('bignumber.js');
var Crowdsale = artifacts.require("Crowdsale");
var Escrow = artifacts.require("Escrow");


contract("Crowdsale", async accounts => {
    it("test Crowdsale.invest gas consumption", async () => {
      const instance = await Crowdsale.deployed();
      //await instance.mint(accounts[0], 1000);
      const result = await instance.invest();
      const gasUsed = await result.receipt.gasUsed;
      console.log("Crowdsale.invest Gas Used: ", gasUsed);

    });

    it("test Crowdsale.close gas consumption", async () => {
        const instance = await Crowdsale.deployed();
        await time.increase(time.duration.days(31));
        const result = await instance.close();
        const gasUsed = await result.receipt.gasUsed;
        console.log("Crowdsale.close Gas Used: ", gasUsed);
  
  
      });
});