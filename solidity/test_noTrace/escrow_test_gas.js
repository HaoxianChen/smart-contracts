var Escrow = artifacts.require("Escrow");

contract("Escrow", async accounts => {
    it("test Escrow.deposit gas consumption", async () => {
      const instance = await Escrow.new(accounts[0]);
      const result = await instance.deposit(accounts[1]);
      const gasUsed = await result.receipt.gasUsed;
      console.log("Escrow.deposit Gas Used: ", gasUsed);


    });

    it("test Escrow.withdraw gas consumption", async () => {
      const instance = await Escrow.new(accounts[0]);
      await instance.close();
      const result = await instance.withdraw();
      const gasUsed = await result.receipt.gasUsed;
      console.log("Escrow.withdraw Gas Used: ", gasUsed);
  
  
      });

    it("test Escrow.claimRefund gas consumption", async () => {
        const instance = await Escrow.new(accounts[0]);
        await instance.refund();
        const result = await instance.claimRefund(accounts[1]);
        const gasUsed = await result.receipt.gasUsed;
        console.log("Escrow.claimRefund Gas Used: ", gasUsed);
    
    
        });

    it("test Escrow.close gas consumption", async () => {
        const instance = await Escrow.new(accounts[0]);
        const result = await instance.close();
        const gasUsed = await result.receipt.gasUsed;
        console.log("Escrow.close Gas Used: ", gasUsed);
    
    
        });

    it("test Escrow.refund gas consumption", async () => {
        const instance = await Escrow.new(accounts[0]);
        const result = await instance.refund();
        const gasUsed = await result.receipt.gasUsed;
        console.log("Escrow.refund Gas Used: ", gasUsed);
    
    
        });


});

