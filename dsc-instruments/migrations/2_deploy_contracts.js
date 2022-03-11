var CrowFunding = artifacts.require("CrowFunding");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(CrowFunding, 0, accounts[0]);
};