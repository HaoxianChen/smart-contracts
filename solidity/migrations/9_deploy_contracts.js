const Controllable = artifacts.require("Controllable");

module.exports = function (deployer) {
  deployer.deploy(Controllable);
};
