var YourContract = artifacts.require("CrowFunding");

contract('CrowFunding', function(accounts) {
  it("get the size of the CrowFunding contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("CrowFunding size of bytecode in bytes = ", sizeOfB);
      console.log("CrowFunding size of deployed in bytes = ", sizeOfD);
      console.log("CrowFunding initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});