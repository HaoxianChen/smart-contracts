contract Wbtc {
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct PendingOwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  struct PausedTuple {
    bool b;
    bool _valid;
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
    updateTotalSupplyOnInsertConstructor_r2();
    updateOwnerOnInsertConstructor_r8();
    updateTotalBalancesOnInsertConstructor_r33();
  }
  function reclaimToken() public    {
      bool r23 = updateReclaimTokenOnInsertRecv_reclaimToken_r23();
      if(r23==false) {
        revert("Rule condition failed");
      }
  }
  function transferOwnership(address p) public    {
      bool r22 = updatePendingOwnerOnInsertRecv_transferOwnership_r22(p);
      if(r22==false) {
        revert("Rule condition failed");
      }
  }
  function decreaseApproval(address p,uint n) public    {
      bool r20 = updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r20(p,n);
      if(r20==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function increaseApproval(address p,uint n) public    {
      bool r16 = updateIncreaseAllowanceOnInsertRecv_increaseApproval_r16(p,n);
      if(r16==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public    {
      bool r3 = updateTransferOnInsertRecv_transfer_r3(to,amount);
      if(r3==false) {
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
  function pause() public    {
      bool r9 = updatePausedOnInsertRecv_pause_r9();
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function burn(uint amount) public    {
      bool r14 = updateBurnOnInsertRecv_burn_r14(amount);
      if(r14==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public    {
      bool r10 = updateMintOnInsertRecv_mint_r10(p,amount);
      if(r10==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address s,uint n) public    {
      bool r31 = updateIncreaseAllowanceOnInsertRecv_approve_r31(s,n);
      if(r31==false) {
        revert("Rule condition failed");
      }
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r13 = updateTransferFromOnInsertRecv_transferFrom_r13(from,to,amount);
      if(r13==false) {
        revert("Rule condition failed");
      }
  }
  function claimOwnership() public    {
      bool r12 = updateClaimOwnershipOnInsertRecv_claimOwnership_r12();
      if(r12==false) {
        revert("Rule condition failed");
      }
  }
  function unpause() public    {
      bool r26 = updatePausedOnInsertRecv_unpause_r26();
      if(r26==false) {
        revert("Rule condition failed");
      }
  }
  function updateMintOnInsertRecv_mint_r10(address p,uint n) private   returns (bool) {
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
  function updateOwnerOnInsertConstructor_r8() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateTotalSupplyOnInsertConstructor_r2() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updateBurnOnInsertRecv_burn_r14(uint n) private   returns (bool) {
      address p = msg.sender;
      uint m = balanceOf[p].n;
      if(n<=m) {
        emit Burn(p,n);
        balanceOf[p].n -= n;
        totalSupply.n -= n;
        return true;
      }
      return false;
  }
  function updatePausedOnInsertRecv_unpause_r26() private   returns (bool) {
      if(true==paused.b) {
        address s = owner.p;
        if(s==msg.sender) {
          paused = PausedTuple(false,true);
          emit Paused(false);
          return true;
        }
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r33() private    {
      // Empty()
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateClaimOwnershipOnInsertRecv_claimOwnership_r12() private   returns (bool) {
      address s = pendingOwner.p;
      if(s==msg.sender) {
        emit ClaimOwnership(s);
        pendingOwner = PendingOwnerTuple(address(0),true);
        emit PendingOwner(address(0));
        owner = OwnerTuple(s,true);
        return true;
      }
      return false;
  }
  function updateIncreaseAllowanceOnInsertRecv_increaseApproval_r16(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      emit IncreaseAllowance(o,s,n);
      allowance[o][s].n += n;
      return true;
      return false;
  }
  function updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r20(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      if(m>=n) {
        emit DecreaseAllowance(o,s,n);
        allowance[o][s].n -= n;
        return true;
      }
      return false;
  }
  function updatePausedOnInsertRecv_pause_r9() private   returns (bool) {
      if(false==paused.b) {
        address s = owner.p;
        if(s==msg.sender) {
          paused = PausedTuple(true,true);
          emit Paused(true);
          return true;
        }
      }
      return false;
  }
  function updatePendingOwnerOnInsertRecv_transferOwnership_r22(address p) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          pendingOwner = PendingOwnerTuple(p,true);
          emit PendingOwner(p);
          return true;
        }
      }
      return false;
  }
  function updateReclaimTokenOnInsertRecv_reclaimToken_r23() private   returns (bool) {
      address s = msg.sender;
      if(s==owner.p) {
        address t = address(this);
        uint n = balanceOf[t].n;
        emit ReclaimToken(t,s,n);
        emit Transfer(t,s,n);
        balanceOf[t].n -= n;
        balanceOf[s].n += n;
        payable(s).send(n);
        return true;
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r13(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      if(false==paused.b) {
        uint m = balanceOf[o].n;
        uint k = allowance[o][s].n;
        if(m>=n && k>=n) {
          emit TransferFrom(o,r,s,n);
          emit Transfer(o,r,n);
          balanceOf[o].n -= n;
          balanceOf[r].n += n;
          allowance[o][s].n -= n;
          return true;
        }
      }
      return false;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r31(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      uint d = n-m;
      emit IncreaseAllowance(o,s,d);
      allowance[o][s].n += d;
      return true;
      return false;
  }
  function updateTransferOnInsertRecv_transfer_r3(address r,uint n) private   returns (bool) {
      if(false==paused.b) {
        address s = msg.sender;
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
}