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
  event IncreaseAllowance(address p,address s,uint n);
  event IsPauser(address p,bool b);
  event Transfer(address from,address to,uint amount);
  event Paused(bool b);
  event TransferFrom(address from,address to,address spender,uint amount);
  constructor(uint n) public {
    updateBalanceOfOnInsertConstructor_r4(n);
    updateTotalSupplyOnInsertConstructor_r24(n);
    updateTotalMintOnInsertConstructor_r18(n);
    updateOwnerOnInsertConstructor_r7();
    updatePausedOnInsertConstructor_r21();
    updateTotalBalancesOnInsertConstructor_r29(n);
    updateAllMintOnInsertConstructor_r13(n);
    updateIsPauserOnInsertConstructor_r5();
  }
  function burn(address p,uint amount) public    {
      bool r9 = updateBurnOnInsertRecv_burn_r9(p,amount);
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function approve(address s,uint n) public    {
      bool r28 = updateIncreaseAllowanceOnInsertRecv_approve_r28(s,n);
      if(r28==false) {
        revert("Rule condition failed");
      }
  }
  function addPauser(address p) public    {
      bool r6 = updateIsPauserOnInsertRecv_addPauser_r6(p);
      if(r6==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public    {
      bool r10 = updateMintOnInsertRecv_mint_r10(p,amount);
      if(r10==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function unpause() public    {
      bool r26 = updatePausedOnInsertRecv_unpause_r26();
      if(r26==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public    {
      bool r12 = updateTransferOnInsertRecv_transfer_r12(to,amount);
      if(r12==false) {
        revert("Rule condition failed");
      }
  }
  function renouncePauser(address p) public    {
      bool r11 = updateIsPauserOnInsertRecv_renouncePauser_r11(p);
      if(r11==false) {
        revert("Rule condition failed");
      }
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r1 = updateTransferFromOnInsertRecv_transferFrom_r1(from,to,amount);
      if(r1==false) {
        revert("Rule condition failed");
      }
  }
  function pause() public    {
      bool r2 = updatePausedOnInsertRecv_pause_r2();
      if(r2==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function updateBalanceOfOnIncrementTotalOut_r22(address p,int o) private    {
      int _delta = int(o);
      uint newValue = updateuintByint(totalOut[p].n,_delta);
      updateBalanceOfOnInsertTotalOut_r22(p,newValue);
  }
  function updateTransferOnInsertRecv_transfer_r12(address r,uint n) private   returns (bool) {
      if(false==paused.b) {
        address s = msg.sender;
        BalanceOfTuple memory balanceOfTuple = balanceOf[s];
        uint m = balanceOfTuple.n;
        if(n<=m) {
          updateTotalInOnInsertTransfer_r8(r,n);
          updateTotalOutOnInsertTransfer_r19(s,n);
          emit Transfer(s,r,n);
          return true;
        }
      }
      return false;
  }
  function updateAllowanceOnIncrementSpentTotal_r25(address o,address s,int l) private    {
      int _delta = int(l);
      uint newValue = updateuintByint(spentTotal[o][s].m,_delta);
      updateAllowanceOnInsertSpentTotal_r25(o,s,newValue);
  }
  function updateAllowanceOnIncrementAllowanceTotal_r25(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowanceTotal[o][s].m,_delta);
      updateAllowanceOnInsertAllowanceTotal_r25(o,s,newValue);
  }
  function updateBalanceOfOnIncrementTotalMint_r22(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(totalMint[p].n,_delta);
      updateBalanceOfOnInsertTotalMint_r22(p,newValue);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r1(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      if(false==paused.b) {
        BalanceOfTuple memory balanceOfTuple = balanceOf[o];
        uint m = balanceOfTuple.n;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        uint k = allowanceTuple.n;
        if(m>=n && k>=n) {
          updateTransferOnInsertTransferFrom_r0(o,r,n);
          updateSpentTotalOnInsertTransferFrom_r23(o,s,n);
          emit TransferFrom(o,r,s,n);
          return true;
        }
      }
      return false;
  }
  function updateTotalSupplyOnInsertAllBurn_r16(uint b) private    {
      uint m = allMint.n;
      uint n = m-b;
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateBalanceOfOnInsertTotalOut_r22(address p,uint o) private    {
      TotalOutTuple memory toDelete = totalOut[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalOut_r22(p,toDelete.n);
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
  function updatePausedOnInsertRecv_pause_r2() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        paused = PausedTuple(true,true);
        emit Paused(true);
        return true;
      }
      return false;
  }
  function updateAllowanceOnInsertAllowanceTotal_r25(address o,address s,uint m) private    {
      AllowanceTotalTuple memory toDelete = allowanceTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteAllowanceTotal_r25(o,s,toDelete.m);
      }
      SpentTotalTuple memory spentTotalTuple = spentTotal[o][s];
      uint l = spentTotalTuple.m;
      uint n = m-l;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateBalanceOfOnIncrementTotalBurn_r22(address p,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalBurn[p].n,_delta);
      updateBalanceOfOnInsertTotalBurn_r22(p,newValue);
  }
  function updateTransferOnInsertTransferFrom_r0(address o,address r,uint n) private    {
      updateTotalInOnInsertTransfer_r8(r,n);
      updateTotalOutOnInsertTransfer_r19(o,n);
      emit Transfer(o,r,n);
  }
  function updateBurnOnInsertRecv_burn_r9(address p,uint n) private   returns (bool) {
      address s = msg.sender;
      if(false==paused.b) {
        if(s==owner.p) {
          BalanceOfTuple memory balanceOfTuple = balanceOf[p];
          uint m = balanceOfTuple.n;
          if(p!=address(0) && n<=m) {
            updateTotalBurnOnInsertBurn_r14(p,n);
            updateAllBurnOnInsertBurn_r27(n);
            emit Burn(p,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateTotalSupplyOnIncrementAllMint_r16(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allMint.n,_delta);
      updateTotalSupplyOnInsertAllMint_r16(newValue);
  }
  function updateMintOnInsertRecv_mint_r10(address p,uint n) private   returns (bool) {
      if(false==paused.b) {
        address s = owner.p;
        if(s==msg.sender) {
          if(p!=address(0)) {
            updateAllMintOnInsertMint_r3(n);
            updateTotalMintOnInsertMint_r15(p,n);
            emit Mint(p,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnInsertTotalBurn_r22(address p,uint m) private    {
      TotalBurnTuple memory toDelete = totalBurn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalBurn_r22(p,toDelete.n);
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
  function updateAllowanceOnDeleteSpentTotal_r25(address o,address s,uint l) private    {
      AllowanceTotalTuple memory allowanceTotalTuple = allowanceTotal[o][s];
      uint m = allowanceTotalTuple.m;
      uint n = m-l;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      if(n==allowanceTuple.n) {
        allowance[o][s] = AllowanceTuple(0,false);
      }
  }
  function updateTotalMintOnInsertMint_r15(address p,uint n) private    {
      int delta1 = int(n);
      updateBalanceOfOnIncrementTotalMint_r22(p,delta1);
      totalMint[p].n += n;
  }
  function updateOwnerOnInsertConstructor_r7() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateAllowanceOnDeleteAllowanceTotal_r25(address o,address s,uint m) private    {
      SpentTotalTuple memory spentTotalTuple = spentTotal[o][s];
      uint l = spentTotalTuple.m;
      uint n = m-l;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      if(n==allowanceTuple.n) {
        allowance[o][s] = AllowanceTuple(0,false);
      }
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateBalanceOfOnIncrementTotalIn_r22(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(totalIn[p].n,_delta);
      updateBalanceOfOnInsertTotalIn_r22(p,newValue);
  }
  function updatePausedOnInsertRecv_unpause_r26() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        paused = PausedTuple(false,true);
        emit Paused(false);
        return true;
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r29(uint n) private    {
      // Empty()
  }
  function updateBalanceOfOnDeleteTotalBurn_r22(address p,uint m) private    {
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
  function updateIsPauserOnInsertConstructor_r5() private    {
      address s = msg.sender;
      isPauser[s] = IsPauserTuple(true,true);
      emit IsPauser(s,true);
  }
  function updateTotalMintOnInsertConstructor_r18(uint n) private    {
      address s = msg.sender;
      updateBalanceOfOnInsertTotalMint_r22(s,n);
      totalMint[s] = TotalMintTuple(n,true);
  }
  function updateAllBurnOnInsertBurn_r27(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r16(delta0);
      allBurn.n += n;
  }
  function updateTotalOutOnInsertTransfer_r19(address p,uint n) private    {
      int delta1 = int(n);
      updateBalanceOfOnIncrementTotalOut_r22(p,delta1);
      totalOut[p].n += n;
  }
  function updateBalanceOfOnInsertConstructor_r4(uint n) private    {
      address s = msg.sender;
      balanceOf[s] = BalanceOfTuple(n,true);
  }
  function updateAllMintOnInsertConstructor_r13(uint n) private    {
      updateTotalSupplyOnInsertAllMint_r16(n);
      allMint = AllMintTuple(n,true);
  }
  function updateTotalInOnInsertTransfer_r8(address p,uint n) private    {
      int delta1 = int(n);
      updateBalanceOfOnIncrementTotalIn_r22(p,delta1);
      totalIn[p].n += n;
  }
  function updateTotalSupplyOnInsertAllMint_r16(uint m) private    {
      uint b = allBurn.n;
      uint n = m-b;
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r30(address o,address s,uint n) private    {
      int delta1 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r25(o,s,delta1);
      allowanceTotal[o][s].m += n;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r28(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      uint d = n-m;
      updateAllowanceTotalOnInsertIncreaseAllowance_r30(o,s,d);
      emit IncreaseAllowance(o,s,d);
      return true;
      return false;
  }
  function updateAllMintOnInsertMint_r3(uint n) private    {
      int delta1 = int(n);
      updateTotalSupplyOnIncrementAllMint_r16(delta1);
      allMint.n += n;
  }
  function updatePausedOnInsertConstructor_r21() private    {
      paused = PausedTuple(false,true);
      emit Paused(false);
  }
  function updateTotalBurnOnInsertBurn_r14(address p,uint n) private    {
      int delta2 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r22(p,delta2);
      totalBurn[p].n += n;
  }
  function updateBalanceOfOnDeleteTotalOut_r22(address p,uint o) private    {
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
  function updateBalanceOfOnInsertTotalIn_r22(address p,uint i) private    {
      TotalInTuple memory toDelete = totalIn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalIn_r22(p,toDelete.n);
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
  function updateAllowanceOnInsertSpentTotal_r25(address o,address s,uint l) private    {
      SpentTotalTuple memory toDelete = spentTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteSpentTotal_r25(o,s,toDelete.m);
      }
      AllowanceTotalTuple memory allowanceTotalTuple = allowanceTotal[o][s];
      uint m = allowanceTotalTuple.m;
      uint n = m-l;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateIsPauserOnInsertRecv_renouncePauser_r11(address p) private   returns (bool) {
      address s = msg.sender;
      IsPauserTuple memory isPauserTuple = isPauser[s];
      if(true==isPauserTuple.b) {
        isPauser[p] = IsPauserTuple(false,true);
        emit IsPauser(p,false);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnDeleteTotalMint_r22(address p,uint n) private    {
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
  function updateBalanceOfOnInsertTotalMint_r22(address p,uint n) private    {
      TotalMintTuple memory toDelete = totalMint[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalMint_r22(p,toDelete.n);
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
  function updateIsPauserOnInsertRecv_addPauser_r6(address p) private   returns (bool) {
      address s = msg.sender;
      IsPauserTuple memory isPauserTuple = isPauser[s];
      if(true==isPauserTuple.b) {
        isPauser[p] = IsPauserTuple(true,true);
        emit IsPauser(p,true);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnDeleteTotalIn_r22(address p,uint i) private    {
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
  function updateSpentTotalOnInsertTransferFrom_r23(address o,address s,uint n) private    {
      int delta2 = int(n);
      updateAllowanceOnIncrementSpentTotal_r25(o,s,delta2);
      spentTotal[o][s].m += n;
  }
  function updateTotalSupplyOnIncrementAllBurn_r16(int b) private    {
      int _delta = int(b);
      uint newValue = updateuintByint(allBurn.n,_delta);
      updateTotalSupplyOnInsertAllBurn_r16(newValue);
  }
  function updateTotalSupplyOnInsertConstructor_r24(uint n) private    {
      totalSupply = TotalSupplyTuple(n,true);
  }
}