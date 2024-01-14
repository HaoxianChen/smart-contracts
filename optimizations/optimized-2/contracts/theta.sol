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
    updateOwnerOnInsertConstructor_r2();
    updateTotalBalancesOnInsertConstructor_r20();
  }
  function transfer(address to,uint amount) public    {
      bool r25 = updateTransferOnInsertRecv_transfer_r25(to,amount);
      if(r25==false) {
        revert("Rule condition failed");
      }
  }
  function disallowPrecirculation(address p) public    {
      bool r26 = updatePrecirculatedOnInsertRecv_disallowPrecirculation_r26(p);
      if(r26==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address s,uint n) public    {
      bool r24 = updateIncreaseAllowanceOnInsertRecv_approve_r24(s,n);
      if(r24==false) {
        revert("Rule condition failed");
      }
  }
  function allowPrecirculation(address p) public    {
      bool r19 = updatePrecirculatedOnInsertRecv_allowPrecirculation_r19(p);
      if(r19==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r10 = updateTransferFromOnInsertRecv_transferFrom_r10(from,to,amount);
      if(r10==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      uint n = allowance[p][s].n;
      return n;
  }
  function getBalanceOf(address p) public view  returns (uint) {
      uint n = balanceOf[p].n;
      return n;
  }
  function burn(address p,uint amount) public    {
      bool r8 = updateBurnOnInsertRecv_burn_r8(p,amount);
      if(r8==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public    {
      bool r22 = updateMintOnInsertRecv_mint_r22(p,amount);
      if(r22==false) {
        revert("Rule condition failed");
      }
  }
  function updateUnlockTimeOnInsertConstructor_r7(uint t) private    {
      unlockTime = UnlockTimeTuple(t,true);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateOwnerOnInsertConstructor_r2() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r24(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      uint d = n-m;
      emit IncreaseAllowance(o,s,d);
      allowance[o][s].n += d;
      return true;
      return false;
  }
  function updateMintOnInsertRecv_mint_r22(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          emit Mint(p,n);
          totalSupply.n += n;
          balanceOf[p].n += n;
          return true;
        }
      }
      return false;
  }
  function updateBurnOnInsertRecv_burn_r8(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        uint m = balanceOf[p].n;
        if(p!=address(0) && n<=m) {
          emit Burn(p,n);
          balanceOf[p].n -= n;
          totalSupply.n -= n;
          return true;
        }
      }
      return false;
  }
  function updatePrecirculatedOnInsertRecv_disallowPrecirculation_r26(address p) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        precirculated[p] = PrecirculatedTuple(false,true);
        emit Precirculated(p,false);
        return true;
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r10(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[o].n;
      uint k = allowance[o][s].n;
      if(m>=n && k>=n && canTransfer(o,r)) {
        emit TransferFrom(o,r,s,n);
        emit Transfer(o,r,n);
        balanceOf[o].n -= n;
        balanceOf[r].n += n;
        allowance[o][s].n -= n;
        return true;
      }
      return false;
  }
  function updatePrecirculatedOnInsertRecv_allowPrecirculation_r19(address p) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        precirculated[p] = PrecirculatedTuple(true,true);
        emit Precirculated(p,true);
        return true;
      }
      return false;
  }
  function updateTransferOnInsertRecv_transfer_r25(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[s].n;
      if(n<=m && canTransfer(s,r)) {
        emit Transfer(s,r,n);
        balanceOf[s].n -= n;
        balanceOf[r].n += n;
        return true;
      }
      return false;
  }
  function canTransfer(address p,address q) private view  returns (bool) {
      uint ut = unlockTime.t;
      uint t = block.timestamp;
      if(t>=ut) {
        return true;
      }
      if(true==precirculated[q].b) {
        if(true==precirculated[p].b) {
          return true;
        }
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r20() private    {
      // Empty()
  }
  function updateTotalSupplyOnInsertConstructor_r3() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
}