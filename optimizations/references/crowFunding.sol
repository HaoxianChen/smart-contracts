// source: https://github.com/eth-sri/verx-benchmarks/blob/master/overview/main.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {
  mapping(address => uint256) deposits;
  enum State {OPEN, SUCCESS, REFUND}
  State state = State.OPEN;
  address owner;
  address payable beneficiary;
  // uint256 totalFunds;
  uint256 raised;

  constructor(address payable b) public {
    beneficiary = b;
    owner = msg.sender;
    // totalFunds = 0;
    raised = 0;
  }

  function deposit(address p) onlyOwner public payable {
    deposits[p] = deposits[p] + msg.value;
    // totalFunds += msg.value;
    raised += msg.value;
  }

  function withdraw() public {
    require(state == State.SUCCESS);
    beneficiary.transfer(address(this).balance);
    // totalFunds = 0;
  }

  function claimRefund(address payable p) public {
    require(state == State.REFUND);
    uint256 amount = deposits[p];
    deposits[p] = 0;
    p.transfer(amount);
    totalFunds -= amount;
  }

  modifier onlyOwner {require(owner == msg.sender); _; }
  function close() onlyOwner public{state = State.SUCCESS;}
  function refund() onlyOwner public{state = State.REFUND;}
  // function check() public view {
  //   assert(totalFunds == raised || state != State.OPEN);
  // }
}

contract Crowdsale {
  Escrow escrow;
  uint256 raised = 0;
  uint256 goal = 10000 * 10**18;
  uint256 closeTime = block.timestamp + 30 days;
  bool closed;

  //address payable constant init = payable(address(uint160(0xDEADBEEF)));

  constructor(uint256 _goal, address _escrow) public{
    // escrow = new Escrow(payable(address(0xDEADBEEF)));
    escrow = new Escrow(payable(_escrow));
    goal = _goal;
    closed = false;
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
      closed = true;
    } else {
      escrow.refund();
	 }
  }
}

contract Deployer{
    Crowdsale c = new Crowdsale(10000 * 10**18, address(0xDEADBEEF));
}
