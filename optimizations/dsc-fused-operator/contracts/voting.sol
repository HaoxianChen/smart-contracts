contract Voting {
  struct QuorumSizeTuple {
    uint q;
    bool _valid;
  }
  struct IsVoterTuple {
    bool b;
    bool _valid;
  }
  struct WinningProposalTuple {
    uint proposal;
    bool _valid;
  }
  struct VotedTuple {
    bool b;
    bool _valid;
  }
  struct VotesTuple {
    uint c;
    bool _valid;
  }
  struct WinsTuple {
    bool b;
    bool _valid;
  }
  struct HasWinnerTuple {
    bool b;
    bool _valid;
  }
  mapping(address=>IsVoterTuple) isVoter;
  WinningProposalTuple winningProposal;
  mapping(address=>VotedTuple) voted;
  HasWinnerTuple hasWinner;
  mapping(uint=>VotesTuple) votes;
  mapping(uint=>WinsTuple) wins;
  QuorumSizeTuple quorumSize;
  event Vote(address p,uint proposal);
  function getWinningProposal() public view  returns (uint) {
      uint proposal = winningProposal.proposal;
      return proposal;
  }
  function getIsVoter(address v) public view  returns (bool) {
      IsVoterTuple memory isVoterTuple = isVoter[v];
      bool b = isVoterTuple.b;
      return b;
  }
  function getWins(uint proposal) public view  returns (bool) {
      WinsTuple memory winsTuple = wins[proposal];
      bool b = winsTuple.b;
      return b;
  }
  function getVotes(uint proposal) public view  returns (uint) {
      VotesTuple memory votesTuple = votes[proposal];
      uint c = votesTuple.c;
      return c;
  }
  function getVoted(address p) public view  returns (bool) {
      VotedTuple memory votedTuple = voted[p];
      bool b = votedTuple.b;
      return b;
  }
  function getHasWinner() public view  returns (bool) {
      bool b = hasWinner.b;
      return b;
  }
  function vote(uint proposal) public    {
      bool r5 = updateVoteOnInsertRecv_vote_r5(proposal);
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function updateVotesOnInsertVote_r0(address _p0,uint p) private    {
      int delta1 = int(1);
      updateWinsOnIncrementVotes_r2(p,delta1);
      int _delta = int(1);
      uint newValue = updateuintByint(votes[p].c,_delta);
      votes[p].c = newValue;
  }
  function updateHasWinnerOnInsertWins_r1(bool b) private    {
      if(b==true) {
        hasWinner = HasWinnerTuple(true,true);
      }
  }
  function updateWinningProposalOnInsertWins_r4(uint p,bool b) private    {
      if(b==true) {
        winningProposal = WinningProposalTuple(p,true);
      }
  }
  function updateVotedOnInsertVote_r3(address v) private    {
      if(true) {
        voted[v] = VotedTuple(true,true);
      }
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateWinsOnInsertVotes_r2(uint p,uint c) private    {
      if(true) {
        uint q = quorumSize.q;
        if(c>=q) {
          updateHasWinnerOnInsertWins_r1(bool(true));
          updateWinningProposalOnInsertWins_r4(p,bool(true));
          wins[p] = WinsTuple(true,true);
        }
      }
  }
  function updateVoteOnInsertRecv_vote_r5(uint p) private   returns (bool) {
      if(false==hasWinner.b) {
        if(true) {
          address v = msg.sender;
          IsVoterTuple memory isVoterTuple = isVoter[v];
          if(true==isVoterTuple.b) {
            VotedTuple memory votedTuple = voted[v];
            if(false==votedTuple.b) {
              if(true) {
                updateVotesOnInsertVote_r0(v,p);
                updateVotedOnInsertVote_r3(v);
                emit Vote(v,p);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
  function updateWinsOnIncrementVotes_r2(uint p,int c) private    {
      int _delta = int(c);
      uint newValue = updateuintByint(votes[p].c,_delta);
      updateWinsOnInsertVotes_r2(p,newValue);
  }
}