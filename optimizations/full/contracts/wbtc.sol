contract Wbtc {
  struct TotalInTuple {
    uint n;
    bool _valid;
  }
  struct TotalOutTuple {
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct PendingOwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalMintTuple {
    uint n;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct AllMintTuple {
    uint n;
    bool _valid;
  }
  struct AllowanceTotalTuple {
    uint m;
    bool _valid;
  }
  struct SpentTotalTuple {
    uint m;
    bool _valid;
  }
  struct TotalBurnTuple {
    uint n;
    bool _valid;
  }
  struct DecreaseAllowanceTotalTuple {
    uint m;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  struct AllBurnTuple {
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
  mapping(address=>TotalInTuple) totalIn;
  mapping(address=>TotalOutTuple) totalOut;
  mapping(address=>TotalBurnTuple) totalBurn;
  OwnerTuple owner;
  PendingOwnerTuple pendingOwner;
  mapping(address=>mapping(address=>DecreaseAllowanceTotalTuple)) decreaseAllowanceTotal;
  mapping(address=>TotalMintTuple) totalMint;
  TotalSupplyTuple totalSupply;
  AllMintTuple allMint;
  mapping(address=>mapping(address=>AllowanceTotalTuple)) allowanceTotal;
  mapping(address=>mapping(address=>SpentTotalTuple)) spentTotal;
  mapping(address=>BalanceOfTuple) balanceOf;
  AllBurnTuple allBurn;
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
  function updateBalanceOfOnInsertTotalIn_r7(address p,uint i) private    {
      TotalInTuple memory toDelete = totalIn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalIn_r7(p,toDelete.n);
      }
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalBurnTuple memory totalBurnTuple = totalBurn[p];
      uint m = totalBurnTuple.n;
      TotalMintTuple memory totalMintTuple = totalMint[p];
      uint n = totalMintTuple.n;
      uint s = ((n+i)-m)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateTotalBalancesOnInsertConstructor_r33() private    {
      // Empty()
  }
  function updateTotalOutOnInsertTransfer_r23(address p,uint n) private    {
      int delta1 = int(n);
      updateBalanceOfOnIncrementTotalOut_r7(p,delta1);
      totalOut[p].n += n;
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
  function updateBalanceOfOnIncrementTotalIn_r7(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(totalIn[p].n,_delta);
      updateBalanceOfOnInsertTotalIn_r7(p,newValue);
  }
  function updateTotalInOnInsertTransfer_r10(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r7(p,delta0);
      totalIn[p].n += n;
  }
  function updateAllBurnOnInsertBurn_r29(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r20(delta0);
      allBurn.n += n;
  }
  function updateBalanceOfOnInsertTotalBurn_r7(address p,uint m) private    {
      TotalBurnTuple memory toDelete = totalBurn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalBurn_r7(p,toDelete.n);
      }
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalMintTuple memory totalMintTuple = totalMint[p];
      uint n = totalMintTuple.n;
      uint s = ((n+i)-m)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
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
  function updateAllowanceOnDeleteDecreaseAllowanceTotal_r26(address o,address s,uint d) private    {
      SpentTotalTuple memory spentTotalTuple = spentTotal[o][s];
      uint l = spentTotalTuple.m;
      AllowanceTotalTuple memory allowanceTotalTuple = allowanceTotal[o][s];
      uint m = allowanceTotalTuple.m;
      uint n = (m-l)-d;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      if(n==allowanceTuple.n) {
        allowance[o][s] = AllowanceTuple(0,false);
      }
  }
  function updateOwnerOnInsertClaimOwnership_r30(address s) private    {
      owner = OwnerTuple(s,true);
  }
  function updateAllowanceOnIncrementSpentTotal_r26(address o,address s,int l) private    {
      int _delta = int(l);
      uint newValue = updateuintByint(spentTotal[o][s].m,_delta);
      updateAllowanceOnInsertSpentTotal_r26(o,s,newValue);
  }
  function updateAllowanceOnInsertSpentTotal_r26(address o,address s,uint l) private    {
      SpentTotalTuple memory toDelete = spentTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteSpentTotal_r26(o,s,toDelete.m);
      }
      DecreaseAllowanceTotalTuple memory decreaseAllowanceTotalTuple = decreaseAllowanceTotal[o][s];
      uint d = decreaseAllowanceTotalTuple.m;
      AllowanceTotalTuple memory allowanceTotalTuple = allowanceTotal[o][s];
      uint m = allowanceTotalTuple.m;
      uint n = (m-l)-d;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateBalanceOfOnInsertTotalMint_r7(address p,uint n) private    {
      TotalMintTuple memory toDelete = totalMint[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalMint_r7(p,toDelete.n);
      }
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalBurnTuple memory totalBurnTuple = totalBurn[p];
      uint m = totalBurnTuple.n;
      uint s = ((n+i)-m)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateAllMintOnInsertMint_r16(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllMint_r20(delta0);
      allMint.n += n;
  }
  function updateOwnerOnInsertConstructor_r9() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
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
  function updateIncreaseAllowanceOnInsertRecv_increaseApproval_r17(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      updateAllowanceTotalOnInsertIncreaseAllowance_r32(o,s,n);
      emit IncreaseAllowance(o,s,n);
      return true;
      return false;
  }
  function updateAllowanceOnIncrementDecreaseAllowanceTotal_r26(address o,address s,int d) private    {
      int _delta = int(d);
      uint newValue = updateuintByint(decreaseAllowanceTotal[o][s].m,_delta);
      updateAllowanceOnInsertDecreaseAllowanceTotal_r26(o,s,newValue);
  }
  function updateBalanceOfOnInsertTotalOut_r7(address p,uint o) private    {
      TotalOutTuple memory toDelete = totalOut[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalOut_r7(p,toDelete.n);
      }
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      TotalBurnTuple memory totalBurnTuple = totalBurn[p];
      uint m = totalBurnTuple.n;
      TotalMintTuple memory totalMintTuple = totalMint[p];
      uint n = totalMintTuple.n;
      uint s = ((n+i)-m)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateTotalSupplyOnInsertAllMint_r20(uint m) private    {
      uint b = allBurn.n;
      uint n = m-b;
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateDecreaseAllowanceTotalOnInsertDecreaseAllowance_r8(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementDecreaseAllowanceTotal_r26(o,s,delta0);
      decreaseAllowanceTotal[o][s].m += n;
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
  function updateBalanceOfOnIncrementTotalOut_r7(address p,int o) private    {
      int _delta = int(o);
      uint newValue = updateuintByint(totalOut[p].n,_delta);
      updateBalanceOfOnInsertTotalOut_r7(p,newValue);
  }
  function updateAllowanceOnInsertDecreaseAllowanceTotal_r26(address o,address s,uint d) private    {
      DecreaseAllowanceTotalTuple memory toDelete = decreaseAllowanceTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteDecreaseAllowanceTotal_r26(o,s,toDelete.m);
      }
      SpentTotalTuple memory spentTotalTuple = spentTotal[o][s];
      uint l = spentTotalTuple.m;
      AllowanceTotalTuple memory allowanceTotalTuple = allowanceTotal[o][s];
      uint m = allowanceTotalTuple.m;
      uint n = (m-l)-d;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateTransferOnInsertReclaimToken_r4(address t,address s,uint n) private    {
      updateTotalInOnInsertTransfer_r10(s,n);
      updateTotalOutOnInsertTransfer_r23(t,n);
      emit Transfer(t,s,n);
  }
  function updateAllowanceOnDeleteAllowanceTotal_r26(address o,address s,uint m) private    {
      DecreaseAllowanceTotalTuple memory decreaseAllowanceTotalTuple = decreaseAllowanceTotal[o][s];
      uint d = decreaseAllowanceTotalTuple.m;
      SpentTotalTuple memory spentTotalTuple = spentTotal[o][s];
      uint l = spentTotalTuple.m;
      uint n = (m-l)-d;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      if(n==allowanceTuple.n) {
        allowance[o][s] = AllowanceTuple(0,false);
      }
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
  function updateTotalSupplyOnInsertAllBurn_r20(uint b) private    {
      uint m = allMint.n;
      uint n = m-b;
      totalSupply = TotalSupplyTuple(n,true);
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
  function updateBalanceOfOnDeleteTotalMint_r7(address p,uint n) private    {
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalBurnTuple memory totalBurnTuple = totalBurn[p];
      uint m = totalBurnTuple.n;
      uint s = ((n+i)-m)-o;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      if(s==balanceOfTuple.n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateAllowanceOnInsertAllowanceTotal_r26(address o,address s,uint m) private    {
      AllowanceTotalTuple memory toDelete = allowanceTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteAllowanceTotal_r26(o,s,toDelete.m);
      }
      DecreaseAllowanceTotalTuple memory decreaseAllowanceTotalTuple = decreaseAllowanceTotal[o][s];
      uint d = decreaseAllowanceTotalTuple.m;
      SpentTotalTuple memory spentTotalTuple = spentTotal[o][s];
      uint l = spentTotalTuple.m;
      uint n = (m-l)-d;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateAllowanceOnIncrementAllowanceTotal_r26(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowanceTotal[o][s].m,_delta);
      updateAllowanceOnInsertAllowanceTotal_r26(o,s,newValue);
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
  function updateBalanceOfOnDeleteTotalIn_r7(address p,uint i) private    {
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalBurnTuple memory totalBurnTuple = totalBurn[p];
      uint m = totalBurnTuple.n;
      TotalMintTuple memory totalMintTuple = totalMint[p];
      uint n = totalMintTuple.n;
      uint s = ((n+i)-m)-o;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      if(s==balanceOfTuple.n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateTotalSupplyOnInsertConstructor_r14() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updateBalanceOfOnIncrementTotalMint_r7(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(totalMint[p].n,_delta);
      updateBalanceOfOnInsertTotalMint_r7(p,newValue);
  }
  function updateSpentTotalOnInsertTransferFrom_r25(address o,address s,uint n) private    {
      int delta1 = int(n);
      updateAllowanceOnIncrementSpentTotal_r26(o,s,delta1);
      spentTotal[o][s].m += n;
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
  function updateAllowanceOnDeleteSpentTotal_r26(address o,address s,uint l) private    {
      DecreaseAllowanceTotalTuple memory decreaseAllowanceTotalTuple = decreaseAllowanceTotal[o][s];
      uint d = decreaseAllowanceTotalTuple.m;
      AllowanceTotalTuple memory allowanceTotalTuple = allowanceTotal[o][s];
      uint m = allowanceTotalTuple.m;
      uint n = (m-l)-d;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      if(n==allowanceTuple.n) {
        allowance[o][s] = AllowanceTuple(0,false);
      }
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r32(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r26(o,s,delta0);
      allowanceTotal[o][s].m += n;
  }
  function updateBalanceOfOnDeleteTotalBurn_r7(address p,uint m) private    {
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalMintTuple memory totalMintTuple = totalMint[p];
      uint n = totalMintTuple.n;
      uint s = ((n+i)-m)-o;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      if(s==balanceOfTuple.n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateTotalSupplyOnIncrementAllBurn_r20(int b) private    {
      int _delta = int(b);
      uint newValue = updateuintByint(allBurn.n,_delta);
      updateTotalSupplyOnInsertAllBurn_r20(newValue);
  }
  function updateBalanceOfOnIncrementTotalBurn_r7(address p,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalBurn[p].n,_delta);
      updateBalanceOfOnInsertTotalBurn_r7(p,newValue);
  }
  function updateBalanceOfOnDeleteTotalOut_r7(address p,uint o) private    {
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      TotalBurnTuple memory totalBurnTuple = totalBurn[p];
      uint m = totalBurnTuple.n;
      TotalMintTuple memory totalMintTuple = totalMint[p];
      uint n = totalMintTuple.n;
      uint s = ((n+i)-m)-o;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      if(s==balanceOfTuple.n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateTotalBurnOnInsertBurn_r18(address p,uint n) private    {
      int delta1 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r7(p,delta1);
      totalBurn[p].n += n;
  }
  function updateTotalSupplyOnIncrementAllMint_r20(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allMint.n,_delta);
      updateTotalSupplyOnInsertAllMint_r20(newValue);
  }
  function updateTotalMintOnInsertMint_r19(address p,uint n) private    {
      int delta1 = int(n);
      updateBalanceOfOnIncrementTotalMint_r7(p,delta1);
      totalMint[p].n += n;
  }
}