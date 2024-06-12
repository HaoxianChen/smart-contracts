var YourContract = artifacts.require("SimpleAuction");

contract('SimpleAuction', function(accounts) {
  it("get the size of the SimpleAuction contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("SimpleAuction size of bytecode in bytes = ", sizeOfB);
      console.log("SimpleAuction size of deployed in bytes = ", sizeOfD);
      console.log("SimpleAuction initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});