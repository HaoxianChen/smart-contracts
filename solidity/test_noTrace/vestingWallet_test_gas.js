const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var VestingWallet = artifacts.require("VestingWallet");


contract("VestingWallet", async accounts => {
    it("test VestingWallet.release gas consumption", async () => {
      const instance = await VestingWallet.new(accounts[0], 1, 1);
      await instance.send(30, {value: 30});
      const result = await instance.release({from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("VestingWallet.release Gas Used: ", gasUsed);
    });    
   
   

});

