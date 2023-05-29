var YourContract = artifacts.require("WBTC");

contract('WBTC', function(accounts) {
  it("get the size of the WBTC contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("WBTC size of bytecode in bytes = ", sizeOfB);
      console.log("WBTC size of deployed in bytes = ", sizeOfD);
      console.log("WBTC initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});