const BNB = artifacts.require("BNB");

module.exports = function (deployer) {
  deployer.deploy(BNB, 30, "BNB Token", 18, "BNB");
};
