// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Voting {
  mapping(uint32 => uint32) votes;
  mapping(address => bool) isVoter;
  mapping(address => bool) hasVoted;
  
  mapping(uint32 => bool) wins;
  bool hasWinner;

  uint32 quorum;

  constructor (address[] memory voters, uint32 _quorum) {
    for (uint i = 0; i < voters.length; i++) {
      isVoter[voters[i]] = true;
    }
    quorum = _quorum;
  }

  function vote (uint32 proposal) public {
    if (isVoter[msg.sender] && !hasVoted[msg.sender] && !hasWinner) {
      votes[proposal] += 1;
      hasVoted[msg.sender] = true;
    }

    if (votes[proposal] > quorum) {
      wins[proposal] = true;
      hasWinner = true;
    }
  }

  function inconsistency(uint32 p1, uint32 p2) public view {
    assert(p1==p2 || !(wins[p1] && wins[p2]));
  }
}
