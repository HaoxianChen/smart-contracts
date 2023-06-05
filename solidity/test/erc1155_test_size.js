var YourContract = artifacts.require("ERC1155");

contract('ERC1155', function(accounts) {
  it("get the size of the ERC1155 contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("ERC1155 size of bytecode in bytes = ", sizeOfB);
      console.log("ERC1155 size of deployed in bytes = ", sizeOfD);
      console.log("ERC1155 initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});