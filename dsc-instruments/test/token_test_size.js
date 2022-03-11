var YourContract = artifacts.require("Erc20");

contract('Erc20', function(accounts) {
  it("get the size of the Token contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("Token size of bytecode in bytes = ", sizeOfB);
      console.log("Token size of deployed in bytes = ", sizeOfD);
      console.log("Token initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});