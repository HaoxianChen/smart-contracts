const PaymentSplitter = artifacts.require("PaymentSplitter");

module.exports = function (deployer, network, accounts) {
	let length = accounts.length;
	let payees = accounts.slice(0, parseInt(length/2));
	let lengthPayee = payees.length;
	let shares = [];
	let oneShare = Math.floor(100/lengthPayee);
	for (let i = 0; i < lengthPayee; i++) {
		shares.push(oneShare);
	}
 	deployer.deploy(PaymentSplitter, payees, shares);
};
