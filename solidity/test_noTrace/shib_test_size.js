var YourContract = artifacts.require("TokenMintERC20Token");

contract('TokenMintERC20Token', function(accounts) {
  it("get the size of the TokenMintERC20Token contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("TokenMintERC20Token size of bytecode in bytes = ", sizeOfB);
      console.log("TokenMintERC20Token size of deployed in bytes = ", sizeOfD);
      console.log("TokenMintERC20Token initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});