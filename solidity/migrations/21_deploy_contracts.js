const WBTC = artifacts.require("WBTC");

module.exports = function (deployer) {
 	deployer.deploy(WBTC);
};
