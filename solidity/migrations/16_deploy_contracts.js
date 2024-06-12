const TetherToken = artifacts.require("TetherToken");

module.exports = function (deployer) {
 	deployer.deploy(TetherToken, 100, "tokenName", "tokenSymbol", 18);
};
