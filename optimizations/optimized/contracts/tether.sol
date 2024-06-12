contract Tether {
  struct OwnerTuple {
    address p;
  }
  struct TotalSupplyTuple {
    uint n;
  }
  struct IsBlackListedTuple {
    bool b;
  }
  struct MaxFeeTuple {
    uint m;
  }
  struct BalanceOfTuple {
    uint n;
  }
  struct RateTuple {
    uint r;
  }
  struct AllowanceTuple {
    uint n;
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
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateRedeemOnInsertRecv_redeem_r25(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        // BalanceOfTuple memory balanceOfTuple = balanceOf[p];
        // uint m = balanceOfTuple.n;
        uint m = balanceOf[p].n;
        if(p!=address(0) && n<=m) {
          emit Redeem(p,n);
          totalSupply.n -= n;
          balanceOf[p].n -= n;
          return true;
        }
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r29(uint n) private    {
      // Empty()
  }
  function updateIssueOnInsertRecv_issue_r11(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          emit Issue(p,n);
          balanceOf[p].n += n;
          totalSupply.n += n;
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnInsertConstructor_r8(uint n) private    {
      address s = msg.sender;
      balanceOf[s] = BalanceOfTuple(n);
  }
  function updateTotalSupplyOnInsertConstructor_r22(uint n) private    {
      totalSupply = TotalSupplyTuple(n);
  }
  function updateTransferFromWithFeeOnInsertRecv_transferFrom_r0(address o,address r,uint n) private   returns (bool) {
      uint rt = rate.r;
      uint mf = maxFee.m;
      address s = msg.sender;
      // BalanceOfTuple memory balanceOfTuple = balanceOf[o];
      // uint m = balanceOfTuple.n;
      uint m = balanceOf[o].n;
      IsBlackListedTuple memory isBlackListedTuple = isBlackListed[o];
      if(false==isBlackListedTuple.b) {
        // AllowanceTuple memory allowanceTuple = allowance[o][s];
        // uint k = allowanceTuple.n;
        uint k = allowance[o][s].n;
        if(m>=n && k>=n) {
          uint f = (rt*n)/10000 < mf ? (rt*n)/10000 : mf;
          emit TransferFromWithFee(o,r,s,f,n);
          address p = owner.p;
          balanceOf[o].n -= f;
          balanceOf[p].n += f;
          allowance[o][s].n -= f;
          uint m = n-f;
          balanceOf[o].n -= m;
          balanceOf[r].n += m;
          allowance[o][s].n -= m;
          
          return true;
        }
      }
      return false;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r26(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      // AllowanceTuple memory allowanceTuple = allowance[o][s];
      // uint m = allowanceTuple.n;
      uint m = allowance[o][s].n;
      uint d = n-m;
      emit IncreaseAllowance(o,s,d);
      allowance[o][s].n += d;
      return true;
      return false;
  }
  function updateOwnerOnInsertConstructor_r24() private    {
      address s = msg.sender;
      owner = OwnerTuple(s);
  }
  function updateTransferWithFeeOnInsertRecv_transfer_r7(address r,uint n) private   returns (bool) {
      uint rt = rate.r;
      uint mf = maxFee.m;
      address s = msg.sender;
      // BalanceOfTuple memory balanceOfTuple = balanceOf[s];
      // uint m = balanceOfTuple.n;
      uint m = balanceOf[s].n;
      // IsBlackListedTuple memory isBlackListedTuple = isBlackListed[s];
      if(false==isBlackListed[s].b) {
        if(n<=m) {
          uint f = (rt*n)/10000 < mf ? (rt*n)/10000 : mf;
          emit TransferWithFee(s,r,f,n);
          address o = owner.p;
          balanceOf[s].n -= f;
          balanceOf[o].n += f;
          uint m = n-f;
          balanceOf[s].n -= m;
          balanceOf[r].n += m;
          return true;
        }
      }
      return false;
  }
}
