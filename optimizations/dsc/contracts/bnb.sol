contract Bnb {
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  TotalSupplyTuple totalSupply;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  OwnerTuple owner;
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event Unfreeze(address p,uint n);
  event Freeze(address p,uint n);
  event Transfer(address from,address to,uint amount);
  constructor() public {
    updateTotalBalancesOnInsertConstructor_r27();
    updateTotalSupplyOnInsertConstructor_r2();
    updateOwnerOnInsertConstructor_r20();
  }
  function burn(address p,uint amount) public    {
      bool r5 = updateBurnOnInsertRecv_burn_r5(p,amount);
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public    {
      bool r16 = updateTransferOnInsertRecv_transfer_r16(to,amount);
      if(r16==false) {
        revert("Rule condition failed");
      }
  }
  function freeze(uint n) public    {
      bool r19 = updateFreezeOnInsertRecv_freeze_r19(n);
      if(r19==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function approve(address s,uint n) public    {
      bool r23 = updateIncreaseAllowanceOnInsertRecv_approve_r23(s,n);
      if(r23==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r24 = updateTransferFromOnInsertRecv_transferFrom_r24(from,to,amount);
      if(r24==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public    {
      bool r22 = updateMintOnInsertRecv_mint_r22(p,amount);
      if(r22==false) {
        revert("Rule condition failed");
      }
  }
  function updateTotalSupplyOnIncrementAllMint_r15(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r26(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r21(o,s,delta0);
  }
  function updateAllBurnOnInsertBurn_r25(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r15(delta0);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r24(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint k = allowanceTuple.n;
      BalanceOfTuple memory balanceOfTuple = balanceOf[o];
      uint m = balanceOfTuple.n;
      if(m>=n && k>=n) {
        updateSpentTotalOnInsertTransferFrom_r6(o,s,n);
        updateTransferOnInsertTransferFrom_r1(o,r,n);
        emit TransferFrom(o,r,s,n);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalIn_r3(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBalanceOfOnIncrementTotalMint_r3(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateTotalMintOnInsertMint_r14(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalMint_r3(p,delta0);
  }
  function updateTotalBurnOnInsertBurn_r13(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r3(p,delta0);
  }
  function updateTotalInOnInsertTransfer_r8(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r3(p,delta0);
  }
  function updateAllowanceOnIncrementSpentTotal_r21(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateAllMintOnInsertMint_r9(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllMint_r15(delta0);
  }
  function updateBurnOnInsertRecv_burn_r5(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        BalanceOfTuple memory balanceOfTuple = balanceOf[p];
        uint m = balanceOfTuple.n;
        if(p!=address(0) && n<=m) {
          updateTotalBurnOnInsertBurn_r13(p,n);
          updateAllBurnOnInsertBurn_r25(n);
          emit Burn(p,n);
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalBurn_r3(address p,int m) private    {
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateFreezeOnInsertRecv_freeze_r19(uint n) private   returns (bool) {
      address p = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint m = balanceOfTuple.n;
      if(n<=m && n>0) {
        updateTotalFreezeOnInsertFreeze_r0(p,n);
        emit Freeze(p,n);
        return true;
      }
      return false;
  }
  function updateTotalSupplyOnInsertConstructor_r2() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updateTransferOnInsertTransferFrom_r1(address o,address r,uint n) private    {
      updateTotalOutOnInsertTransfer_r17(o,n);
      updateTotalInOnInsertTransfer_r8(r,n);
      emit Transfer(o,r,n);
  }
  function updateOwnerOnInsertConstructor_r20() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateTotalOutOnInsertTransfer_r17(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r3(p,delta0);
  }
  function updateTransferOnInsertRecv_transfer_r16(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[s];
      uint m = balanceOfTuple.n;
      if(n<=m) {
        updateTotalInOnInsertTransfer_r8(r,n);
        updateTotalOutOnInsertTransfer_r17(s,n);
        emit Transfer(s,r,n);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalOut_r3(address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r23(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      uint d = n-m;
      updateAllowanceTotalOnInsertIncreaseAllowance_r26(o,s,d);
      emit IncreaseAllowance(o,s,d);
      return true;
      return false;
  }
  function updateBalanceOfOnIncrementFreezeOf_r3(address p,int f) private    {
      int _delta = int(-f);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalFreezeOnInsertFreeze_r0(address p,uint n) private    {
      int delta0 = int(n);
      updateFreezeOfOnIncrementTotalFreeze_r11(p,delta0);
  }
  function updateAllowanceOnIncrementAllowanceTotal_r21(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateFreezeOfOnIncrementTotalFreeze_r11(address p,int f) private    {
      int delta0 = int(f);
      updateBalanceOfOnIncrementFreezeOf_r3(p,delta0);
  }
  function updateTotalSupplyOnIncrementAllBurn_r15(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateSpentTotalOnInsertTransferFrom_r6(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r21(o,s,delta0);
  }
  function updateMintOnInsertRecv_mint_r22(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          updateTotalMintOnInsertMint_r14(p,n);
          updateAllMintOnInsertMint_r9(n);
          emit Mint(p,n);
          return true;
        }
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r27() private    {
      // Empty()
  }
}