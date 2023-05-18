const MaticToken = artifacts.require("MaticToken");

module.exports = function (deployer) {
 	deployer.deploy(MaticToken, "tokenName", "tokenSymbol", 18, 100);
};
