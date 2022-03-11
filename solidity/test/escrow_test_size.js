var YourContract = artifacts.require("Escrow");

contract('Escrow', function(accounts) {
  it("get the size of the Escrow contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("Escrow size of bytecode in bytes = ", sizeOfB);
      console.log("Escrow size of deployed in bytes = ", sizeOfD);
      console.log("Escrow initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});