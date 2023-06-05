const ThetaToken = artifacts.require("ThetaToken");

module.exports = function (deployer) {
 	deployer.deploy(ThetaToken, 10);
};
