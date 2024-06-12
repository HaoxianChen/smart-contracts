contract Tether {
  struct OwnerTuple {
    address p;
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
  struct MaxFeeTuple {
    uint m;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  struct RateTuple {
    uint r;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  RateTuple rate;
  TotalSupplyTuple totalSupply;
  mapping(address=>IsBlackListedTuple) isBlackListed;
  MaxFeeTuple maxFee;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  OwnerTuple owner;
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
  function updateTransferFromOnInsertTransferFromWithFee_r18(address o,address r,address s,uint f,uint n) private    {
      uint m = n-f;
      updateSpentTotalOnInsertTransferFrom_r21(o,s,m);
      updateTransferOnInsertTransferFrom_r1(o,r,m);
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r30(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r12(o,s,delta0);
  }
  function updateTransferFromOnInsertTransferFromWithFee_r10(address o,address r,address s,uint f) private    {
      address p = owner.p;
      updateSpentTotalOnInsertTransferFrom_r21(o,s,f);
      updateTransferOnInsertTransferFrom_r1(o,p,f);
  }
  function updateAllIssueOnInsertIssue_r27(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllIssue_r2(delta0);
  }
  function updateTotalOutOnInsertTransfer_r19(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r6(p,delta0);
  }
  function updateTransferOnInsertTransferWithFee_r3(address s,address r,uint f) private    {
      address o = owner.p;
      updateTotalInOnInsertTransfer_r28(o,f);
      updateTotalOutOnInsertTransfer_r19(s,f);
  }
  function updateTotalIssueOnInsertIssue_r23(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIssue_r6(p,delta0);
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
  function updateTotalBalancesOnInsertConstructor_r29(uint n) private    {
      // Empty()
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
  function updateTotalSupplyOnIncrementAllIssue_r2(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateBalanceOfOnIncrementTotalOut_r6(address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBalanceOfOnInsertConstructor_r8(uint n) private    {
      address s = msg.sender;
      balanceOf[s] = BalanceOfTuple(n,true);
  }
  function updateTotalInOnInsertTransfer_r28(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r6(p,delta0);
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
  function updateTotalSupplyOnIncrementAllRedeem_r2(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateTransferOnInsertTransferFrom_r1(address o,address r,uint n) private    {
      updateTotalInOnInsertTransfer_r28(r,n);
      updateTotalOutOnInsertTransfer_r19(o,n);
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
  function updateBalanceOfOnIncrementTotalRedeem_r6(address p,int m) private    {
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateAllowanceOnIncrementAllowanceTotal_r12(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateTransferOnInsertTransferWithFee_r17(address s,address r,uint f,uint n) private    {
      uint m = n-f;
      updateTotalInOnInsertTransfer_r28(r,m);
      updateTotalOutOnInsertTransfer_r19(s,m);
  }
  function updateTotalRedeemOnInsertRedeem_r15(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalRedeem_r6(p,delta0);
  }
  function updateSpentTotalOnInsertTransferFrom_r21(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r12(o,s,delta0);
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
  function updateAllowanceOnIncrementSpentTotal_r12(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateOwnerOnInsertConstructor_r24() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateAllRedeemOnInsertRedeem_r13(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllRedeem_r2(delta0);
  }
  function updateTotalSupplyOnInsertConstructor_r22(uint n) private    {
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateBalanceOfOnIncrementTotalIn_r6(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBalanceOfOnIncrementTotalIssue_r6(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
}