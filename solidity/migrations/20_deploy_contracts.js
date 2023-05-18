const Voting = artifacts.require("Voting");

module.exports = function (deployer, network, accounts) {
	let voters = accounts.slice(0, accounts.length-1);
 	deployer.deploy(Voting, voters, Math.ceil(voters.length/2)+1);
};
