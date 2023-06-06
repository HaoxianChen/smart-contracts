contract Theta {
  struct UnlockTimeTuple {
    uint t;
    bool _valid;
  }
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
  struct PrecirculatedTuple {
    bool b;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  UnlockTimeTuple unlockTime;
  mapping(address=>PrecirculatedTuple) precirculated;
  TotalSupplyTuple totalSupply;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  OwnerTuple owner;
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event Precirculated(address p,bool b);
  event IncreaseAllowance(address p,address s,uint n);
  event Transfer(address from,address to,uint amount);
  constructor(uint t) public {
    updateTotalSupplyOnInsertConstructor_r3();
    updateUnlockTimeOnInsertConstructor_r7(t);
    updateTotalBalancesOnInsertConstructor_r21();
    updateOwnerOnInsertConstructor_r2();
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function approve(address s,uint n) public    {
      bool r24 = updateIncreaseAllowanceOnInsertRecv_approve_r24(s,n);
      if(r24==false) {
        revert("Rule condition failed");
      }
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r25 = updateTransferFromOnInsertRecv_transferFrom_r25(from,to,amount);
      if(r25==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public    {
      bool r23 = updateMintOnInsertRecv_mint_r23(p,amount);
      if(r23==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function transfer(address to,uint amount) public    {
      bool r17 = updateTransferOnInsertRecv_transfer_r17(to,amount);
      if(r17==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function burn(address p,uint amount) public    {
      bool r8 = updateBurnOnInsertRecv_burn_r8(p,amount);
      if(r8==false) {
        revert("Rule condition failed");
      }
  }
  function updateSpentTotalOnInsertTransferFrom_r10(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r22(o,s,delta0);
  }
  function updateUnlockTimeOnInsertConstructor_r7(uint t) private    {
      unlockTime = UnlockTimeTuple(t,true);
  }
  function updateBurnOnInsertRecv_burn_r8(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        BalanceOfTuple memory balanceOfTuple = balanceOf[p];
        uint m = balanceOfTuple.n;
        if(p!=address(0) && n<=m) {
          updateTotalBurnOnInsertBurn_r14(p,n);
          updateAllBurnOnInsertBurn_r26(n);
          emit Burn(p,n);
          return true;
        }
      }
      return false;
  }
  function updateAllMintOnInsertMint_r4(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllMint_r16(delta0);
  }
  function updateBalanceOfOnIncrementTotalIn_r9(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalBurnOnInsertBurn_r14(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r9(p,delta0);
  }
  function updateMintOnInsertRecv_mint_r23(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          updateTotalMintOnInsertMint_r15(p,n);
          updateAllMintOnInsertMint_r4(n);
          emit Mint(p,n);
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalBurn_r9(address p,int m) private    {
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r12(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r22(o,s,delta0);
  }
  function updateTotalSupplyOnInsertConstructor_r3() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updateBalanceOfOnIncrementTotalMint_r9(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateAllowanceOnIncrementSpentTotal_r22(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateTotalInOnInsertTransfer_r11(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r9(p,delta0);
  }
  function updateOwnerOnInsertConstructor_r2() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateTransferOnInsertTransferFrom_r0(address o,address r,uint n) private    {
      updateTotalOutOnInsertTransfer_r18(o,n);
      updateTotalInOnInsertTransfer_r11(r,n);
      emit Transfer(o,r,n);
  }
  function updateTotalSupplyOnIncrementAllBurn_r16(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateTotalBalancesOnInsertConstructor_r21() private    {
      // Empty()
  }
  function updateTotalMintOnInsertMint_r15(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalMint_r9(p,delta0);
  }
  function canTransfer(address p,address q) private view  returns (bool) {
      uint ut = unlockTime.t;
      uint t = block.timestamp;
      if(t>=ut) {
        return true;
      }
      PrecirculatedTuple memory precirculatedTuple = precirculated[q];
      if(true==precirculatedTuple.b) {
        PrecirculatedTuple memory precirculatedTuple = precirculated[p];
        if(true==precirculatedTuple.b) {
          return true;
        }
      }
      return false;
  }
  function updateTransferOnInsertRecv_transfer_r17(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[s];
      uint m = balanceOfTuple.n;
      if(n<=m) {
        updateTotalInOnInsertTransfer_r11(r,n);
        updateTotalOutOnInsertTransfer_r18(s,n);
        emit Transfer(s,r,n);
        return true;
      }
      return false;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r24(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      uint d = n-m;
      updateAllowanceTotalOnInsertIncreaseAllowance_r12(o,s,d);
      emit IncreaseAllowance(o,s,d);
      return true;
      return false;
  }
  function updateTotalOutOnInsertTransfer_r18(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r9(p,delta0);
  }
  function updateAllowanceOnIncrementAllowanceTotal_r22(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateBalanceOfOnIncrementTotalOut_r9(address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalSupplyOnIncrementAllMint_r16(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateAllBurnOnInsertBurn_r26(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r16(delta0);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r25(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint k = allowanceTuple.n;
      BalanceOfTuple memory balanceOfTuple = balanceOf[o];
      uint m = balanceOfTuple.n;
      if(m>=n && k>=n) {
        updateTransferOnInsertTransferFrom_r0(o,r,n);
        updateSpentTotalOnInsertTransferFrom_r10(o,s,n);
        emit TransferFrom(o,r,s,n);
        return true;
      }
      return false;
  }
}