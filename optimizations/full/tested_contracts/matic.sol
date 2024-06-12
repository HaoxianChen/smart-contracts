contract Matic {
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
  struct DecreaseAllowanceTotalTuple {
    uint m;
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
  struct IsPauserTuple {
    bool b;
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
  mapping(address=>mapping(address=>DecreaseAllowanceTotalTuple)) decreaseAllowanceTotal;
  mapping(address=>TotalMintTuple) totalMint;
  TotalSupplyTuple totalSupply;
  AllMintTuple allMint;
  mapping(address=>IsPauserTuple) isPauser;
  mapping(address=>mapping(address=>AllowanceTotalTuple)) allowanceTotal;
  mapping(address=>mapping(address=>SpentTotalTuple)) spentTotal;
  mapping(address=>BalanceOfTuple) balanceOf;
  AllBurnTuple allBurn;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  PausedTuple paused;
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event DecreaseAllowance(address p,address s,uint n);
  event IncreaseAllowance(address p,address s,uint n);
  event IsPauser(address p,bool b);
  event Transfer(address from,address to,uint amount);
  event Paused(bool b);
  event TransferFrom(address from,address to,address spender,uint amount);
  constructor(uint n) public {
    updatePausedOnInsertConstructor_r25();
    updateBalanceOfOnInsertConstructor_r18(n);
    updateIsPauserOnInsertConstructor_r22();
    updateTotalBalancesOnInsertConstructor_r32(n);
    updateTotalMintOnInsertConstructor_r20(n);
    updateAllMintOnInsertConstructor_r12(n);
    updateTotalSupplyOnInsertConstructor_r28(n);
    updateOwnerOnInsertConstructor_r6();
  }
  function addPauser(address p) public    {
      bool r5 = updateIsPauserOnInsertRecv_addPauser_r5(p);
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function renouncePauser() public    {
      bool r0 = updateIsPauserOnInsertRecv_renouncePauser_r0();
      if(r0==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r2 = updateTransferFromOnInsertRecv_transferFrom_r2(from,to,amount);
      if(r2==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public    {
      bool r11 = updateTransferOnInsertRecv_transfer_r11(to,amount);
      if(r11==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address s,uint n) public    {
      bool r31 = updateIncreaseAllowanceOnInsertRecv_approve_r31(s,n);
      if(r31==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public    {
      bool r3 = updateMintOnInsertRecv_mint_r3(p,amount);
      if(r3==false) {
        revert("Rule condition failed");
      }
  }
  function unpause() public    {
      bool r13 = updatePausedOnInsertRecv_unpause_r13();
      if(r13==false) {
        revert("Rule condition failed");
      }
  }
  function increaseAllowance(address p,uint n) public    {
      bool r10 = updateIncreaseAllowanceOnInsertRecv_increaseApproval_r10(p,n);
      if(r10==false) {
        revert("Rule condition failed");
      }
  }
  function decreaseAllowance(address p,uint n) public    {
      bool r17 = updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r17(p,n);
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
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function pause() public    {
      bool r21 = updatePausedOnInsertRecv_pause_r21();
      if(r21==false) {
        revert("Rule condition failed");
      }
  }
  function updateAllMintOnInsertMint_r9(uint n) private    {
      int delta1 = int(n);
      updateTotalSupplyOnIncrementAllMint_r16(delta1);
      allMint.n += n;
  }
  function updateTotalInOnInsertTransfer_r7(address p,uint n) private    {
      int delta1 = int(n);
      updateBalanceOfOnIncrementTotalIn_r26(p,delta1);
      totalIn[p].n += n;
  }
  function updateTransferOnInsertTransferFrom_r1(address o,address r,uint n) private    {
      updateTotalInOnInsertTransfer_r7(r,n);
      updateTotalOutOnInsertTransfer_r23(o,n);
      emit Transfer(o,r,n);
  }
  function updatePausedOnInsertConstructor_r25() private    {
      paused = PausedTuple(false,true);
      emit Paused(false);
  }
  function updateIncreaseAllowanceOnInsertRecv_increaseApproval_r10(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      updateAllowanceTotalOnInsertIncreaseAllowance_r33(o,s,n);
      emit IncreaseAllowance(o,s,n);
      return true;
      return false;
  }
  function updateIsPauserOnInsertConstructor_r22() private    {
      address s = msg.sender;
      isPauser[s] = IsPauserTuple(true,true);
      emit IsPauser(s,true);
  }
  function updateTransferOnInsertRecv_transfer_r11(address r,uint n) private   returns (bool) {
      if(false==paused.b) {
        address s = msg.sender;
        BalanceOfTuple memory balanceOfTuple = balanceOf[s];
        uint m = balanceOfTuple.n;
        if(n<=m) {
          updateTotalOutOnInsertTransfer_r23(s,n);
          updateTotalInOnInsertTransfer_r7(r,n);
          emit Transfer(s,r,n);
          return true;
        }
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r32(uint n) private    {
      // Empty()
  }
  function updateBalanceOfOnInsertTotalMint_r26(address p,uint n) private    {
      TotalMintTuple memory toDelete = totalMint[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalMint_r26(p,toDelete.n);
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
  function updateBalanceOfOnIncrementTotalBurn_r26(address p,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalBurn[p].n,_delta);
      updateBalanceOfOnInsertTotalBurn_r26(p,newValue);
  }
  function updateTotalSupplyOnIncrementAllMint_r16(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allMint.n,_delta);
      updateTotalSupplyOnInsertAllMint_r16(newValue);
  }
  function updateTotalSupplyOnInsertConstructor_r28(uint n) private    {
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateDecreaseAllowanceTotalOnInsertDecreaseAllowance_r4(address o,address s,uint n) private    {
      int delta2 = int(n);
      updateAllowanceOnIncrementDecreaseAllowanceTotal_r29(o,s,delta2);
      decreaseAllowanceTotal[o][s].m += n;
  }
  function updateTotalBurnOnInsertBurn_r14(address p,uint n) private    {
      int delta2 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r26(p,delta2);
      totalBurn[p].n += n;
  }
  function updateAllowanceOnDeleteSpentTotal_r29(address o,address s,uint l) private    {
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
  function updateOwnerOnInsertConstructor_r6() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updatePausedOnInsertRecv_unpause_r13() private   returns (bool) {
      if(true==paused.b) {
        address s = msg.sender;
        IsPauserTuple memory isPauserTuple = isPauser[s];
        if(true==isPauserTuple.b) {
          paused = PausedTuple(false,true);
          emit Paused(false);
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnDeleteTotalBurn_r26(address p,uint m) private    {
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
  function updateTotalSupplyOnInsertAllMint_r16(uint m) private    {
      uint b = allBurn.n;
      uint n = m-b;
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateBalanceOfOnDeleteTotalIn_r26(address p,uint i) private    {
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
  function updateBalanceOfOnInsertTotalBurn_r26(address p,uint m) private    {
      TotalBurnTuple memory toDelete = totalBurn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalBurn_r26(p,toDelete.n);
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
  function updateBalanceOfOnInsertConstructor_r18(uint n) private    {
      address s = msg.sender;
      balanceOf[s] = BalanceOfTuple(n,true);
  }
  function updateAllowanceOnInsertAllowanceTotal_r29(address o,address s,uint m) private    {
      AllowanceTotalTuple memory toDelete = allowanceTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteAllowanceTotal_r29(o,s,toDelete.m);
      }
      DecreaseAllowanceTotalTuple memory decreaseAllowanceTotalTuple = decreaseAllowanceTotal[o][s];
      uint d = decreaseAllowanceTotalTuple.m;
      SpentTotalTuple memory spentTotalTuple = spentTotal[o][s];
      uint l = spentTotalTuple.m;
      uint n = (m-l)-d;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateBalanceOfOnIncrementTotalOut_r26(address p,int o) private    {
      int _delta = int(o);
      uint newValue = updateuintByint(totalOut[p].n,_delta);
      updateBalanceOfOnInsertTotalOut_r26(p,newValue);
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r31(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      uint d = n-m;
      updateAllowanceTotalOnInsertIncreaseAllowance_r33(o,s,d);
      emit IncreaseAllowance(o,s,d);
      return true;
      return false;
  }
  function updateAllowanceOnIncrementSpentTotal_r29(address o,address s,int l) private    {
      int _delta = int(l);
      uint newValue = updateuintByint(spentTotal[o][s].m,_delta);
      updateAllowanceOnInsertSpentTotal_r29(o,s,newValue);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateTotalOutOnInsertTransfer_r23(address p,uint n) private    {
      int delta1 = int(n);
      updateBalanceOfOnIncrementTotalOut_r26(p,delta1);
      totalOut[p].n += n;
  }
  function updateTotalMintOnInsertConstructor_r20(uint n) private    {
      address s = msg.sender;
      updateBalanceOfOnInsertTotalMint_r26(s,n);
      totalMint[s] = TotalMintTuple(n,true);
  }
  function updateSpentTotalOnInsertTransferFrom_r27(address o,address s,uint n) private    {
      int delta1 = int(n);
      updateAllowanceOnIncrementSpentTotal_r29(o,s,delta1);
      spentTotal[o][s].m += n;
  }
  function updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r17(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      if(m>=n) {
        updateDecreaseAllowanceTotalOnInsertDecreaseAllowance_r4(o,s,n);
        emit DecreaseAllowance(o,s,n);
        return true;
      }
      return false;
  }
  function updateTotalSupplyOnInsertAllBurn_r16(uint b) private    {
      uint m = allMint.n;
      uint n = m-b;
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateBalanceOfOnIncrementTotalIn_r26(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(totalIn[p].n,_delta);
      updateBalanceOfOnInsertTotalIn_r26(p,newValue);
  }
  function updateBalanceOfOnDeleteTotalOut_r26(address p,uint o) private    {
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
  function updateBalanceOfOnIncrementTotalMint_r26(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(totalMint[p].n,_delta);
      updateBalanceOfOnInsertTotalMint_r26(p,newValue);
  }
  function updateIsPauserOnInsertRecv_addPauser_r5(address p) private   returns (bool) {
      address s = msg.sender;
      IsPauserTuple memory isPauserTuple = isPauser[s];
      if(true==isPauserTuple.b) {
        isPauser[p] = IsPauserTuple(true,true);
        emit IsPauser(p,true);
        return true;
      }
      return false;
  }
  function updateAllMintOnInsertConstructor_r12(uint n) private    {
      updateTotalSupplyOnInsertAllMint_r16(n);
      allMint = AllMintTuple(n,true);
  }
  function updateAllowanceOnInsertSpentTotal_r29(address o,address s,uint l) private    {
      SpentTotalTuple memory toDelete = spentTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteSpentTotal_r29(o,s,toDelete.m);
      }
      DecreaseAllowanceTotalTuple memory decreaseAllowanceTotalTuple = decreaseAllowanceTotal[o][s];
      uint d = decreaseAllowanceTotalTuple.m;
      AllowanceTotalTuple memory allowanceTotalTuple = allowanceTotal[o][s];
      uint m = allowanceTotalTuple.m;
      uint n = (m-l)-d;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateAllowanceOnDeleteAllowanceTotal_r29(address o,address s,uint m) private    {
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
  function updateAllowanceTotalOnInsertIncreaseAllowance_r33(address o,address s,uint n) private    {
      int delta2 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r29(o,s,delta2);
      allowanceTotal[o][s].m += n;
  }
  function updateIsPauserOnInsertRecv_renouncePauser_r0() private   returns (bool) {
      address s = msg.sender;
      IsPauserTuple memory isPauserTuple = isPauser[s];
      if(true==isPauserTuple.b) {
        isPauser[s] = IsPauserTuple(false,true);
        emit IsPauser(s,false);
        return true;
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r2(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      if(false==paused.b) {
        BalanceOfTuple memory balanceOfTuple = balanceOf[o];
        uint m = balanceOfTuple.n;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        uint k = allowanceTuple.n;
        if(m>=n && k>=n) {
          updateSpentTotalOnInsertTransferFrom_r27(o,s,n);
          updateTransferOnInsertTransferFrom_r1(o,r,n);
          emit TransferFrom(o,r,s,n);
          return true;
        }
      }
      return false;
  }
  function updateTotalMintOnInsertMint_r15(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalMint_r26(p,delta0);
      totalMint[p].n += n;
  }
  function updateAllowanceOnIncrementAllowanceTotal_r29(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowanceTotal[o][s].m,_delta);
      updateAllowanceOnInsertAllowanceTotal_r29(o,s,newValue);
  }
  function updateBurnOnInsertRecv_burn_r8(address p,uint n) private   returns (bool) {
      address s = msg.sender;
      if(false==paused.b) {
        if(s==owner.p) {
          BalanceOfTuple memory balanceOfTuple = balanceOf[p];
          uint m = balanceOfTuple.n;
          if(p!=address(0) && n<=m) {
            updateTotalBurnOnInsertBurn_r14(p,n);
            updateAllBurnOnInsertBurn_r30(n);
            emit Burn(p,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnDeleteTotalMint_r26(address p,uint n) private    {
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
  function updatePausedOnInsertRecv_pause_r21() private   returns (bool) {
      if(false==paused.b) {
        address s = msg.sender;
        IsPauserTuple memory isPauserTuple = isPauser[s];
        if(true==isPauserTuple.b) {
          paused = PausedTuple(true,true);
          emit Paused(true);
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnInsertTotalIn_r26(address p,uint i) private    {
      TotalInTuple memory toDelete = totalIn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalIn_r26(p,toDelete.n);
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
  function updateAllowanceOnDeleteDecreaseAllowanceTotal_r29(address o,address s,uint d) private    {
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
  function updateMintOnInsertRecv_mint_r3(address p,uint n) private   returns (bool) {
      if(false==paused.b) {
        address s = owner.p;
        if(s==msg.sender) {
          if(p!=address(0)) {
            updateTotalMintOnInsertMint_r15(p,n);
            updateAllMintOnInsertMint_r9(n);
            emit Mint(p,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateAllowanceOnInsertDecreaseAllowanceTotal_r29(address o,address s,uint d) private    {
      DecreaseAllowanceTotalTuple memory toDelete = decreaseAllowanceTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteDecreaseAllowanceTotal_r29(o,s,toDelete.m);
      }
      SpentTotalTuple memory spentTotalTuple = spentTotal[o][s];
      uint l = spentTotalTuple.m;
      AllowanceTotalTuple memory allowanceTotalTuple = allowanceTotal[o][s];
      uint m = allowanceTotalTuple.m;
      uint n = (m-l)-d;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateAllBurnOnInsertBurn_r30(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r16(delta0);
      allBurn.n += n;
  }
  function updateAllowanceOnIncrementDecreaseAllowanceTotal_r29(address o,address s,int d) private    {
      int _delta = int(d);
      uint newValue = updateuintByint(decreaseAllowanceTotal[o][s].m,_delta);
      updateAllowanceOnInsertDecreaseAllowanceTotal_r29(o,s,newValue);
  }
  function updateTotalSupplyOnIncrementAllBurn_r16(int b) private    {
      int _delta = int(b);
      uint newValue = updateuintByint(allBurn.n,_delta);
      updateTotalSupplyOnInsertAllBurn_r16(newValue);
  }
  function updateBalanceOfOnInsertTotalOut_r26(address p,uint o) private    {
      TotalOutTuple memory toDelete = totalOut[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalOut_r26(p,toDelete.n);
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
}