const ERC777 = artifacts.require("ERC777");

module.exports = function (deployer) {
	let emptyArray = [];
 	deployer.deploy(ERC777, "ERC777_name", "ERC777_symbol", emptyArray);
};
