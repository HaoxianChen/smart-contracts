var YourContract = artifacts.require("Voting");

contract('Voting', function(accounts) {
  it("get the size of the Voting contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("Voting size of bytecode in bytes = ", sizeOfB);
      console.log("Voting size of deployed in bytes = ", sizeOfD);
      console.log("Voting initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});