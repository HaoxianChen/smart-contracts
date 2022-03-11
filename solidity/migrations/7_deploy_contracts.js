const Token = artifacts.require("token");

module.exports = function (deployer) {
  deployer.deploy(Token);
};
