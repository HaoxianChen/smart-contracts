const NFT = artifacts.require("nft");

module.exports = function (deployer) {
  deployer.deploy(NFT);
};
