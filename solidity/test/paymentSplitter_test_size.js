var YourContract = artifacts.require("PaymentSplitter");

contract('Token', function(PaymentSplitter) {
  it("get the size of the Token contract", function() {
    return YourContract.deployed().then(function(instance) {
      var bytecode = instance.constructor._json.bytecode;
      var deployed = instance.constructor._json.deployedBytecode;
      var sizeOfB  = bytecode.length / 2;
      var sizeOfD  = deployed.length / 2;
      console.log("PaymentSplitter size of bytecode in bytes = ", sizeOfB);
      console.log("PaymentSplitter size of deployed in bytes = ", sizeOfD);
      console.log("PaymentSplitter initialisation and constructor code in bytes = ", sizeOfB - sizeOfD);
    });  
  });
});