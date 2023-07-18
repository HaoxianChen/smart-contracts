contract Bnb {
  struct TotalOutTuple {
    uint n;
    bool _valid;
  }
  struct TotalFreezeTuple {
    uint n;
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
  struct SpentTotalTuple {
    uint m;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  struct TotalInTuple {
    uint n;
    bool _valid;
  }
  struct TotalUnfreezeTuple {
    uint n;
    bool _valid;
  }
  struct TotalBurnTuple {
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct FreezeOfTuple {
    uint n;
    bool _valid;
  }
  struct AllowanceTotalTuple {
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
  mapping(address=>TotalInTuple) totalIn;
  mapping(address=>TotalOutTuple) totalOut;
  mapping(address=>TotalFreezeTuple) totalFreeze;
  OwnerTuple owner;
  mapping(address=>FreezeOfTuple) freezeOf;
  mapping(address=>TotalMintTuple) totalMint;
  TotalSupplyTuple totalSupply;
  AllMintTuple allMint;
  mapping(address=>mapping(address=>AllowanceTotalTuple)) allowanceTotal;
  mapping(address=>mapping(address=>SpentTotalTuple)) spentTotal;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  mapping(address=>TotalUnfreezeTuple) totalUnfreeze;
  mapping(address=>TotalBurnTuple) totalBurn;
  mapping(address=>BalanceOfTuple) balanceOf;
  AllBurnTuple allBurn;
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event WithdrawEther(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event Unfreeze(address p,uint n);
  event Freeze(address p,uint n);
  event Transfer(address from,address to,uint amount);
  constructor(uint initialSupply) public {
    updateTotalSupplyOnInsertConstructor_r5(initialSupply);
    updateTotalBalancesOnInsertConstructor_r25(initialSupply);
    updateBalanceOfOnInsertConstructor_r4(initialSupply);
    updateOwnerOnInsertConstructor_r9();
  }
  function burn(uint amount) public    {
      bool r15 = updateBurnOnInsertRecv_burn_r15(amount);
      if(r15==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function transfer(address to,uint amount) public    {
      bool r19 = updateTransferOnInsertRecv_transfer_r19(to,amount);
      if(r19==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function freeze(uint n) public    {
      bool r24 = updateFreezeOnInsertRecv_freeze_r24(n);
      if(r24==false) {
        revert("Rule condition failed");
      }
  }
  function withdrawEther(uint amount) public    {
      bool r23 = updateWithdrawEtherOnInsertRecv_withdrawEther_r23(amount);
      if(r23==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address s,uint n) public    {
      bool r28 = updateIncreaseAllowanceOnInsertRecv_approve_r28(s,n);
      if(r28==false) {
        revert("Rule condition failed");
      }
  }
  function unfreeze(uint n) public    {
      bool r6 = updateUnfreezeOnInsertRecv_unfreeze_r6(n);
      if(r6==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r29 = updateTransferFromOnInsertRecv_transferFrom_r29(from,to,amount);
      if(r29==false) {
        revert("Rule condition failed");
      }
  }
  function updateTotalFreezeOnInsertFreeze_r0(address p,uint n) private    {
      int delta2 = int(n);
      updateFreezeOfOnIncrementTotalFreeze_r12(p,delta2);
      totalFreeze[p].n += n;
  }
  function updateTotalBurnOnInsertBurn_r16(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r14(p,delta0);
      totalBurn[p].n += n;
  }
  function updateAllowanceOnInsertSpentTotal_r26(address o,address s,uint l) private    {
      SpentTotalTuple memory toDelete = spentTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteSpentTotal_r26(o,s,toDelete.m);
      }
      AllowanceTotalTuple memory allowanceTotalTuple = allowanceTotal[o][s];
      uint m = allowanceTotalTuple.m;
      uint n = m-l;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateFreezeOfOnDeleteTotalFreeze_r12(address p,uint f) private    {
      TotalUnfreezeTuple memory totalUnfreezeTuple = totalUnfreeze[p];
      uint u = totalUnfreezeTuple.n;
      uint n = f-u;
      updateBalanceOfOnDeleteFreezeOf_r14(p,n);
      FreezeOfTuple memory freezeOfTuple = freezeOf[p];
      if(n==freezeOfTuple.n) {
        freezeOf[p] = FreezeOfTuple(0,false);
      }
  }
  function updateTransferFromOnInsertRecv_transferFrom_r29(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint k = allowanceTuple.n;
      BalanceOfTuple memory balanceOfTuple = balanceOf[o];
      uint m = balanceOfTuple.n;
      if(m>=n && k>=n) {
        updateSpentTotalOnInsertTransferFrom_r22(o,s,n);
        updateTransferOnInsertTransferFrom_r1(o,r,n);
        emit TransferFrom(o,r,s,n);
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
  function updateBalanceOfOnInsertTotalBurn_r14(address p,uint m) private    {
      TotalBurnTuple memory toDelete = totalBurn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalBurn_r14(p,toDelete.n);
      }
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      FreezeOfTuple memory freezeOfTuple = freezeOf[p];
      uint f = freezeOfTuple.n;
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalMintTuple memory totalMintTuple = totalMint[p];
      uint n = totalMintTuple.n;
      uint s = (((n+i)-m)-o)-f;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateFreezeOnInsertRecv_freeze_r24(uint n) private   returns (bool) {
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
  function updateBalanceOfOnInsertTotalIn_r14(address p,uint i) private    {
      TotalInTuple memory toDelete = totalIn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalIn_r14(p,toDelete.n);
      }
      FreezeOfTuple memory freezeOfTuple = freezeOf[p];
      uint f = freezeOfTuple.n;
      TotalBurnTuple memory totalBurnTuple = totalBurn[p];
      uint m = totalBurnTuple.n;
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalMintTuple memory totalMintTuple = totalMint[p];
      uint n = totalMintTuple.n;
      uint s = (((n+i)-m)-o)-f;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateFreezeOfOnInsertTotalFreeze_r12(address p,uint f) private    {
      TotalFreezeTuple memory toDelete = totalFreeze[p];
      if(toDelete._valid==true) {
        updateFreezeOfOnDeleteTotalFreeze_r12(p,toDelete.n);
      }
      TotalUnfreezeTuple memory totalUnfreezeTuple = totalUnfreeze[p];
      uint u = totalUnfreezeTuple.n;
      uint n = f-u;
      updateBalanceOfOnInsertFreezeOf_r14(p,n);
      freezeOf[p] = FreezeOfTuple(n,true);
  }
  function updateTotalSupplyOnInsertAllBurn_r18(uint b) private    {
      uint m = allMint.n;
      uint n = m-b;
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateAllowanceOnInsertAllowanceTotal_r26(address o,address s,uint m) private    {
      AllowanceTotalTuple memory toDelete = allowanceTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteAllowanceTotal_r26(o,s,toDelete.m);
      }
      SpentTotalTuple memory spentTotalTuple = spentTotal[o][s];
      uint l = spentTotalTuple.m;
      uint n = m-l;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateBalanceOfOnIncrementTotalBurn_r14(address p,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalBurn[p].n,_delta);
      updateBalanceOfOnInsertTotalBurn_r14(p,newValue);
  }
  function updateBalanceOfOnDeleteFreezeOf_r14(address p,uint f) private    {
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      TotalBurnTuple memory totalBurnTuple = totalBurn[p];
      uint m = totalBurnTuple.n;
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalMintTuple memory totalMintTuple = totalMint[p];
      uint n = totalMintTuple.n;
      uint s = (((n+i)-m)-o)-f;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      if(s==balanceOfTuple.n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateAllowanceOnIncrementSpentTotal_r26(address o,address s,int l) private    {
      int _delta = int(l);
      uint newValue = updateuintByint(spentTotal[o][s].m,_delta);
      updateAllowanceOnInsertSpentTotal_r26(o,s,newValue);
  }
  function updateOwnerOnInsertConstructor_r9() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateBalanceOfOnIncrementTotalOut_r14(address p,int o) private    {
      int _delta = int(o);
      uint newValue = updateuintByint(totalOut[p].n,_delta);
      updateBalanceOfOnInsertTotalOut_r14(p,newValue);
  }
  function updateWithdrawEtherOnInsertRecv_withdrawEther_r23(uint n) private   returns (bool) {
      address p = owner.p;
      if(p==msg.sender) {
        updateSendOnInsertWithdrawEther_r3(p,n);
        emit WithdrawEther(p,n);
        return true;
      }
      return false;
  }
  function updateAllowanceOnDeleteAllowanceTotal_r26(address o,address s,uint m) private    {
      SpentTotalTuple memory spentTotalTuple = spentTotal[o][s];
      uint l = spentTotalTuple.m;
      uint n = m-l;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      if(n==allowanceTuple.n) {
        allowance[o][s] = AllowanceTuple(0,false);
      }
  }
  function updateBalanceOfOnDeleteTotalIn_r14(address p,uint i) private    {
      FreezeOfTuple memory freezeOfTuple = freezeOf[p];
      uint f = freezeOfTuple.n;
      TotalBurnTuple memory totalBurnTuple = totalBurn[p];
      uint m = totalBurnTuple.n;
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalMintTuple memory totalMintTuple = totalMint[p];
      uint n = totalMintTuple.n;
      uint s = (((n+i)-m)-o)-f;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      if(s==balanceOfTuple.n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateAllBurnOnInsertBurn_r30(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r18(delta0);
      allBurn.n += n;
  }
  function updateUnfreezeOnInsertRecv_unfreeze_r6(uint n) private   returns (bool) {
      address p = msg.sender;
      FreezeOfTuple memory freezeOfTuple = freezeOf[p];
      uint m = freezeOfTuple.n;
      if(n<=m && n>0) {
        updateTotalUnfreezeOnInsertUnfreeze_r13(p,n);
        emit Unfreeze(p,n);
        return true;
      }
      return false;
  }
  function updateTransferOnInsertTransferFrom_r1(address o,address r,uint n) private    {
      updateTotalInOnInsertTransfer_r7(r,n);
      updateTotalOutOnInsertTransfer_r20(o,n);
      emit Transfer(o,r,n);
  }
  function updateFreezeOfOnIncrementTotalUnfreeze_r12(address p,int u) private    {
      int _delta = int(u);
      uint newValue = updateuintByint(totalUnfreeze[p].n,_delta);
      updateFreezeOfOnInsertTotalUnfreeze_r12(p,newValue);
  }
  function updateTransferOnInsertRecv_transfer_r19(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[s];
      uint m = balanceOfTuple.n;
      if(n<=m) {
        updateTotalOutOnInsertTransfer_r20(s,n);
        updateTotalInOnInsertTransfer_r7(r,n);
        emit Transfer(s,r,n);
        return true;
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r25(uint n) private    {
      // Empty()
  }
  function updateBalanceOfOnDeleteTotalOut_r14(address p,uint o) private    {
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      FreezeOfTuple memory freezeOfTuple = freezeOf[p];
      uint f = freezeOfTuple.n;
      TotalBurnTuple memory totalBurnTuple = totalBurn[p];
      uint m = totalBurnTuple.n;
      TotalMintTuple memory totalMintTuple = totalMint[p];
      uint n = totalMintTuple.n;
      uint s = (((n+i)-m)-o)-f;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      if(s==balanceOfTuple.n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateTotalSupplyOnIncrementAllBurn_r18(int b) private    {
      int _delta = int(b);
      uint newValue = updateuintByint(allBurn.n,_delta);
      updateTotalSupplyOnInsertAllBurn_r18(newValue);
  }
  function updateTotalInOnInsertTransfer_r7(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r14(p,delta0);
      totalIn[p].n += n;
  }
  function updateTotalUnfreezeOnInsertUnfreeze_r13(address p,uint n) private    {
      int delta2 = int(n);
      updateFreezeOfOnIncrementTotalUnfreeze_r12(p,delta2);
      totalUnfreeze[p].n += n;
  }
  function updateAllowanceOnIncrementAllowanceTotal_r26(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowanceTotal[o][s].m,_delta);
      updateAllowanceOnInsertAllowanceTotal_r26(o,s,newValue);
  }
  function updateAllowanceOnDeleteSpentTotal_r26(address o,address s,uint l) private    {
      AllowanceTotalTuple memory allowanceTotalTuple = allowanceTotal[o][s];
      uint m = allowanceTotalTuple.m;
      uint n = m-l;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      if(n==allowanceTuple.n) {
        allowance[o][s] = AllowanceTuple(0,false);
      }
  }
  function updateBalanceOfOnInsertConstructor_r4(uint n) private    {
      address s = msg.sender;
      balanceOf[s] = BalanceOfTuple(n,true);
  }
  function updateFreezeOfOnIncrementTotalFreeze_r12(address p,int f) private    {
      int _delta = int(f);
      uint newValue = updateuintByint(totalFreeze[p].n,_delta);
      updateFreezeOfOnInsertTotalFreeze_r12(p,newValue);
  }
  function updateBalanceOfOnDeleteTotalBurn_r14(address p,uint m) private    {
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      FreezeOfTuple memory freezeOfTuple = freezeOf[p];
      uint f = freezeOfTuple.n;
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalMintTuple memory totalMintTuple = totalMint[p];
      uint n = totalMintTuple.n;
      uint s = (((n+i)-m)-o)-f;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      if(s==balanceOfTuple.n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r28(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      uint d = n-m;
      updateAllowanceTotalOnInsertIncreaseAllowance_r8(o,s,d);
      emit IncreaseAllowance(o,s,d);
      return true;
      return false;
  }
  function updateSpentTotalOnInsertTransferFrom_r22(address o,address s,uint n) private    {
      int delta1 = int(n);
      updateAllowanceOnIncrementSpentTotal_r26(o,s,delta1);
      spentTotal[o][s].m += n;
  }
  function updateBalanceOfOnIncrementTotalIn_r14(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(totalIn[p].n,_delta);
      updateBalanceOfOnInsertTotalIn_r14(p,newValue);
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r8(address o,address s,uint n) private    {
      int delta2 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r26(o,s,delta2);
      allowanceTotal[o][s].m += n;
  }
  function updateBalanceOfOnInsertTotalOut_r14(address p,uint o) private    {
      TotalOutTuple memory toDelete = totalOut[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalOut_r14(p,toDelete.n);
      }
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      FreezeOfTuple memory freezeOfTuple = freezeOf[p];
      uint f = freezeOfTuple.n;
      TotalBurnTuple memory totalBurnTuple = totalBurn[p];
      uint m = totalBurnTuple.n;
      TotalMintTuple memory totalMintTuple = totalMint[p];
      uint n = totalMintTuple.n;
      uint s = (((n+i)-m)-o)-f;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateTotalOutOnInsertTransfer_r20(address p,uint n) private    {
      int delta2 = int(n);
      updateBalanceOfOnIncrementTotalOut_r14(p,delta2);
      totalOut[p].n += n;
  }
  function updateBurnOnInsertRecv_burn_r15(uint n) private   returns (bool) {
      address p = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint m = balanceOfTuple.n;
      if(p!=address(0) && n<=m) {
        updateTotalBurnOnInsertBurn_r16(p,n);
        updateAllBurnOnInsertBurn_r30(n);
        emit Burn(p,n);
        return true;
      }
      return false;
  }
  function updateSendOnInsertWithdrawEther_r3(address p,uint n) private    {
      payable(p).send(n);
  }
  function updateTotalSupplyOnInsertConstructor_r5(uint n) private    {
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateFreezeOfOnDeleteTotalUnfreeze_r12(address p,uint u) private    {
      TotalFreezeTuple memory totalFreezeTuple = totalFreeze[p];
      uint f = totalFreezeTuple.n;
      uint n = f-u;
      updateBalanceOfOnDeleteFreezeOf_r14(p,n);
      FreezeOfTuple memory freezeOfTuple = freezeOf[p];
      if(n==freezeOfTuple.n) {
        freezeOf[p] = FreezeOfTuple(0,false);
      }
  }
  function updateFreezeOfOnInsertTotalUnfreeze_r12(address p,uint u) private    {
      TotalUnfreezeTuple memory toDelete = totalUnfreeze[p];
      if(toDelete._valid==true) {
        updateFreezeOfOnDeleteTotalUnfreeze_r12(p,toDelete.n);
      }
      TotalFreezeTuple memory totalFreezeTuple = totalFreeze[p];
      uint f = totalFreezeTuple.n;
      uint n = f-u;
      updateBalanceOfOnInsertFreezeOf_r14(p,n);
      freezeOf[p] = FreezeOfTuple(n,true);
  }
  function updateBalanceOfOnInsertFreezeOf_r14(address p,uint f) private    {
      FreezeOfTuple memory toDelete = freezeOf[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteFreezeOf_r14(p,toDelete.n);
      }
      TotalInTuple memory totalInTuple = totalIn[p];
      uint i = totalInTuple.n;
      TotalBurnTuple memory totalBurnTuple = totalBurn[p];
      uint m = totalBurnTuple.n;
      TotalOutTuple memory totalOutTuple = totalOut[p];
      uint o = totalOutTuple.n;
      TotalMintTuple memory totalMintTuple = totalMint[p];
      uint n = totalMintTuple.n;
      uint s = (((n+i)-m)-o)-f;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
}