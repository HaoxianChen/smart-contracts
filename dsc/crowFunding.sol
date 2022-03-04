contract CrowFunding {
  struct TargetTuple {
    uint t;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct RaisedTuple {
    uint n;
    bool _valid;
  }
  struct ClosedTuple {
    bool b;
    bool _valid;
  }
  struct BeneficiaryTuple {
    address p;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  TargetTuple target;
  RaisedTuple raised;
  ClosedTuple closed;
  BeneficiaryTuple beneficiary;
  mapping(address=>BalanceOfTuple) balanceOf;
  OwnerTuple owner;
  event Refund(address p,uint n);
  event Invest(address p,uint n);
  event Closed(bool b);
  event Withdraw(address p,uint n);
  constructor(uint t,address b) public {
    updateBeneficiaryOnInsertConstructor_r12(b);
    updateOwnerOnInsertConstructor_r7();
    updateTargetOnInsertConstructor_r2(t);
  }
  function refund() public  checkViolations  {
      bool r4 = updateRefundOnInsertRecv_refund_r4();
      if(r4==false) {
        revert("Rule condition failed");
      }
  }
  function getRaised() public view  returns (uint) {
      uint n = raised.n;
      return n;
  }
  function withdraw() public  checkViolations  {
      bool r8 = updateWithdrawOnInsertRecv_withdraw_r8();
      if(r8==false) {
        revert("Rule condition failed");
      }
  }
  function close() public  checkViolations  {
      bool r9 = updateClosedOnInsertRecv_close_r9();
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function getClosed() public view  returns (bool) {
      bool b = closed.b;
      return b;
  }
  function invest() public  checkViolations payable  {
      bool r5 = updateInvestOnInsertRecv_invest_r5();
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  modifier checkViolations() {
      // Empty()
      _;
      // Empty()
  }
  function updateBalanceOfOnIncrementRefundTotal_r3(address p,uint r) private    {
      balanceOf[p].n -= r;
  }
  function updateSendOnInsertRefund_r1(address p,uint n) private    {
      if(true) {
        payable(p).send(n);
      }
  }
  function updateTargetOnInsertConstructor_r2(uint t) private    {
      if(true) {
        target = TargetTuple(t,true);
      }
  }
  function updateOwnerOnInsertConstructor_r7() private    {
      if(true) {
        address p = msg.sender;
        if(true) {
          owner = OwnerTuple(p,true);
        }
      }
  }
  function updateInvestTotalOnInsertInvest_r6(address p,uint m) private    {
      uint delta = m;
      updateBalanceOfOnIncrementInvestTotal_r3(p,delta);
  }
  function updateSendOnInsertWithdraw_r0(address p,uint r) private    {
      if(true) {
        payable(p).send(r);
      }
  }
  function updateWithdrawOnInsertRecv_withdraw_r8() private   returns (bool) {
      if(true) {
        address p = beneficiary.p;
        if(true) {
          uint t = target.t;
          if(true) {
            uint r = raised.n;
            if(p==msg.sender) {
              if(r>=t) {
                updateSendOnInsertWithdraw_r0(p,r);
                emit Withdraw(p,r);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
  function updateRaisedOnInsertInvest_r10(uint m) private    {
      raised.n += m;
  }
  function updateBeneficiaryOnInsertConstructor_r12(address p) private    {
      if(true) {
        beneficiary = BeneficiaryTuple(p,true);
      }
  }
  function updateClosedOnInsertRecv_close_r9() private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(true) {
            closed = ClosedTuple(true,true);
            emit Closed(true);
            return true;
          }
        }
      }
      return false;
  }
  function updateRefundOnInsertRecv_refund_r4() private   returns (bool) {
      if(true==closed.b) {
        if(true) {
          address p = msg.sender;
          if(true) {
            uint t = target.t;
            if(true) {
              uint r = raised.n;
              BalanceOfTuple memory balanceOfTuple = balanceOf[p];
              if(true) {
                uint n = balanceOfTuple.n;
                if(r<t && n>0) {
                  updateRefundTotalOnInsertRefund_r11(p,n);
                  updateSendOnInsertRefund_r1(p,n);
                  emit Refund(p,n);
                  return true;
                }
              }
            }
          }
        }
      }
      return false;
  }
  function updateRefundTotalOnInsertRefund_r11(address p,uint m) private    {
      uint delta = m;
      updateBalanceOfOnIncrementRefundTotal_r3(p,delta);
  }
  function updateBalanceOfOnIncrementInvestTotal_r3(address p,uint i) private    {
      balanceOf[p].n += i;
  }
  function updateInvestOnInsertRecv_invest_r5() private   returns (bool) {
      if(false==closed.b) {
        if(true) {
          uint s = raised.n;
          if(true) {
            uint t = target.t;
            if(true) {
              uint n = msg.value;
              if(true) {
                address p = msg.sender;
                if(s<t) {
                  updateInvestTotalOnInsertInvest_r6(p,n);
                  updateRaisedOnInsertInvest_r10(n);
                  emit Invest(p,n);
                  return true;
                }
              }
            }
          }
        }
      }
      return false;
  }
}