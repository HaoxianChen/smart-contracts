contract LtcSwapAsset {
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
  function updateMintOnInsertRecv_mint_r21(address p,uint n) private   returns (bool) {
      address s = msg.sender;
      if(p!=address(0) && owner(s)) {
        emit Mint(p,n);
        totalSupply.n += n;
        balanceOf[p].n += n;
        return true;
      }
      return false;
  }
  function updateTotalSupplyOnInsertConstructor_r11() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r25(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      uint d = n-m;
      emit IncreaseAllowance(o,s,d);
      allowance[o][s].n += n;
      return true;
      return false;
  }
  function updateSwapOwnerOnInsertRecv_swapOwner_r18(address p,address q,uint d) private   returns (bool) {
      address s = msg.sender;
      uint t0 = block.timestamp;
      uint t = t0+d;
      emit SwapOwner(p,q,t);
      oldOwner = OldOwnerTuple(p,true);
      effectiveTime = EffectiveTimeTuple(t,true);
      newOwner = NewOwnerTuple(q,true);
      return true;
      return false;
  }
  function updateBurnOnInsertRecv_burn_r5(address p,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint m = balanceOfTuple.n;
      if(p!=address(0) && n<=m && owner(s)) {
        emit Burn(p,n);
        balanceOf[p].n -= n;
        totalSupply.n -= n;
        return true;
      }
      return false;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateOldOwnerOnInsertConstructor_r8() private    {
      address s = msg.sender;
      oldOwner = OldOwnerTuple(s,true);
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
      return true;
  }
  function updateTransferOnInsertRecv_transfer_r15(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[s];
      uint m = balanceOfTuple.n;
      if(n<=m) {
        emit Transfer(s,r,n);
        balanceOf[s].n -= n;
        balanceOf[r].n += n;
        return true;
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r27() private    {
      // Empty()
  }
  function updateTransferFromOnInsertRecv_transferFrom_r22(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint k = allowanceTuple.n;
      BalanceOfTuple memory balanceOfTuple = balanceOf[o];
      uint m = balanceOfTuple.n;
      if(m>=n && k>=n) {
        emit TransferFrom(o,r,s,n);
        emit Transfer(o,r,n);
        balanceOf[o].n -= n;
        balanceOf[r].n += n;
        allowance[o][s].n -= n;
        return true;
      }
      return false;
  }
}