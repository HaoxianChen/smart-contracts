const TokenMintERC20Token = artifacts.require("TokenMintERC20Token");

module.exports = function (deployer, network, accounts) {
 	deployer.deploy(TokenMintERC20Token, "tokenName", "tokenSymbol", 18, 100, accounts[0], accounts[1]);
};
