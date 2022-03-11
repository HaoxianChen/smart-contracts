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
    updateTotalBalanceOnInsertConstructor_r12();
    updateRaisedOnInsertConstructor_r8();
    updateOwnerOnInsertConstructor_r9();
    updateTargetOnInsertConstructor_r2(t);
    updateBeneficiaryOnInsertConstructor_r16(b);
  }
  function getRaised() public view  returns (uint) {
      uint n = raised.n;
      return n;
  }
  function getClosed() public view  returns (bool) {
      bool b = closed.b;
      return b;
  }
  function invest() public  payable  {
      bool r6 = updateInvestOnInsertRecv_invest_r6();
      if(r6==false) {
        revert("Rule condition failed");
      }
  }
  function close() public    {
      bool r11 = updateClosedOnInsertRecv_close_r11();
      if(r11==false) {
        revert("Rule condition failed");
      }
  }
  function refund() public    {
      bool r5 = updateRefundOnInsertRecv_refund_r5();
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function withdraw() public    {
      bool r10 = updateWithdrawOnInsertRecv_withdraw_r10();
      if(r10==false) {
        revert("Rule condition failed");
      }
  }
  function updateBalanceOfOnIncrementInvestTotal_r4(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateRefundTotalOnInsertRefund_r14(address p,uint m) private    {
      int delta = int(m);
      updateBalanceOfOnIncrementRefundTotal_r4(p,delta);
  }
  function updateBalanceOfOnIncrementRefundTotal_r4(address p,int r) private    {
      int _delta = int(-r);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateTargetOnInsertConstructor_r2(uint t) private    {
      if(true) {
        target = TargetTuple(t,true);
      }
  }
  function updateRaisedOnInsertInvest_r13(uint m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(raised.n,_delta);
      raised.n = newValue;
  }
  function updateRefundOnInsertRecv_refund_r5() private   returns (bool) {
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
                  updateRefundTotalOnInsertRefund_r14(p,n);
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
  function updateClosedOnInsertRecv_close_r11() private   returns (bool) {
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
  function updateInvestOnInsertRecv_invest_r6() private   returns (bool) {
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
                  updateInvestTotalOnInsertInvest_r7(p,n);
                  updateRaisedOnInsertInvest_r13(n);
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
  function updateInvestTotalOnInsertInvest_r7(address p,uint m) private    {
      int delta = int(m);
      updateBalanceOfOnIncrementInvestTotal_r4(p,delta);
  }
  function updateBeneficiaryOnInsertConstructor_r16(address p) private    {
      if(true) {
        beneficiary = BeneficiaryTuple(p,true);
      }
  }
  function updateOwnerOnInsertConstructor_r9() private    {
      if(true) {
        address p = msg.sender;
        if(true) {
          owner = OwnerTuple(p,true);
        }
      }
  }
  function updateWithdrawOnInsertRecv_withdraw_r10() private   returns (bool) {
      if(true) {
        address p = beneficiary.p;
        if(true) {
          uint t = target.t;
          if(true) {
            uint r = raised.n;
            if(p==msg.sender) {
              if(r>=t) {
                emit Withdraw(p,r);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
  function updateRaisedOnInsertConstructor_r8() private    {
      if(true) {
        raised = RaisedTuple(0,true);
      }
  }
  function updateTotalBalanceOnInsertConstructor_r12() private    {
      if(true) {
        // Empty()
      }
  }
}