var YourContract = artifacts.require("MaticToken");

contract('MaticToken', function(accounts) {
  it("get the size of the MaticToken contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("MaticToken size of bytecode in bytes = ", sizeOfB);
      console.log("MaticToken size of deployed in bytes = ", sizeOfD);
      console.log("MaticToken initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});