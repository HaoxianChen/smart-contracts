var YourContract = artifacts.require("Auction");

contract('Auction', function(accounts) {
  it("get the size of the Auction contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("Auction size of bytecode in bytes = ", sizeOfB);
      console.log("Auction size of deployed in bytes = ", sizeOfD);
      console.log("Auction initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});