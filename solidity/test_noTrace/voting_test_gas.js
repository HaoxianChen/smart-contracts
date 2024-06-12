const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var Voting = artifacts.require("Voting");


contract("Voting", async accounts => {
  let voters = accounts.slice(0, accounts.length-1);
    it("test Voting.vote gas consumption", async () => {
      const instance = await Voting.new(voters, Math.ceil(voters.length/2)+1);
      const result = await instance.vote(10, {from: accounts[0]});
      const gasUsed = await result.receipt.gasUsed;
      console.log("Voting.vote Gas Used: ", gasUsed);
    });    
   
   

});
