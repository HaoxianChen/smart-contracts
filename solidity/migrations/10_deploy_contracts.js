const ERC1155 = artifacts.require("ERC1155");

module.exports = function (deployer) {
  deployer.deploy(ERC1155, "https://token-cdn-domain/01.json");
};
