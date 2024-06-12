const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var PaymentSplitter = artifacts.require("PaymentSplitter");


contract("PaymentSplitter", async accounts => {
    let length = accounts.length;
    let payees = accounts.slice(0, parseInt(length/2));
    let lengthPayee = payees.length;
    let shares = [];
    let oneShare = Math.floor(100/lengthPayee);
    for (let i = 0; i < lengthPayee; i++) {
      shares.push(oneShare);
    }
    it("test PaymentSplitter.release gas consumption", async () => {
      const instance = await PaymentSplitter.new(payees, shares);
      await instance.send(30, {value: 30});
      const result = await instance.release(accounts[0]);
      const gasUsed = await result.receipt.gasUsed;
      console.log("PaymentSplitter.release Gas Used: ", gasUsed);
    });

});

