contract Tether {
  struct TotalOutTuple {
    uint n;
    bool _valid;
  }
  struct TotalIssueTuple {
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct AllIssueTuple {
    uint n;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct IsBlackListedTuple {
    bool b;
    bool _valid;
  }
  struct AllowanceTotalTuple {
    uint m;
    bool _valid;
  }
  struct MaxFeeTuple {
    uint m;
    bool _valid;
  }
  struct AllRedeemTuple {
    uint n;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  struct TotalInTuple {
    uint n;
    bool _valid;
  }
  struct RateTuple {
    uint r;
    bool _valid;
  }
  struct TotalRedeemTuple {
    uint n;
    bool _valid;
  }
  struct SpentTotalTuple {
    uint m;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  mapping(address=>TotalInTuple) totalIn;
  mapping(address=>TotalOutTuple) totalOut;
  mapping(address=>TotalIssueTuple) totalIssue;
  OwnerTuple owner;
  AllIssueTuple allIssue;
  RateTuple rate;
  TotalSupplyTuple totalSupply;
  mapping(address=>IsBlackListedTuple) isBlackListed;
  mapping(address=>mapping(address=>AllowanceTotalTuple)) allowanceTotal;
  MaxFeeTuple maxFee;
  AllRedeemTuple allRedeem;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  mapping(address=>TotalRedeemTuple) totalRedeem;
  mapping(address=>mapping(address=>SpentTotalTuple)) spentTotal;
  event Issue(address p,uint amount);
  event AddBlackList(address p);
  event TransferFromWithFee(address from,address to,address spender,uint fee,uint amount);
  event Redeem(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event TransferWithFee(address from,address to,uint fee,uint amount);
  event DestroyBlackFund(address p,uint n);
  constructor(uint n) public {
    updateOwnerOnInsertConstructor_r24();
    updateBalanceOfOnInsertConstructor_r8(n);
    updateTotalSupplyOnInsertConstructor_r22(n);
    updateTotalBalancesOnInsertConstructor_r29(n);
  }
  function transfer(address to,uint amount) public    {
      bool r7 = updateTransferWithFeeOnInsertRecv_transfer_r7(to,amount);
      if(r7==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address s,uint n) public    {
      bool r26 = updateIncreaseAllowanceOnInsertRecv_approve_r26(s,n);
      if(r26==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function issue(address p,uint amount) public    {
      bool r11 = updateIssueOnInsertRecv_issue_r11(p,amount);
      if(r11==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function redeem(address p,uint amount) public    {
      bool r25 = updateRedeemOnInsertRecv_redeem_r25(p,amount);
      if(r25==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r0 = updateTransferFromWithFeeOnInsertRecv_transferFrom_r0(from,to,amount);
      if(r0==false) {
        revert("Rule condition failed");
      }
  }
  function updateAllowanceOnDeleteSpentTotal_r12(address o,address s,uint l) private    {
      AllowanceTotalTuple memory allowanceTotalTuple = allowanceTotal[o][s];
      uint m = allowanceTotalTuple.m;
      uint n = m-l;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      if(n==allowanceTuple.n) {
        allowance[o][s] = AllowanceTuple(0,false);
      }
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r26(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      uint d = n-m;
      updateAllowanceTotalOnInsertIncreaseAllowance_r30(o,s,d);
      emit IncreaseAllowance(o,s,d);
      return true;
      return false;
  }
  function updateTransferOnInsertTransferFrom_r1(address o,address r,uint n) private    {
      updateTotalInOnInsertTransfer_r28(r,n);
      updateTotalOutOnInsertTransfer_r19(o,n);
  }
  function updateTotalBalancesOnInsertConstructor_r29(uint n) private    {
      // Empty()
  }
  function updateTransferOnInsertTransferWithFee_r17(address s,address r,uint f,uint n) private    {
      uint m = n-f;
      updateTotalInOnInsertTransfer_r28(r,m);
      updateTotalOutOnInsertTransfer_r19(s,m);
  }
  function updateTotalInOnInsertTransfer_r28(address p,uint n) private    {
      int delta2 = int(n);
      updateBalanceOfOnIncrementTotalIn_r6(p,delta2);
      totalIn[p].n += n;
  }
  function updateBalanceOfOnDeleteTotalIn_r6(address p,uint i) private    {
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalRedeemTuple memory totalRedeemTuple = totalRedeem[p];
      uint m = totalRedeemTuple.n;
      TotalIssueTuple memory totalIssueTuple = totalIssue[p];
      uint n = totalIssueTuple.n;
      uint s = ((n+i)-m)-o;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      if(s==balanceOfTuple.n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateTotalSupplyOnInsertAllIssue_r2(uint m) private    {
      uint b = allRedeem.n;
      uint n = m-b;
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateBalanceOfOnDeleteTotalOut_r6(address p,uint o) private    {
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      TotalRedeemTuple memory totalRedeemTuple = totalRedeem[p];
      uint m = totalRedeemTuple.n;
      TotalIssueTuple memory totalIssueTuple = totalIssue[p];
      uint n = totalIssueTuple.n;
      uint s = ((n+i)-m)-o;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      if(s==balanceOfTuple.n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateBalanceOfOnIncrementTotalIssue_r6(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(totalIssue[p].n,_delta);
      updateBalanceOfOnInsertTotalIssue_r6(p,newValue);
  }
  function updateTransferFromOnInsertTransferFromWithFee_r18(address o,address r,address s,uint f,uint n) private    {
      uint m = n-f;
      updateSpentTotalOnInsertTransferFrom_r21(o,s,m);
      updateTransferOnInsertTransferFrom_r1(o,r,m);
  }
  function updateBalanceOfOnInsertTotalRedeem_r6(address p,uint m) private    {
      TotalRedeemTuple memory toDelete = totalRedeem[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalRedeem_r6(p,toDelete.n);
      }
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalIssueTuple memory totalIssueTuple = totalIssue[p];
      uint n = totalIssueTuple.n;
      uint s = ((n+i)-m)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateBalanceOfOnDeleteTotalIssue_r6(address p,uint n) private    {
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalRedeemTuple memory totalRedeemTuple = totalRedeem[p];
      uint m = totalRedeemTuple.n;
      uint s = ((n+i)-m)-o;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      if(s==balanceOfTuple.n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateBalanceOfOnIncrementTotalIn_r6(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(totalIn[p].n,_delta);
      updateBalanceOfOnInsertTotalIn_r6(p,newValue);
  }
  function updateAllowanceOnInsertSpentTotal_r12(address o,address s,uint l) private    {
      SpentTotalTuple memory toDelete = spentTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteSpentTotal_r12(o,s,toDelete.m);
      }
      AllowanceTotalTuple memory allowanceTotalTuple = allowanceTotal[o][s];
      uint m = allowanceTotalTuple.m;
      uint n = m-l;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateTransferFromOnInsertTransferFromWithFee_r10(address o,address r,address s,uint f) private    {
      address p = owner.p;
      updateSpentTotalOnInsertTransferFrom_r21(o,s,f);
      updateTransferOnInsertTransferFrom_r1(o,p,f);
  }
  function updateAllowanceOnIncrementAllowanceTotal_r12(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowanceTotal[o][s].m,_delta);
      updateAllowanceOnInsertAllowanceTotal_r12(o,s,newValue);
  }
  function updateTransferOnInsertTransferWithFee_r3(address s,address r,uint f) private    {
      address o = owner.p;
      updateTotalInOnInsertTransfer_r28(o,f);
      updateTotalOutOnInsertTransfer_r19(s,f);
  }
  function updateBalanceOfOnInsertTotalIssue_r6(address p,uint n) private    {
      TotalIssueTuple memory toDelete = totalIssue[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalIssue_r6(p,toDelete.n);
      }
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalRedeemTuple memory totalRedeemTuple = totalRedeem[p];
      uint m = totalRedeemTuple.n;
      uint s = ((n+i)-m)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateTotalRedeemOnInsertRedeem_r15(address p,uint n) private    {
      int delta1 = int(n);
      updateBalanceOfOnIncrementTotalRedeem_r6(p,delta1);
      totalRedeem[p].n += n;
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r30(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r12(o,s,delta0);
      allowanceTotal[o][s].m += n;
  }
  function updateBalanceOfOnDeleteTotalRedeem_r6(address p,uint m) private    {
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalIssueTuple memory totalIssueTuple = totalIssue[p];
      uint n = totalIssueTuple.n;
      uint s = ((n+i)-m)-o;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      if(s==balanceOfTuple.n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateIssueOnInsertRecv_issue_r11(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          updateTotalIssueOnInsertIssue_r23(p,n);
          updateAllIssueOnInsertIssue_r27(n);
          emit Issue(p,n);
          return true;
        }
      }
      return false;
  }
  function updateSpentTotalOnInsertTransferFrom_r21(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r12(o,s,delta0);
      spentTotal[o][s].m += n;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateTransferWithFeeOnInsertRecv_transfer_r7(address r,uint n) private   returns (bool) {
      uint rt = rate.r;
      uint mf = maxFee.m;
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[s];
      uint m = balanceOfTuple.n;
      IsBlackListedTuple memory isBlackListedTuple = isBlackListed[s];
      if(false==isBlackListedTuple.b) {
        if(n<=m) {
          uint f = (rt*n)/10000 < mf ? (rt*n)/10000 : mf;
          updateTransferOnInsertTransferWithFee_r3(s,r,f);
          updateTransferOnInsertTransferWithFee_r17(s,r,f,n);
          emit TransferWithFee(s,r,f,n);
          return true;
        }
      }
      return false;
  }
  function updateAllowanceOnDeleteAllowanceTotal_r12(address o,address s,uint m) private    {
      SpentTotalTuple memory spentTotalTuple = spentTotal[o][s];
      uint l = spentTotalTuple.m;
      uint n = m-l;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      if(n==allowanceTuple.n) {
        allowance[o][s] = AllowanceTuple(0,false);
      }
  }
  function updateBalanceOfOnIncrementTotalRedeem_r6(address p,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalRedeem[p].n,_delta);
      updateBalanceOfOnInsertTotalRedeem_r6(p,newValue);
  }
  function updateTransferFromWithFeeOnInsertRecv_transferFrom_r0(address o,address r,uint n) private   returns (bool) {
      uint rt = rate.r;
      uint mf = maxFee.m;
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[o];
      uint m = balanceOfTuple.n;
      IsBlackListedTuple memory isBlackListedTuple = isBlackListed[o];
      if(false==isBlackListedTuple.b) {
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        uint k = allowanceTuple.n;
        if(m>=n && k>=n) {
          uint f = (rt*n)/10000 < mf ? (rt*n)/10000 : mf;
          updateTransferFromOnInsertTransferFromWithFee_r10(o,r,s,f);
          updateTransferFromOnInsertTransferFromWithFee_r18(o,r,s,f,n);
          emit TransferFromWithFee(o,r,s,f,n);
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalOut_r6(address p,int o) private    {
      int _delta = int(o);
      uint newValue = updateuintByint(totalOut[p].n,_delta);
      updateBalanceOfOnInsertTotalOut_r6(p,newValue);
  }
  function updateRedeemOnInsertRecv_redeem_r25(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        BalanceOfTuple memory balanceOfTuple = balanceOf[p];
        uint m = balanceOfTuple.n;
        if(p!=address(0) && n<=m) {
          updateTotalRedeemOnInsertRedeem_r15(p,n);
          updateAllRedeemOnInsertRedeem_r13(n);
          emit Redeem(p,n);
          return true;
        }
      }
      return false;
  }
  function updateAllRedeemOnInsertRedeem_r13(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllRedeem_r2(delta0);
      allRedeem.n += n;
  }
  function updateAllowanceOnInsertAllowanceTotal_r12(address o,address s,uint m) private    {
      AllowanceTotalTuple memory toDelete = allowanceTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteAllowanceTotal_r12(o,s,toDelete.m);
      }
      SpentTotalTuple memory spentTotalTuple = spentTotal[o][s];
      uint l = spentTotalTuple.m;
      uint n = m-l;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateTotalOutOnInsertTransfer_r19(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r6(p,delta0);
      totalOut[p].n += n;
  }
  function updateOwnerOnInsertConstructor_r24() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateTotalSupplyOnIncrementAllIssue_r2(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allIssue.n,_delta);
      updateTotalSupplyOnInsertAllIssue_r2(newValue);
  }
  function updateAllowanceOnIncrementSpentTotal_r12(address o,address s,int l) private    {
      int _delta = int(l);
      uint newValue = updateuintByint(spentTotal[o][s].m,_delta);
      updateAllowanceOnInsertSpentTotal_r12(o,s,newValue);
  }
  function updateBalanceOfOnInsertConstructor_r8(uint n) private    {
      address s = msg.sender;
      balanceOf[s] = BalanceOfTuple(n,true);
  }
  function updateTotalSupplyOnIncrementAllRedeem_r2(int b) private    {
      int _delta = int(b);
      uint newValue = updateuintByint(allRedeem.n,_delta);
      updateTotalSupplyOnInsertAllRedeem_r2(newValue);
  }
  function updateAllIssueOnInsertIssue_r27(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllIssue_r2(delta0);
      allIssue.n += n;
  }
  function updateTotalIssueOnInsertIssue_r23(address p,uint n) private    {
      int delta2 = int(n);
      updateBalanceOfOnIncrementTotalIssue_r6(p,delta2);
      totalIssue[p].n += n;
  }
  function updateBalanceOfOnInsertTotalOut_r6(address p,uint o) private    {
      TotalOutTuple memory toDelete = totalOut[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalOut_r6(p,toDelete.n);
      }
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      TotalRedeemTuple memory totalRedeemTuple = totalRedeem[p];
      uint m = totalRedeemTuple.n;
      TotalIssueTuple memory totalIssueTuple = totalIssue[p];
      uint n = totalIssueTuple.n;
      uint s = ((n+i)-m)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateBalanceOfOnInsertTotalIn_r6(address p,uint i) private    {
      TotalInTuple memory toDelete = totalIn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalIn_r6(p,toDelete.n);
      }
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalRedeemTuple memory totalRedeemTuple = totalRedeem[p];
      uint m = totalRedeemTuple.n;
      TotalIssueTuple memory totalIssueTuple = totalIssue[p];
      uint n = totalIssueTuple.n;
      uint s = ((n+i)-m)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateTotalSupplyOnInsertConstructor_r22(uint n) private    {
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateTotalSupplyOnInsertAllRedeem_r2(uint b) private    {
      uint m = allIssue.n;
      uint n = m-b;
      totalSupply = TotalSupplyTuple(n,true);
  }
}