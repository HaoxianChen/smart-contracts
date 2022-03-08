contract Auction {
  struct BalanceTuple {
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct WithdrawCountTuple {
    uint c;
    bool _valid;
  }
  struct BeneficiaryTuple {
    address p;
    bool _valid;
  }
  struct HighestBidTuple {
    address bidder;
    uint amount;
    bool _valid;
  }
  struct EndTimeTuple {
    uint t;
    bool _valid;
  }
  struct RepeatWithdrawTuple {
    uint c;
    bool _valid;
  }
  struct EndTuple {
    bool b;
    bool _valid;
  }
  struct RepeatWithdrawKeyTuple {
    address p;
  }
  mapping(address=>BalanceTuple) balance;
  mapping(address=>WithdrawCountTuple) withdrawCount;
  BeneficiaryTuple beneficiary;
  HighestBidTuple highestBid;
  EndTimeTuple endTime;
  mapping(address=>RepeatWithdrawTuple) repeatWithdraw;
  OwnerTuple owner;
  EndTuple end;
  RepeatWithdrawKeyTuple[] repeatWithdrawKeyArray;
  event Withdraw(address bidder,uint amount);
  event Send(address p,uint amount);
  event Bid(address bidder,uint amount);
  event End(bool b);
  constructor(address beneficiary,uint biddingTime) public {
    updateEndTimeOnInsertConstructor_r12(biddingTime);
    updateOwnerOnInsertConstructor_r8();
    updateBeneficiaryOnInsertConstructor_r9(beneficiary);
  }
  function bid() public  checkViolations payable  {
      bool r7 = updateBidOnInsertRecv_bid_r7();
      if(r7==false) {
        revert("Rule condition failed");
      }
  }
  function withdraw() public  checkViolations  {
      bool r14 = updateWithdrawOnInsertRecv_withdraw_r14();
      bool r3 = updateWithdrawOnInsertRecv_withdraw_r3();
      if(r14==false && r3==false) {
        revert("Rule condition failed");
      }
  }
  function endAuction() public  checkViolations  {
      bool r1 = updateSendOnInsertRecv_endAuction_r1();
      bool r4 = updateEndOnInsertRecv_endAuction_r4();
      if(r1==false && r4==false) {
        revert("Rule condition failed");
      }
  }
  function getBalance(address p) public view  returns (uint) {
      BalanceTuple memory balanceTuple = balance[p];
      uint n = balanceTuple.n;
      return n;
  }
  function checkRepeatWithdraw() private    {
      uint N = repeatWithdrawKeyArray.length;
      for(uint i = 0; i<N; i = i+1) {
          RepeatWithdrawKeyTuple memory repeatWithdrawKeyTuple = repeatWithdrawKeyArray[i];
          RepeatWithdrawTuple memory repeatWithdrawTuple = repeatWithdraw[repeatWithdrawKeyTuple.p];
          if(repeatWithdrawTuple._valid==true) {
            revert("repeatWithdraw");
          }
      }
  }
  modifier checkViolations() {
      // Empty()
      _;
      checkRepeatWithdraw();
  }
  function updateBidOnInsertRecv_bid_r7() private   returns (bool) {
      if(true) {
        uint t1 = block.timestamp;
        if(true) {
          uint t2 = endTime.t;
          if(true) {
            uint m = highestBid.amount;
            if(true) {
              uint n = msg.value;
              if(true) {
                address p = msg.sender;
                if(n>m && t1<t2) {
                  updateHighestBidOnInsertBid_r0(p,n);
                  updateBidTotalOnInsertBid_r10(p,n);
                  emit Bid(p,n);
                  return true;
                }
              }
            }
          }
        }
      }
      return false;
  }
  function updateHighestBidOnInsertBid_r0(address p,uint m) private    {
      HighestBidTuple memory highestBidTuple = highestBid;
      uint _max = highestBid.amount;
      if(m>_max) {
        highestBid = HighestBidTuple(p,m,true);
      }
  }
  function updateSendOnInsertRecv_endAuction_r1() private   returns (bool) {
      if(true) {
        uint t1 = block.timestamp;
        if(true) {
          address s = msg.sender;
          if(true) {
            address p = beneficiary.p;
            if(true) {
              uint t2 = endTime.t;
              if(true) {
                uint n = highestBid.amount;
                if(s==owner.p) {
                  if(t1>=t2) {
                    payable(p).send(n);
                    emit Send(p,n);
                    return true;
                  }
                }
              }
            }
          }
        }
      }
      return false;
  }
  function updateBidTotalOnInsertBid_r10(address p,uint m) private    {
      int delta = int(m);
      updateBalanceOnIncrementBidTotal_r5(p,delta);
  }
  function updateOwnerOnInsertConstructor_r8() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          owner = OwnerTuple(s,true);
        }
      }
  }
  function updateWithdrawTotalOnInsertWithdraw_r2(address p,uint m) private    {
      int delta = int(m);
      updateBalanceOnIncrementWithdrawTotal_r5(p,delta);
  }
  function updateEndTimeOnInsertConstructor_r12(uint d) private    {
      if(true) {
        uint t = block.timestamp;
        if(true) {
          uint t2 = t+d;
          endTime = EndTimeTuple(t2,true);
        }
      }
  }
  function updateRepeatWithdrawOnIncrementWithdrawCount_r11(address p,int c) private    {
      int _delta = int(c);
      uint newValue = updateuintByint(withdrawCount[p].c,_delta);
      updateRepeatWithdrawOnInsertWithdrawCount_r11(p,newValue);
  }
  function updateEndOnInsertRecv_endAuction_r4() private   returns (bool) {
      if(true) {
        uint t1 = block.timestamp;
        if(true) {
          address s = msg.sender;
          if(true) {
            uint t2 = endTime.t;
            if(s==owner.p) {
              if(t1>=t2) {
                end = EndTuple(true,true);
                emit End(true);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
  function updateRepeatWithdrawOnInsertWithdrawCount_r11(address p,uint c) private    {
      WithdrawCountTuple memory toDelete = withdrawCount[p];
      if(toDelete._valid==true) {
        updateRepeatWithdrawOnDeleteWithdrawCount_r11(p,toDelete.c);
      }
      if(c>1) {
        repeatWithdraw[p] = RepeatWithdrawTuple(c,true);
        repeatWithdrawKeyArray.push(RepeatWithdrawKeyTuple(p));
      }
  }
  function updateRepeatWithdrawOnDeleteWithdrawCount_r11(address p,uint c) private    {
      if(c>1) {
        RepeatWithdrawTuple memory repeatWithdrawTuple = repeatWithdraw[p];
        if(c==repeatWithdrawTuple.c) {
          repeatWithdraw[p] = RepeatWithdrawTuple(0,false);
        }
      }
  }
  function updateWithdrawCountOnInsertWithdraw_r13(address p,uint _amount1) private    {
      int delta = int(1);
      updateRepeatWithdrawOnIncrementWithdrawCount_r11(p,delta);
      int _delta = int(1);
      uint newValue = updateuintByint(withdrawCount[p].c,_delta);
      withdrawCount[p].c = newValue;
  }
  function updateSendOnInsertWithdraw_r6(address p,uint n) private    {
      if(true) {
        payable(p).send(n);
        emit Send(p,n);
      }
  }
  function updateBeneficiaryOnInsertConstructor_r9(address p) private    {
      if(true) {
        beneficiary = BeneficiaryTuple(p,true);
      }
  }
  function updateBalanceOnIncrementBidTotal_r5(address p,int b) private    {
      int _delta = int(b);
      uint newValue = updateuintByint(balance[p].n,_delta);
      balance[p].n = newValue;
  }
  function updateBalanceOnIncrementWithdrawTotal_r5(address p,int w) private    {
      int _delta = int(-w);
      uint newValue = updateuintByint(balance[p].n,_delta);
      balance[p].n = newValue;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateWithdrawOnInsertRecv_withdraw_r3() private   returns (bool) {
      if(true==end.b) {
        if(true) {
          address h = highestBid.bidder;
          if(true) {
            address p = msg.sender;
            BalanceTuple memory balanceTuple = balance[p];
            if(true) {
              uint n = balanceTuple.n;
              if(p!=h && n>0) {
                updateWithdrawTotalOnInsertWithdraw_r2(p,n);
                updateWithdrawCountOnInsertWithdraw_r13(p,n);
                updateSendOnInsertWithdraw_r6(p,n);
                emit Withdraw(p,n);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
  function updateWithdrawOnInsertRecv_withdraw_r14() private   returns (bool) {
      if(true) {
        address p = highestBid.bidder;
        uint m = highestBid.amount;
        if(true==end.b) {
          if(p==msg.sender) {
            BalanceTuple memory balanceTuple = balance[p];
            if(true) {
              uint n = balanceTuple.n;
              if(n-m>0) {
                uint s = n-m;
                updateSendOnInsertWithdraw_r6(p,s);
                updateWithdrawCountOnInsertWithdraw_r13(p,s);
                updateWithdrawTotalOnInsertWithdraw_r2(p,s);
                emit Withdraw(p,s);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
}