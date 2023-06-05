var YourContract = artifacts.require("Wallet");

contract('Wallet', function(accounts) {
  it("get the size of the Wallet contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("Wallet size of bytecode in bytes = ", sizeOfB);
      console.log("Wallet size of deployed in bytes = ", sizeOfD);
      console.log("Wallet initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});