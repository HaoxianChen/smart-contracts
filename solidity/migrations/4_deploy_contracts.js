var Escrow = artifacts.require("Escrow");

module.exports = function(deployer, network, accounts) {
    deployer.deploy(Escrow, accounts[0]);
  };