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
  event IncreaseAllowance(address p,address s,uint n);
  event Transfer(address from,address to,uint amount);
  event Paused(bool b);
  event TransferFrom(address from,address to,address spender,uint amount);
  constructor() public {
    updateTotalSupplyOnInsertConstructor_r17();
    updateTotalBalancesOnInsertConstructor_r30();
    updateOwnerOnInsertConstructor_r12();
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r15 = updateTransferFromOnInsertRecv_transferFrom_r15(from,to,amount);
      if(r15==false) {
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
  function approve(address s,uint n) public    {
      bool r28 = updateIncreaseAllowanceOnInsertRecv_approve_r28(s,n);
      if(r28==false) {
        revert("Rule condition failed");
      }
  }
  function claimOwnership() public    {
      bool r14 = updateClaimOwnershipOnInsertRecv_claimOwnership_r14();
      if(r14==false) {
        revert("Rule condition failed");
      }
  }
  function pause() public    {
      bool r16 = updatePausedOnInsertRecv_pause_r16();
      if(r16==false) {
        revert("Rule condition failed");
      }
  }
  function unpause() public    {
      bool r24 = updatePausedOnInsertRecv_unpause_r24();
      if(r24==false) {
        revert("Rule condition failed");
      }
  }
  function burn(address p,uint amount) public    {
      bool r8 = updateBurnOnInsertRecv_burn_r8(p,amount);
      if(r8==false) {
        revert("Rule condition failed");
      }
  }
  function transferOwner(address p) public    {
      bool r10 = updatePendingOwnerOnInsertRecv_transferOwner_r10(p);
      if(r10==false) {
        revert("Rule condition failed");
      }
  }
  function reclaimToken() public    {
      bool r7 = updateReclaimTokenOnInsertRecv_reclaimToken_r7();
      if(r7==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function mint(address p,uint amount) public    {
      bool r25 = updateMintOnInsertRecv_mint_r25(p,amount);
      if(r25==false) {
        revert("Rule condition failed");
      }
  }
  function updateClaimOwnershipOnInsertRecv_claimOwnership_r14() private   returns (bool) {
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
  function updateOwnerOnInsertConstructor_r12() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateBurnOnInsertRecv_burn_r8(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        BalanceOfTuple memory balanceOfTuple = balanceOf[p];
        uint m = balanceOfTuple.n;
        if(p!=address(0) && n<=m) {
          emit Burn(p,n);
          balanceOf[p].n -= n;
          totalSupply.n -= n;
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
  function updateTransferFromOnInsertRecv_transferFrom_r15(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      if(false==paused.b) {
        BalanceOfTuple memory balanceOfTuple = balanceOf[o];
        uint m = balanceOfTuple.n;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        uint k = allowanceTuple.n;
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
  function updatePausedOnInsertRecv_pause_r16() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        paused = PausedTuple(true,true);
        emit Paused(true);
        return true;
      }
      return false;
  }
  function updateTransferOnInsertRecv_transfer_r3(address r,uint n) private   returns (bool) {
      if(false==paused.b) {
        address s = msg.sender;
        BalanceOfTuple memory balanceOfTuple = balanceOf[s];
        uint m = balanceOfTuple.n;
        if(n<=m) {
          emit Transfer(s,r,n);
          balanceOf[s].n -= n;
          balanceOf[r].n += n;
          return true;
        }
      }
      return false;
  }
  function updateReclaimTokenOnInsertRecv_reclaimToken_r7() private   returns (bool) {
      address s = msg.sender;
      if(s==owner.p) {
        address t = address(this);
        BalanceOfTuple memory balanceOfTuple = balanceOf[t];
        uint n = balanceOfTuple.n;
        emit ReclaimToken(t,s,n);
        emit Transfer(t,s,n);
        balanceOf[t].n -= n;
        balanceOf[s].n += n;
        payable(s).send(n);
        return true;
      }
      return false;
  }
  function updateMintOnInsertRecv_mint_r25(address p,uint n) private   returns (bool) {
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
  function updateTotalSupplyOnInsertConstructor_r17() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updatePendingOwnerOnInsertRecv_transferOwner_r10(address p) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        pendingOwner = PendingOwnerTuple(p,true);
        emit PendingOwner(p);
        return true;
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r30() private    {
      // Empty()
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r28(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      uint d = n-m;
      emit IncreaseAllowance(o,s,d);
      allowance[o][s].n += n;
      return true;
      return false;
  }
  function updatePausedOnInsertRecv_unpause_r24() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        paused = PausedTuple(false,true);
        emit Paused(false);
        return true;
      }
      return false;
  }
}