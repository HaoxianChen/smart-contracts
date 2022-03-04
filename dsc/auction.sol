contract Auction {
  struct BalanceTuple {
    address p;
    uint n;
  }
  struct OwnerTuple {
    address p;
  }
  struct BeneficiaryTuple {
    address p;
  }
  struct HighestBidTuple {
    address bidder;
    uint amount;
  }
  struct EndTimeTuple {
    uint t;
  }
  struct EndTuple {
    bool b;
  }
  mapping(address=>BalanceTuple) balance;
  BeneficiaryTuple beneficiary;
  HighestBidTuple highestBid;
  EndTimeTuple endTime;
  OwnerTuple owner;
  EndTuple end;
  event Withdraw(address bidder,uint amount);
  event Send(address p,uint amount);
  event Bid(address bidder,uint amount);
  event End(bool b);
  constructor(address beneficiary,uint biddingTime) public {
    updateEndTimeOnInsertConstructor_r3(biddingTime);
    updateOwnerOnInsertConstructor_r10();
    updateBeneficiaryOnInsertConstructor_r11(beneficiary);
  }
  function bid() public  checkViolations payable  {
      bool r9 = updateBidOnInsertRecv_bid_r9();
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function withdraw() public  checkViolations  {
      bool r4 = updateWithdrawOnInsertRecv_withdraw_r4();
      bool r6 = updateWithdrawOnInsertRecv_withdraw_r6();
      if(r4==false && r6==false) {
        revert("Rule condition failed");
      }
  }
  function endAuction() public  checkViolations  {
      bool r5 = updateEndOnInsertRecv_endAuction_r5();
      bool r1 = updateSendOnInsertRecv_endAuction_r1();
      if(r5==false && r1==false) {
        revert("Rule condition failed");
      }
  }
  function getBalance(address p) public view  returns (uint) {
      BalanceTuple memory balanceTuple = balance[p];
      uint n = balanceTuple.n;
      return n;
  }
  modifier checkViolations() {
      // Empty()
      _;
      // Empty()
  }
  function updateWithdrawTotalOnInsertWithdraw_r2(address p,uint m) private    {
      uint delta = m;
      updateBalanceOnIncrementWithdrawTotal_r7(p,delta);
  }
  function updateWithdrawOnInsertRecv_withdraw_r6() private   returns (bool) {
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
                updateWithdrawTotalOnInsertWithdraw_r2(p,s);
                updateSendOnInsertWithdraw_r8(p,s);
                emit Withdraw(p,s);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
  function updateBidTotalOnInsertBid_r12(address p,uint m) private    {
      uint delta = m;
      updateBalanceOnIncrementBidTotal_r7(p,delta);
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
  function updateHighestBidOnInsertBid_r0(address p,uint m) private    {
      HighestBidTuple memory highestBidTuple = highestBid;
      uint _max = highestBid.amount;
      if(m>_max) {
        highestBid = HighestBidTuple(p,m);
      }
  }
  function updateOwnerOnInsertConstructor_r10() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          owner = OwnerTuple(s);
        }
      }
  }
  function updateBalanceOnIncrementBidTotal_r7(address p,uint b) private    {
      balance[p].n += b;
  }
  function updateEndTimeOnInsertConstructor_r3(uint d) private    {
      if(true) {
        uint t = block.timestamp;
        if(true) {
          uint t2 = t+d;
          endTime = EndTimeTuple(t2);
        }
      }
  }
  function updateBeneficiaryOnInsertConstructor_r11(address p) private    {
      if(true) {
        beneficiary = BeneficiaryTuple(p);
      }
  }
  function updateSendOnInsertWithdraw_r8(address p,uint n) private    {
      if(true) {
        payable(p).send(n);
        emit Send(p,n);
      }
  }
  function updateBidOnInsertRecv_bid_r9() private   returns (bool) {
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
                  updateBidTotalOnInsertBid_r12(p,n);
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
  function updateBalanceOnIncrementWithdrawTotal_r7(address p,uint w) private    {
      balance[p].n -= w;
  }
  function updateWithdrawOnInsertRecv_withdraw_r4() private   returns (bool) {
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
                updateSendOnInsertWithdraw_r8(p,n);
                emit Withdraw(p,n);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
  function updateEndOnInsertRecv_endAuction_r5() private   returns (bool) {
      if(true) {
        uint t1 = block.timestamp;
        if(true) {
          address s = msg.sender;
          if(true) {
            uint t2 = endTime.t;
            if(s==owner.p) {
              if(t1>=t2) {
                end = EndTuple(true);
                emit End(true);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
}