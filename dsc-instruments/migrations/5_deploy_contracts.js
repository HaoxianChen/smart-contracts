var Erc20 = artifacts.require("Erc20");

module.exports = function(deployer) {
  deployer.deploy(Erc20);
};