var YourContract = artifacts.require("TetherToken");

contract('TetherToken', function(accounts) {
  it("get the size of the TetherToken contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("TetherToken size of bytecode in bytes = ", sizeOfB);
      console.log("TetherToken size of deployed in bytes = ", sizeOfD);
      console.log("TetherToken initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});