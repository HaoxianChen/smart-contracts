const VestingWallet = artifacts.require("VestingWallet");

module.exports = function (deployer, network, accounts) {
 	deployer.deploy(VestingWallet, accounts[0], 1, 1);
};
