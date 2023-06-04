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
      int delta0 = int(1);
      updateWinsOnIncrementVotes_r2(p,delta0);
      int _delta = int(1);
      uint newValue = updateuintByint(votes[p].c,_delta);
      votes[p].c = newValue;
  }
  function updateHasWinnerOnDeleteWins_r1(bool b) private    {
      if(b==true) {
        hasWinner = HasWinnerTuple(false,false);
      }
  }
  function updateVotedOnInsertVote_r3(address v) private    {
      voted[v] = VotedTuple(true,true);
  }
  function updateWinsOnDeleteVotes_r2(uint p,uint c) private    {
      uint q = quorumSize.q;
      if(c>=q) {
        updateWinningProposalOnDeleteWins_r4(p,bool(true));
        updateHasWinnerOnDeleteWins_r1(bool(true));
        WinsTuple memory winsTuple = wins[p];
        if(true==winsTuple.b) {
          wins[p] = WinsTuple(false,false);
        }
      }
  }
  function updateWinningProposalOnInsertWins_r4(uint p,bool b) private    {
      WinsTuple memory toDelete = wins[p];
      if(toDelete._valid==true) {
        updateWinningProposalOnDeleteWins_r4(p,toDelete.b);
      }
      if(b==true) {
        winningProposal = WinningProposalTuple(p,true);
      }
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateWinsOnInsertVotes_r2(uint p,uint c) private    {
      VotesTuple memory toDelete = votes[p];
      if(toDelete._valid==true) {
        updateWinsOnDeleteVotes_r2(p,toDelete.c);
      }
      uint q = quorumSize.q;
      if(c>=q) {
        updateHasWinnerOnInsertWins_r1(bool(true));
        updateWinningProposalOnInsertWins_r4(p,bool(true));
        wins[p] = WinsTuple(true,true);
      }
  }
  function updateWinningProposalOnDeleteWins_r4(uint p,bool b) private    {
      if(b==true) {
        winningProposal = WinningProposalTuple(0,false);
      }
  }
  function updateHasWinnerOnInsertWins_r1(bool b) private    {
      WinsTuple memory toDelete = wins[_];
      if(toDelete._valid==true) {
        updateHasWinnerOnDeleteWins_r1(toDelete.b);
      }
      if(b==true) {
        hasWinner = HasWinnerTuple(true,true);
      }
  }
  function updateVoteOnInsertRecv_vote_r5(uint p) private   returns (bool) {
      if(false==hasWinner.b) {
        address v = msg.sender;
        IsVoterTuple memory isVoterTuple = isVoter[v];
        if(true==isVoterTuple.b) {
          VotedTuple memory votedTuple = voted[v];
          if(false==votedTuple.b) {
            updateVotesOnInsertVote_r0(v,p);
            updateVotedOnInsertVote_r3(v);
            emit Vote(v,p);
            return true;
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