var YourContract = artifacts.require("Nft");

contract('NFT', function(accounts) {
  it("get the size of the NFT contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("NFT size of bytecode in bytes = ", sizeOfB);
      console.log("NFT size of deployed in bytes = ", sizeOfD);
      console.log("NFT initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});