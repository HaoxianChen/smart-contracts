var Crowdsale = artifacts.require("Crowdsale");

module.exports = function(deployer) {
    deployer.deploy(Crowdsale);
  };