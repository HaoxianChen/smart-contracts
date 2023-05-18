const LtcSwapAsset = artifacts.require("LtcSwapAsset");

module.exports = function (deployer) {
 	deployer.deploy(LtcSwapAsset);
};
