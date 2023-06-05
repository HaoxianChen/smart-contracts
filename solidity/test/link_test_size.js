var YourContract = artifacts.require("LinkToken");

contract('Link', function(accounts) {
  it("get the size of the Link contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("Link size of bytecode in bytes = ", sizeOfB);
      console.log("Link size of deployed in bytes = ", sizeOfD);
      console.log("Link initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});