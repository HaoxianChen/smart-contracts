var Wallet = artifacts.require("./wallet.sol");


contract("Wallet", async accounts => {
    it("test Wallet.mint gas consumption", async () => {
      const instance = await Wallet.deployed();
      await instance.mint(accounts[0], 1000);
      const result = await instance.mint(accounts[0], 100);
      const gasUsed = await result.receipt.gasUsed;
      console.log("Wallet.mint Gas Used: ", gasUsed);


    });

    it("test Wallet.burn gas consumption", async () => {
        const instance = await Wallet.deployed();
        await instance.mint(accounts[0], 1000);
        const result = await instance.burn(accounts[0], 100);
        const gasUsed = await result.receipt.gasUsed;
        console.log("Wallet.burn Gas Used: ", gasUsed);
  
  
      });

    it("test Wallet.transfer gas consumption", async () => {
    const instance = await Wallet.deployed();
    await instance.mint(accounts[0], 1000);
    const result = await instance.transfer(accounts[0], accounts[1], 100);
    const gasUsed = await result.receipt.gasUsed;
    console.log("Wallet.transfer Gas Used: ", gasUsed);


    });

});