var YourContract = artifacts.require("LtcSwapAsset");

contract('LtcSwapAsset', function(accounts) {
  it("get the size of the LtcSwapAsset contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("LtcSwapAsset size of bytecode in bytes = ", sizeOfB);
      console.log("LtcSwapAsset size of deployed in bytes = ", sizeOfD);
      console.log("LtcSwapAsset initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});