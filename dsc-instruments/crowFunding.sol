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
  struct TotalBalanceTuple {
    uint m;
    bool _valid;
  }
  struct BeneficiaryTuple {
    address p;
    bool _valid;
  }
  struct MissingFundTuple {
    uint m;
    uint r;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  TargetTuple target;
  RaisedTuple raised;
  ClosedTuple closed;
  TotalBalanceTuple totalBalance;
  mapping(address=>BalanceOfTuple) balanceOf;
  OwnerTuple owner;
  BeneficiaryTuple beneficiary;
  MissingFundTuple missingFund;
  event Refund(address p,uint n);
  event Invest(address p,uint n);
  event Closed(bool b);
  event Withdraw(address p,uint n);
  constructor(uint t,address b) public {
    updateBeneficiaryOnInsertConstructor_r14(b);
    updateOwnerOnInsertConstructor_r8();
    updateTargetOnInsertConstructor_r2(t);
  }
  function getRaised() public view  returns (uint) {
      uint n = raised.n;
      return n;
  }
  function getClosed() public view  returns (bool) {
      bool b = closed.b;
      return b;
  }
  function refund() public  checkViolations  {
      bool r5 = updateRefundOnInsertRecv_refund_r5();
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function close() public  checkViolations  {
      bool r10 = updateClosedOnInsertRecv_close_r10();
      if(r10==false) {
        revert("Rule condition failed");
      }
  }
  function withdraw() public  checkViolations  {
      bool r9 = updateWithdrawOnInsertRecv_withdraw_r9();
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function invest() public  checkViolations payable  {
      bool r6 = updateInvestOnInsertRecv_invest_r6();
      if(r6==false) {
        revert("Rule condition failed");
      }
  }
  function checkMissingFund() private    {
      MissingFundTuple memory missingFundTuple = missingFund;
      if(missingFundTuple._valid==true) {
        revert("missingFund");
      }
  }
  modifier checkViolations() {
      // Empty()
      _;
      checkMissingFund();
  }
  function updateInvestTotalOnInsertInvest_r7(address p,uint m) private    {
      int delta = int(m);
      updateBalanceOfOnIncrementInvestTotal_r4(p,delta);
  }
  function updateOwnerOnInsertConstructor_r8() private    {
      if(true) {
        address p = msg.sender;
        if(true) {
          owner = OwnerTuple(p,true);
        }
      }
  }
  function updateMissingFundOnIncrementRaised_r3(int r) private    {
      int _delta = int(r);
      uint newValue = updateuintByint(raised.n,_delta);
      updateMissingFundOnInsertRaised_r3(newValue);
  }
  function updateBalanceOfOnIncrementInvestTotal_r4(address p,int i) private    {
      int delta = int(i);
      updateTotalBalanceOnIncrementBalanceOf_r13(delta);
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateMissingFundOnDeleteTotalBalance_r3(uint m) private    {
      if(true) {
        bool b = closed.b;
        if(true) {
          uint r = raised.n;
          if(m!=r && b==false) {
            missingFund = MissingFundTuple(0,0,false);
          }
        }
      }
  }
  function updateTotalBalanceOnIncrementBalanceOf_r13(int n) private    {
      int delta = int(n);
      updateMissingFundOnIncrementTotalBalance_r3(delta);
      int _delta = int(n);
      uint newValue = updateuintByint(totalBalance.m,_delta);
      totalBalance.m = newValue;
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
                  updateRefundTotalOnInsertRefund_r12(p,n);
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
  function updateMissingFundOnInsertTotalBalance_r3(uint m) private    {
      TotalBalanceTuple memory toDelete = totalBalance;
      if(toDelete._valid==true) {
        updateMissingFundOnDeleteTotalBalance_r3(toDelete.m);
      }
      if(true) {
        bool b = closed.b;
        if(true) {
          uint r = raised.n;
          if(m!=r && b==false) {
            missingFund = MissingFundTuple(m,r,true);
          }
        }
      }
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
  function updateMissingFundOnIncrementTotalBalance_r3(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalBalance.m,_delta);
      updateMissingFundOnInsertTotalBalance_r3(newValue);
  }
  function updateBeneficiaryOnInsertConstructor_r14(address p) private    {
      if(true) {
        beneficiary = BeneficiaryTuple(p,true);
      }
  }
  function updateMissingFundOnDeleteClosed_r3(bool b) private    {
      if(true) {
        uint r = raised.n;
        if(true) {
          uint m = totalBalance.m;
          if(m!=r && b==false) {
            missingFund = MissingFundTuple(0,0,false);
          }
        }
      }
  }
  function updateClosedOnInsertRecv_close_r10() private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(true) {
            updateMissingFundOnInsertClosed_r3(bool(true));
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
                  updateRaisedOnInsertInvest_r11(n);
                  updateInvestTotalOnInsertInvest_r7(p,n);
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
  function updateRefundTotalOnInsertRefund_r12(address p,uint m) private    {
      int delta = int(m);
      updateBalanceOfOnIncrementRefundTotal_r4(p,delta);
  }
  function updateBalanceOfOnIncrementRefundTotal_r4(address p,int r) private    {
      int delta = int(-r);
      updateTotalBalanceOnIncrementBalanceOf_r13(delta);
      int _delta = int(-r);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateMissingFundOnInsertRaised_r3(uint r) private    {
      RaisedTuple memory toDelete = raised;
      if(toDelete._valid==true) {
        updateMissingFundOnDeleteRaised_r3(toDelete.n);
      }
      if(true) {
        bool b = closed.b;
        if(true) {
          uint m = totalBalance.m;
          if(m!=r && b==false) {
            missingFund = MissingFundTuple(m,r,true);
          }
        }
      }
  }
  function updateMissingFundOnDeleteRaised_r3(uint r) private    {
      if(true) {
        bool b = closed.b;
        if(true) {
          uint m = totalBalance.m;
          if(m!=r && b==false) {
            missingFund = MissingFundTuple(0,0,false);
          }
        }
      }
  }
  function updateMissingFundOnInsertClosed_r3(bool b) private    {
      ClosedTuple memory toDelete = closed;
      if(toDelete._valid==true) {
        updateMissingFundOnDeleteClosed_r3(toDelete.b);
      }
      if(true) {
        uint r = raised.n;
        if(true) {
          uint m = totalBalance.m;
          if(m!=r && b==false) {
            missingFund = MissingFundTuple(m,r,true);
          }
        }
      }
  }
  function updateRaisedOnInsertInvest_r11(uint m) private    {
      int delta = int(m);
      updateMissingFundOnIncrementRaised_r3(delta);
      int _delta = int(m);
      uint newValue = updateuintByint(raised.n,_delta);
      raised.n = newValue;
  }
  function updateWithdrawOnInsertRecv_withdraw_r9() private   returns (bool) {
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
}