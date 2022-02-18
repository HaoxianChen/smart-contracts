contract Auction {
  struct BalanceTuple {
    address p;
    uint n;
  }
  struct HighestBidTuple {
    address bidder;
    uint amount;
  }
  struct MsgSenderTuple {
    address p;
  }
  struct MsgValueTuple {
    uint p;
  }
  mapping(address=>balanceTuple) balance;
  HighestBidTuple highestBid;
  function bid() public  {
    updateBidOnRecv_bid();
  }
  function withdraw() public  {
    updateWithdrawOnRecv_withdraw();
  }
  function updateWithdrawOnRecv_withdraw() private  {
    require(true==end.b,"condition true==end.b is false.");
    address p = msg.sender;
    BalanceTuple memory balanceTuple = balance[p];
    uint n = balanceTuple.n;
    require(n>0,"condition n>0 is false.");
    updateWithdrawTotalOnWithdraw(p,n);
  }
  function updateBidOnRecv_bid() private  {
    uint m = highestBid.amount;
    require(false==end.b,"condition false==end.b is false.");
    uint n = msg.value;
    address p = msg.sender;
    require(n>m,"condition n>m is false.");
    updateHighestBidOnBid(p,n);
    updateBidTotalOnBid(p,n);
  }
  function updateHighestBidOnBid(address p,uint m) private  {
    HighestBidTuple memory highestBidTuple = highestBid;
    uint _max = highestBid.amount;
    if(m>_max) {
      highestBid = HighestBidTuple(p,m);
    }
  }
  function updateBidTotalOnBid(address p,uint m) private  {
    uint delta = m;
    updateBalanceOnBidTotal(p,delta);
  }
  function updateWithdrawTotalOnWithdraw(address p,uint m) private  {
    uint delta = m;
    updateBalanceOnWithdrawTotal(p,delta);
  }
  function updateBalanceOnWithdrawTotal(address p,uint w) private  {
    balance[p].n -= w;
  }
  function updateBalanceOnBidTotal(address p,uint b) private  {
    balance[p].n += b;
  }
}