var Escrow = artifacts.require("SimpleAuction");

module.exports = function(deployer, network, accounts) {
    deployer.deploy(Escrow, 30, accounts[0]);
  };