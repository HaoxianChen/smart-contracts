contract Wbtc {
  struct OwnerTuple {
    address p;
  }
  struct PendingOwnerTuple {
    address p;
  }
  struct TotalSupplyTuple {
    uint n;
  }
  struct BalanceOfTuple {
    uint n;
  }
  struct AllowanceTuple {
    uint n;
  }
  struct PausedTuple {
    bool b;
  }
  PendingOwnerTuple pendingOwner;
  TotalSupplyTuple totalSupply;
  mapping(address=>BalanceOfTuple) balanceOf;
  OwnerTuple owner;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  PausedTuple paused;
  event Burn(address p,uint amount);
  event ReclaimToken(address t,address s,uint n);
  event Mint(address p,uint amount);
  event PendingOwner(address p);
  event ClaimOwnership(address p);
  event DecreaseAllowance(address p,address s,uint n);
  event IncreaseAllowance(address p,address s,uint n);
  event Transfer(address from,address to,uint amount);
  event Paused(bool b);
  event TransferFrom(address from,address to,address spender,uint amount);
  constructor() public {
    updateOwnerOnInsertConstructor_r9();
    updateTotalSupplyOnInsertConstructor_r14();
    updateTotalBalancesOnInsertConstructor_r33();
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r12 = updateTransferFromOnInsertRecv_transferFrom_r12(from,to,amount);
      if(r12==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public    {
      bool r28 = updateMintOnInsertRecv_mint_r28(p,amount);
      if(r28==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function pause() public    {
      bool r13 = updatePausedOnInsertRecv_pause_r13();
      if(r13==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function transfer(address to,uint amount) public    {
      bool r3 = updateTransferOnInsertRecv_transfer_r3(to,amount);
      if(r3==false) {
        revert("Rule condition failed");
      }
  }
  function reclaimToken() public    {
      bool r6 = updateReclaimTokenOnInsertRecv_reclaimToken_r6();
      if(r6==false) {
        revert("Rule condition failed");
      }
  }
  function unpause() public    {
      bool r27 = updatePausedOnInsertRecv_unpause_r27();
      if(r27==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address s,uint n) public    {
      bool r31 = updateIncreaseAllowanceOnInsertRecv_approve_r31(s,n);
      if(r31==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function claimOwnership() public    {
      bool r11 = updateClaimOwnershipOnInsertRecv_claimOwnership_r11();
      if(r11==false) {
        revert("Rule condition failed");
      }
  }
  function burn(uint amount) public    {
      bool r15 = updateBurnOnInsertRecv_burn_r15(amount);
      if(r15==false) {
        revert("Rule condition failed");
      }
  }
  function transferOwnership(address p) public    {
      bool r0 = updatePendingOwnerOnInsertRecv_transferOwnership_r0(p);
      if(r0==false) {
        revert("Rule condition failed");
      }
  }
  function updateTransferFromOnInsertRecv_transferFrom_r12(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      if(false==paused.b) {
        // BalanceOfTuple memory balanceOfTuple = balanceOf[o];
        // uint m = balanceOfTuple.n;
        uint m = balanceOf[o].n;
        // AllowanceTuple memory allowanceTuple = allowance[o][s];
        // uint k = allowanceTuple.n;
        uint k = allowance[o][s].n;
        if(m>=n && k>=n) {
          emit TransferFrom(o,r,s,n);
          // emit Transfer(o,r,n);
          balanceOf[o].n -= n;
          balanceOf[r].n += n;
          allowance[o][s].n -= n;
          return true;
        }
      }
      return false;
  }
  function updateOwnerOnInsertConstructor_r9() private    {
      address s = msg.sender;
      owner = OwnerTuple(s);
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r31(address s,uint n) private   returns (bool) {
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
  function updateReclaimTokenOnInsertRecv_reclaimToken_r6() private   returns (bool) {
      address s = msg.sender;
      if(s==owner.p) {
        address t = address(this);
        // BalanceOfTuple memory balanceOfTuple = balanceOf[t];
        // uint n = balanceOfTuple.n;
        uint n = balanceOf[t].n;
        emit ReclaimToken(t,s,n);
        // emit Transfer(t,s,n);
        balanceOf[t].n -= n;
        balanceOf[s].n += n;
        payable(s).send(n);
        return true;
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r33() private    {
      // Empty()
  }
  function updatePendingOwnerOnInsertRecv_transferOwnership_r0(address p) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        pendingOwner = PendingOwnerTuple(p);
        emit PendingOwner(p);
        return true;
      }
      return false;
  }
  function updateBurnOnInsertRecv_burn_r15(uint n) private   returns (bool) {
      address p = msg.sender;
      // BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      // uint m = balanceOfTuple.n;
      uint m = balanceOf[p].n;
      if(n<=m) {
        emit Burn(p,n);
        balanceOf[p].n -= n;
        totalSupply.n -= n;
        return true;
      }
      return false;
  }
  function updateTotalSupplyOnInsertConstructor_r14() private    {
      totalSupply = TotalSupplyTuple(0);
  }
  function updateClaimOwnershipOnInsertRecv_claimOwnership_r11() private   returns (bool) {
      address s = pendingOwner.p;
      if(s==msg.sender) {
        emit ClaimOwnership(s);
        pendingOwner = PendingOwnerTuple(address(0));
        // emit PendingOwner(address(0));
        owner = OwnerTuple(s);
        return true;
      }
      return false;
  }
  function updatePausedOnInsertRecv_pause_r13() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        paused = PausedTuple(true);
        emit Paused(true);
        return true;
      }
      return false;
  }
  function updatePausedOnInsertRecv_unpause_r27() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        paused = PausedTuple(false);
        emit Paused(false);
        return true;
      }
      return false;
  }
  function updateTransferOnInsertRecv_transfer_r3(address r,uint n) private   returns (bool) {
      if(false==paused.b) {
        address s = msg.sender;
        // BalanceOfTuple memory balanceOfTuple = balanceOf[s];
        // uint m = balanceOfTuple.n;
        uint m = balanceOf[s].n;
        if(n<=m) {
          emit Transfer(s,r,n);
          balanceOf[s].n -= n;
          balanceOf[r].n += n;
          return true;
        }
      }
      return false;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateMintOnInsertRecv_mint_r28(address p,uint n) private   returns (bool) {
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
}
