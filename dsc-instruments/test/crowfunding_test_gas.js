var CrowFunding = artifacts.require("CrowFunding");


contract("CrowFunding", async accounts => {
    it("test datalog CrowFunding.invest gas consumption", async () => {
      const instance = await CrowFunding.new(10, accounts[0]);
      const result = await instance.invest();
      const gasUsed = await result.receipt.gasUsed;
      console.log("datalog CrowFunding.invest Gas Used: ", gasUsed);


    });

    it("test datalog CrowFunding.close gas consumption", async () => {
        const instance = await CrowFunding.new(10, accounts[0]);
        const result = await instance.close();
        const gasUsed = await result.receipt.gasUsed;
        console.log("datalog CrowFunding.close Gas Used: ", gasUsed);
  
  
      });

    it("test datalog CrowFunding.refund gas consumption", async () => {
        const instance = await CrowFunding.new(10, accounts[0]);
        await instance.invest({value: 5});
        await instance.close();
        const result = await instance.refund();
        const gasUsed = await result.receipt.gasUsed;
        console.log("datalog CrowFunding.refund Gas Used: ", gasUsed);
  
  
  
      });

      it("test datalog CrowFunding.withdraw gas consumption", async () => {
        const instance = await CrowFunding.deployed();
        const result = await instance.withdraw();
        const gasUsed = await result.receipt.gasUsed;
        console.log("datalog CrowFunding.withdraw Gas Used: ", gasUsed);
  

  
  
      });


    





});