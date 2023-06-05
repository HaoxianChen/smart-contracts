var YourContract = artifacts.require("TokenPartition");

contract('TokenPartition', function(accounts) {
  it("get the size of the TokenPartition contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("TokenPartition size of bytecode in bytes = ", sizeOfB);
      console.log("TokenPartition size of deployed in bytes = ", sizeOfD);
      console.log("TokenPartition initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});