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
  function pause() public    {
      bool r13 = updatePausedOnInsertRecv_pause_r13();
      if(r13==false) {
        revert("Rule condition failed");
      }
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
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function increaseApproval(address p,uint n) public    {
      bool r17 = updateIncreaseAllowanceOnInsertRecv_increaseApproval_r17(p,n);
      if(r17==false) {
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
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
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
  function decreaseApproval(address p,uint n) public    {
      bool r21 = updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r21(p,n);
      if(r21==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function updateIncreaseAllowanceOnInsertRecv_increaseApproval_r17(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      updateAllowanceTotalOnInsertIncreaseAllowance_r32(o,s,n);
      emit IncreaseAllowance(o,s,n);
      return true;
      return false;
  }
  function updateBurnOnInsertRecv_burn_r15(uint n) private   returns (bool) {
      address p = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint m = balanceOfTuple.n;
      if(n<=m) {
        updateTotalBurnOnInsertBurn_r18(p,n);
        updateAllBurnOnInsertBurn_r29(n);
        emit Burn(p,n);
        return true;
      }
      return false;
  }
  function updateTotalOutOnInsertTransfer_r23(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r7(p,delta0);
  }
  function updateTotalBalancesOnInsertConstructor_r33() private    {
      // Empty()
  }
  function updateTransferOnInsertRecv_transfer_r3(address r,uint n) private   returns (bool) {
      if(false==paused.b) {
        address s = msg.sender;
        BalanceOfTuple memory balanceOfTuple = balanceOf[s];
        uint m = balanceOfTuple.n;
        if(n<=m) {
          updateTotalOutOnInsertTransfer_r23(s,n);
          updateTotalInOnInsertTransfer_r10(r,n);
          emit Transfer(s,r,n);
          return true;
        }
      }
      return false;
  }
  function updateAllowanceOnIncrementSpentTotal_r26(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r31(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      uint d = n-m;
      updateAllowanceTotalOnInsertIncreaseAllowance_r32(o,s,d);
      emit IncreaseAllowance(o,s,d);
      return true;
      return false;
  }
  function updateTotalBurnOnInsertBurn_r18(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r7(p,delta0);
  }
  function updateBalanceOfOnIncrementTotalBurn_r7(address p,int m) private    {
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateAllBurnOnInsertBurn_r29(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r20(delta0);
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r32(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r26(o,s,delta0);
  }
  function updateTotalSupplyOnIncrementAllBurn_r20(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updatePausedOnInsertRecv_pause_r13() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        paused = PausedTuple(true,true);
        emit Paused(true);
        return true;
      }
      return false;
  }
  function updateTotalMintOnInsertMint_r19(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalMint_r7(p,delta0);
  }
  function updateOwnerOnInsertClaimOwnership_r30(address s) private    {
      owner = OwnerTuple(s,true);
  }
  function updateAllowanceOnIncrementAllowanceTotal_r26(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateOwnerOnInsertConstructor_r9() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateAllowanceOnIncrementDecreaseAllowanceTotal_r26(address o,address s,int d) private    {
      int _delta = int(-d);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateReclaimTokenOnInsertRecv_reclaimToken_r6() private   returns (bool) {
      address s = msg.sender;
      if(s==owner.p) {
        address t = address(this);
        BalanceOfTuple memory balanceOfTuple = balanceOf[t];
        uint n = balanceOfTuple.n;
        updateSendOnInsertReclaimToken_r22(s,n);
        updateTransferOnInsertReclaimToken_r4(t,s,n);
        emit ReclaimToken(t,s,n);
        return true;
      }
      return false;
  }
  function updateTransferOnInsertReclaimToken_r4(address t,address s,uint n) private    {
      updateTotalInOnInsertTransfer_r10(s,n);
      updateTotalOutOnInsertTransfer_r23(t,n);
      emit Transfer(t,s,n);
  }
  function updateBalanceOfOnIncrementTotalOut_r7(address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTransferOnInsertTransferFrom_r1(address o,address r,uint n) private    {
      updateTotalOutOnInsertTransfer_r23(o,n);
      updateTotalInOnInsertTransfer_r10(r,n);
      emit Transfer(o,r,n);
  }
  function updatePausedOnInsertRecv_unpause_r27() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        paused = PausedTuple(false,true);
        emit Paused(false);
        return true;
      }
      return false;
  }
  function updateMintOnInsertRecv_mint_r28(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          updateAllMintOnInsertMint_r16(n);
          updateTotalMintOnInsertMint_r19(p,n);
          emit Mint(p,n);
          return true;
        }
      }
      return false;
  }
  function updateSpentTotalOnInsertTransferFrom_r25(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r26(o,s,delta0);
  }
  function updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r21(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      if(m>=n) {
        updateDecreaseAllowanceTotalOnInsertDecreaseAllowance_r8(o,s,n);
        emit DecreaseAllowance(o,s,n);
        return true;
      }
      return false;
  }
  function updatePendingOwnerOnInsertClaimOwnership_r2() private    {
      pendingOwner = PendingOwnerTuple(address(0),true);
      emit PendingOwner(address(0));
  }
  function updateSendOnInsertReclaimToken_r22(address s,uint n) private    {
      payable(s).send(n);
  }
  function updatePendingOwnerOnInsertRecv_transferOwnership_r0(address p) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        pendingOwner = PendingOwnerTuple(p,true);
        emit PendingOwner(p);
        return true;
      }
      return false;
  }
  function updateTotalSupplyOnInsertConstructor_r14() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updateTotalInOnInsertTransfer_r10(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r7(p,delta0);
  }
  function updateTotalSupplyOnIncrementAllMint_r20(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateClaimOwnershipOnInsertRecv_claimOwnership_r11() private   returns (bool) {
      address s = pendingOwner.p;
      if(s==msg.sender) {
        updateOwnerOnInsertClaimOwnership_r30(s);
        updatePendingOwnerOnInsertClaimOwnership_r2();
        emit ClaimOwnership(s);
        return true;
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r12(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      if(false==paused.b) {
        BalanceOfTuple memory balanceOfTuple = balanceOf[o];
        uint m = balanceOfTuple.n;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        uint k = allowanceTuple.n;
        if(m>=n && k>=n) {
          updateSpentTotalOnInsertTransferFrom_r25(o,s,n);
          updateTransferOnInsertTransferFrom_r1(o,r,n);
          emit TransferFrom(o,r,s,n);
          return true;
        }
      }
      return false;
  }
  function updateDecreaseAllowanceTotalOnInsertDecreaseAllowance_r8(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementDecreaseAllowanceTotal_r26(o,s,delta0);
  }
  function updateBalanceOfOnIncrementTotalIn_r7(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateAllMintOnInsertMint_r16(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllMint_r20(delta0);
  }
  function updateBalanceOfOnIncrementTotalMint_r7(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
}