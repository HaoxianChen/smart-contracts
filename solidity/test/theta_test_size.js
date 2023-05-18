var YourContract = artifacts.require("ThetaToken");

contract('ThetaToken', function(accounts) {
  it("get the size of the ThetaToken contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("ThetaToken size of bytecode in bytes = ", sizeOfB);
      console.log("ThetaToken size of deployed in bytes = ", sizeOfD);
      console.log("ThetaToken initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});