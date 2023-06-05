var YourContract = artifacts.require("Crowdsale");

contract('Crowdsale', function(accounts) {
  it("get the size of the Crowdsale contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("Crowdsale size of bytecode in bytes = ", sizeOfB);
      console.log("Crowdsale size of deployed in bytes = ", sizeOfD);
      console.log("Crowdsale initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});