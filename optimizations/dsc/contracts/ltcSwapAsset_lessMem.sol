contract LtcSwapAssetLessMem {
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct NewOwnerTuple {
    address p;
    bool _valid;
  }
  struct OldOwnerTuple {
    address p;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  struct EffectiveTimeTuple {
    uint t;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  EffectiveTimeTuple effectiveTime;
  TotalSupplyTuple totalSupply;
  NewOwnerTuple newOwner;
  OldOwnerTuple oldOwner;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event SwapOwner(address p,address q,uint t);
  event IncreaseAllowance(address p,address s,uint n);
  event Transfer(address from,address to,uint amount);
  constructor() public {
    updateTotalBalancesOnInsertConstructor_r27();
    updateTotalSupplyOnInsertConstructor_r11();
    updateOldOwnerOnInsertConstructor_r8();
    // oldOwner = OldOwnerTuple(oldOwner_mem,true);
  }
  function approve(address s,uint n) public    {
      bool r25 = updateIncreaseAllowanceOnInsertRecv_approve_r25(s,n);
      if(r25==false) {
        revert("Rule condition failed");
      }
  }
  function swapOwner(address p,address q,uint d) public    {
      bool r18 = updateSwapOwnerOnInsertRecv_swapOwner_r18(p,q,d);
      if(r18==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function mint(address p,uint amount) public    {
      bool r21 = updateMintOnInsertRecv_mint_r21(p,amount);
      if(r21==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function burn(address p,uint amount) public    {
      bool r5 = updateBurnOnInsertRecv_burn_r5(p,amount);
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r22 = updateTransferFromOnInsertRecv_transferFrom_r22(from,to,amount);
      if(r22==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function transfer(address to,uint amount) public    {
      bool r15 = updateTransferOnInsertRecv_transfer_r15(to,amount);
      if(r15==false) {
        revert("Rule condition failed");
      }
  }
  function updateSwapOwnerOnInsertRecv_swapOwner_r18(address  p,address q,uint d) private   returns (bool) {
      address s = msg.sender;
      uint t0 = block.timestamp;
      uint t = t0+d;
      updateEffectiveTimeOnInsertSwapOwner_r1(t);
      // updateOldOwnerOnInsertSwapOwner_r10(p);
      // updateNewOwnerOnInsertSwapOwner_r24(q);
      newOwner = NewOwnerTuple(q,true);
      oldOwner = OldOwnerTuple(p,true);
      emit SwapOwner(p,q,t);
      return true;
      return false;
  }
  function updateTotalSupplyOnInsertConstructor_r11() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updateTransferOnInsertRecv_transfer_r15(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[s];
      uint m = balanceOfTuple.n;
      if(n<=m) {
        updateTotalOutOnInsertTransfer_r16(s,n);
        updateTotalInOnInsertTransfer_r9(r,n);
        emit Transfer(s,r,n);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalIn_r19(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateMintOnInsertRecv_mint_r21(address p,uint n) private   returns (bool) {
      address s = msg.sender;
      if(p!=address(0) && owner(s)) {
        updateTotalMintOnInsertMint_r13(p,n);
        updateAllMintOnInsertMint_r2(n);
        emit Mint(p,n);
        return true;
      }
      return false;
  }
  function updateTotalBurnOnInsertBurn_r12(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r19(p,delta0);
  }
  function updateAllowanceOnIncrementSpentTotal_r20(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateTransferOnInsertTransferFrom_r0(address o,address r,uint n) private    {
      updateTotalOutOnInsertTransfer_r16(o,n);
      updateTotalInOnInsertTransfer_r9(r,n);
      emit Transfer(o,r,n);
  }
  function updateNewOwnerOnInsertSwapOwner_r24(address q) private    {
      // newOwner = NewOwnerTuple(q,true); // sload 2100, sstore 20000, sload 100, sstore 100
  }
  function updateTotalBalancesOnInsertConstructor_r27() private    {
      // Empty()
  }
  function updateTotalMintOnInsertMint_r13(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalMint_r19(p,delta0);
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r26(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r20(o,s,delta0);
  }
  function updateAllBurnOnInsertBurn_r23(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r14(delta0);
  }
  function updateTotalSupplyOnIncrementAllMint_r14(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateAllowanceOnIncrementAllowanceTotal_r20(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateAllMintOnInsertMint_r2(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllMint_r14(delta0);
  }
  function updateOldOwnerOnInsertConstructor_r8() private    {
      address s = msg.sender;
      oldOwner = OldOwnerTuple(s,true);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r22(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint k = allowanceTuple.n;
      BalanceOfTuple memory balanceOfTuple = balanceOf[o];
      uint m = balanceOfTuple.n;
      if(m>=n && k>=n) {
        updateTransferOnInsertTransferFrom_r0(o,r,n);
        updateSpentTotalOnInsertTransferFrom_r7(o,s,n);
        emit TransferFrom(o,r,s,n);
        return true;
      }
      return false;
  }
  function updateTotalInOnInsertTransfer_r9(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r19(p,delta0);
  }
  function updateBurnOnInsertRecv_burn_r5(address p,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint m = balanceOfTuple.n;
      if(p!=address(0) && n<=m && owner(s)) {
        updateTotalBurnOnInsertBurn_r12(p,n);
        updateAllBurnOnInsertBurn_r23(n);
        emit Burn(p,n);
        return true;
      }
      return false;
  }
  function updateEffectiveTimeOnInsertSwapOwner_r1(uint t) private    {
      effectiveTime = EffectiveTimeTuple(t,true); // sstore 22100, sload 2100 sstore 20000, 
  }
  function owner(address p) private view  returns (bool) {
      if(p==newOwner.p) {
        uint t2 = effectiveTime.t;
        uint t = block.timestamp;
        if(t>=t2) {
          return true;
        }
      }
      if(p==oldOwner.p) {
        uint t2 = effectiveTime.t;
        uint t = block.timestamp;
        if(t<t2) {
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalMint_r19(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalOutOnInsertTransfer_r16(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r19(p,delta0);
  }
  function updateSpentTotalOnInsertTransferFrom_r7(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r20(o,s,delta0);
  }
  function updateOldOwnerOnInsertSwapOwner_r10(address p) private    {
      oldOwner = OldOwnerTuple(p,true); // sload 2100, sstore 100, sload 100, sstore 100
  }
  function updateTotalSupplyOnIncrementAllBurn_r14(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r25(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      uint d = n-m;
      updateAllowanceTotalOnInsertIncreaseAllowance_r26(o,s,d);
      emit IncreaseAllowance(o,s,d);
      return true;
      return false;
  }
  function updateBalanceOfOnIncrementTotalOut_r19(address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBalanceOfOnIncrementTotalBurn_r19(address p,int m) private    {
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
}