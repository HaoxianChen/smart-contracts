// source: https://github.com/eth-sri/verx-benchmarks/blob/master/overview/main.sol
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Escrow {
  mapping(address => uint256) deposits;
  enum State {OPEN, SUCCESS, REFUND}
  State state = State.OPEN;
  address owner;
  address payable beneficiary;

  constructor(address payable b) public {
    beneficiary = b;
    owner = msg.sender;
  }

  function deposit(address p) onlyOwner public payable {
    deposits[p] = deposits[p] + msg.value;
  }

  function withdraw() public {
    require(state == State.SUCCESS);
    beneficiary.transfer(address(this).balance);
  }

  function claimRefund(address payable p) public {
    require(state == State.REFUND);
    uint256 amount = deposits[p];
    deposits[p] = 0;
    p.transfer(amount);
  }

  modifier onlyOwner {require(owner == msg.sender); _; }
  function close() onlyOwner public{state = State.SUCCESS;}
  function refund() onlyOwner public{state = State.REFUND;}
}

contract Crowdsale {
  Escrow escrow;
  uint256 raised = 0;
  uint256 goal = 10000 * 10**18;
  uint256 closeTime = block.timestamp + 30 days;

  //address payable constant init = payable(address(uint160(0xDEADBEEF)));

  constructor() public{
    escrow = new Escrow(payable(address(0xDEADBEEF)));
  }

  function invest() payable public{
    // fix:
    require(block.timestamp<=closeTime);
    require(raised < goal);
    escrow.deposit{value: msg.value}(msg.sender);
    raised += msg.value;
  }

  function close() public{
    require(block.timestamp > closeTime || raised >= goal);
    if (raised >= goal) {
      escrow.close();
    } else {
      escrow.refund();
	 }
  }
}

contract Deployer{
    Crowdsale c = new Crowdsale();
}