var YourContract = artifacts.require("BNB");

contract('BNB', function(accounts) {
  it("get the size of the BNB contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("BNB size of bytecode in bytes = ", sizeOfB);
      console.log("BNB size of deployed in bytes = ", sizeOfD);
      console.log("BNB initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});