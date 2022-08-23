var NFT = artifacts.require("Nft");

module.exports = function(deployer) {
  deployer.deploy(NFT);
};