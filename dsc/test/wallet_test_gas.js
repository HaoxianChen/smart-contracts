var Wallet = artifacts.require("Wallet");


contract("Wallet", async accounts => {
    it("test datalog Wallet.mint gas consumption", async () => {
      const instance = await Wallet.deployed();
      await instance.mint(accounts[0], 10);
      const result = await instance.mint(accounts[1], 1);
      const gasUsed = await result.receipt.gasUsed;
      console.log("datalog Wallet.mint Gas Used: ", gasUsed);


    });

    it("test datalog Wallet.burn gas consumption", async () => {
       const instance = await Wallet.deployed();
       await instance.mint(accounts[0], 1000);
       const result = await instance.burn(accounts[0], 100);
       const gasUsed = await result.receipt.gasUsed;
       console.log("datalog Wallet.burn Gas Used: ", gasUsed);
  
  
      });

    it("test datalog Wallet.transfer gas consumption", async () => {
    const instance = await Wallet.deployed();
    await instance.mint(accounts[0], 1000);
    await instance.mint(accounts[1], 1000);
    const result = await instance.transfer(accounts[0], accounts[1], 100);
    const gasUsed = await result.receipt.gasUsed;
    console.log("datalog Wallet.transfer Gas Used: ", gasUsed);


    });

});