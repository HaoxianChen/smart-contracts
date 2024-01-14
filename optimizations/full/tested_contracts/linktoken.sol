contract Linktoken {
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
  mapping(address=>TotalInTuple) totalIn;
  mapping(address=>TotalOutTuple) totalOut;
  mapping(address=>TotalBurnTuple) totalBurn;
  OwnerTuple owner;
  mapping(address=>mapping(address=>DecreaseAllowanceTotalTuple)) decreaseAllowanceTotal;
  mapping(address=>TotalMintTuple) totalMint;
  TotalSupplyTuple totalSupply;
  AllMintTuple allMint;
  mapping(address=>mapping(address=>AllowanceTotalTuple)) allowanceTotal;
  mapping(address=>mapping(address=>SpentTotalTuple)) spentTotal;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  mapping(address=>BalanceOfTuple) balanceOf;
  AllBurnTuple allBurn;
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event DecreaseAllowance(address p,address s,uint n);
  event IncreaseAllowance(address p,address s,uint n);
  event Transfer(address from,address to,uint amount);
  constructor(uint n) public {
    updateBalanceOfOnInsertConstructor_r5(n);
    updateTotalSupplyOnInsertConstructor_r23(n);
    updateOwnerOnInsertConstructor_r8();
    updateTotalBalancesOnInsertConstructor_r27(n);
    updateTotalInOnInsertConstructor_r13(n);
    updateTotalMintOnInsertConstructor_r19(n);
  }
  function burn(address p,uint amount) public    {
      bool r3 = updateBurnOnInsertRecv_burn_r3(p,amount);
      if(r3==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address s,uint n) public    {
      bool r26 = updateIncreaseAllowanceOnInsertRecv_approve_r26(s,n);
      if(r26==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public    {
      bool r9 = updateMintOnInsertRecv_mint_r9(p,amount);
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function increaseApproval(address p,uint n) public    {
      bool r12 = updateIncreaseAllowanceOnInsertRecv_increaseApproval_r12(p,n);
      if(r12==false) {
        revert("Rule condition failed");
      }
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r11 = updateTransferFromOnInsertRecv_transferFrom_r11(from,to,amount);
      if(r11==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function transfer(address to,uint amount) public    {
      bool r2 = updateTransferOnInsertRecv_transfer_r2(to,amount);
      if(r2==false) {
        revert("Rule condition failed");
      }
  }
  function decreaseApproval(address p,uint n) public    {
      bool r7 = updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r7(p,n);
      if(r7==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function updateBalanceOfOnInsertTotalOut_r4(address p,uint o) private    {
      TotalOutTuple memory toDelete = totalOut[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalOut_r4(p,toDelete.n);
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
  function updateBalanceOfOnInsertTotalMint_r4(address p,uint n) private    {
      TotalMintTuple memory toDelete = totalMint[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalMint_r4(p,toDelete.n);
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
  function updateIncreaseAllowanceOnInsertRecv_approve_r26(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      if(validRecipient(s)) {
        uint d = n-m;
        updateAllowanceTotalOnInsertIncreaseAllowance_r28(o,s,d);
        emit IncreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r11(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[o];
      uint m = balanceOfTuple.n;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint k = allowanceTuple.n;
      if(m>=n && k>=n && validRecipient(r)) {
        updateTransferOnInsertTransferFrom_r14(o,r,n);
        updateSpentTotalOnInsertTransferFrom_r22(o,s,n);
        emit TransferFrom(o,r,s,n);
        return true;
      }
      return false;
  }
  function updateAllowanceOnInsertAllowanceTotal_r24(address o,address s,uint m) private    {
      AllowanceTotalTuple memory toDelete = allowanceTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteAllowanceTotal_r24(o,s,toDelete.m);
      }
      DecreaseAllowanceTotalTuple memory decreaseAllowanceTotalTuple = decreaseAllowanceTotal[o][s];
      uint d = decreaseAllowanceTotalTuple.m;
      SpentTotalTuple memory spentTotalTuple = spentTotal[o][s];
      uint l = spentTotalTuple.m;
      uint n = (m-l)-d;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r7(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      if(m>=n && validRecipient(s)) {
        updateDecreaseAllowanceTotalOnInsertDecreaseAllowance_r6(o,s,n);
        emit DecreaseAllowance(o,s,n);
        return true;
      }
      return false;
  }
  function validRecipient(address p) private view  returns (bool) {
      address t = address(this);
      if(p!=t && p!=address(0)) {
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
  function updateDecreaseAllowanceTotalOnInsertDecreaseAllowance_r6(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementDecreaseAllowanceTotal_r24(o,s,delta0);
      decreaseAllowanceTotal[o][s].m += n;
  }
  function updateBalanceOfOnDeleteTotalOut_r4(address p,uint o) private    {
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
  function updateTotalMintOnInsertMint_r16(address p,uint n) private    {
      int delta2 = int(n);
      updateBalanceOfOnIncrementTotalMint_r4(p,delta2);
      totalMint[p].n += n;
  }
  function updateBalanceOfOnDeleteTotalMint_r4(address p,uint n) private    {
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
  function updateTransferOnInsertRecv_transfer_r2(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[s];
      uint m = balanceOfTuple.n;
      if(n<=m && validRecipient(r)) {
        updateTotalOutOnInsertTransfer_r20(s,n);
        updateTotalInOnInsertTransfer_r10(r,n);
        emit Transfer(s,r,n);
        return true;
      }
      return false;
  }
  function updateTotalInOnInsertConstructor_r13(uint n) private    {
      address s = msg.sender;
      updateBalanceOfOnInsertTotalIn_r4(s,n);
      totalIn[s] = TotalInTuple(n,true);
  }
  function updateTotalSupplyOnInsertAllMint_r17(uint m) private    {
      uint b = allBurn.n;
      uint n = m-b;
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateSpentTotalOnInsertTransferFrom_r22(address o,address s,uint n) private    {
      int delta2 = int(n);
      updateAllowanceOnIncrementSpentTotal_r24(o,s,delta2);
      spentTotal[o][s].m += n;
  }
  function updateBalanceOfOnDeleteTotalIn_r4(address p,uint i) private    {
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
  function updateAllowanceOnIncrementDecreaseAllowanceTotal_r24(address o,address s,int d) private    {
      int _delta = int(d);
      uint newValue = updateuintByint(decreaseAllowanceTotal[o][s].m,_delta);
      updateAllowanceOnInsertDecreaseAllowanceTotal_r24(o,s,newValue);
  }
  function updateTotalSupplyOnIncrementAllBurn_r17(int b) private    {
      int _delta = int(b);
      uint newValue = updateuintByint(allBurn.n,_delta);
      updateTotalSupplyOnInsertAllBurn_r17(newValue);
  }
  function updateBalanceOfOnIncrementTotalMint_r4(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(totalMint[p].n,_delta);
      updateBalanceOfOnInsertTotalMint_r4(p,newValue);
  }
  function updateTotalMintOnInsertConstructor_r19(uint n) private    {
      address s = msg.sender;
      updateBalanceOfOnInsertTotalMint_r4(s,n);
      totalMint[s] = TotalMintTuple(n,true);
  }
  function updateTotalSupplyOnInsertAllBurn_r17(uint b) private    {
      uint m = allMint.n;
      uint n = m-b;
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateBalanceOfOnIncrementTotalOut_r4(address p,int o) private    {
      int _delta = int(o);
      uint newValue = updateuintByint(totalOut[p].n,_delta);
      updateBalanceOfOnInsertTotalOut_r4(p,newValue);
  }
  function updateAllowanceOnInsertDecreaseAllowanceTotal_r24(address o,address s,uint d) private    {
      DecreaseAllowanceTotalTuple memory toDelete = decreaseAllowanceTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteDecreaseAllowanceTotal_r24(o,s,toDelete.m);
      }
      SpentTotalTuple memory spentTotalTuple = spentTotal[o][s];
      uint l = spentTotalTuple.m;
      AllowanceTotalTuple memory allowanceTotalTuple = allowanceTotal[o][s];
      uint m = allowanceTotalTuple.m;
      uint n = (m-l)-d;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateAllowanceOnIncrementSpentTotal_r24(address o,address s,int l) private    {
      int _delta = int(l);
      uint newValue = updateuintByint(spentTotal[o][s].m,_delta);
      updateAllowanceOnInsertSpentTotal_r24(o,s,newValue);
  }
  function updateAllowanceOnInsertSpentTotal_r24(address o,address s,uint l) private    {
      SpentTotalTuple memory toDelete = spentTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteSpentTotal_r24(o,s,toDelete.m);
      }
      DecreaseAllowanceTotalTuple memory decreaseAllowanceTotalTuple = decreaseAllowanceTotal[o][s];
      uint d = decreaseAllowanceTotalTuple.m;
      AllowanceTotalTuple memory allowanceTotalTuple = allowanceTotal[o][s];
      uint m = allowanceTotalTuple.m;
      uint n = (m-l)-d;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r28(address o,address s,uint n) private    {
      int delta2 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r24(o,s,delta2);
      allowanceTotal[o][s].m += n;
  }
  function updateAllBurnOnInsertBurn_r25(uint n) private    {
      int delta1 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r17(delta1);
      allBurn.n += n;
  }
  function updateOwnerOnInsertConstructor_r8() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateTotalSupplyOnInsertConstructor_r23(uint n) private    {
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateAllowanceOnDeleteAllowanceTotal_r24(address o,address s,uint m) private    {
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
  function updateMintOnInsertRecv_mint_r9(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          updateAllMintOnInsertMint_r0(n);
          updateTotalMintOnInsertMint_r16(p,n);
          emit Mint(p,n);
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnDeleteTotalBurn_r4(address p,uint m) private    {
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
  function updateBalanceOfOnInsertConstructor_r5(uint n) private    {
      address p = msg.sender;
      balanceOf[p] = BalanceOfTuple(n,true);
  }
  function updateBalanceOfOnInsertTotalBurn_r4(address p,uint m) private    {
      TotalBurnTuple memory toDelete = totalBurn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalBurn_r4(p,toDelete.n);
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
  function updateTotalBurnOnInsertBurn_r15(address p,uint n) private    {
      int delta1 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r4(p,delta1);
      totalBurn[p].n += n;
  }
  function updateTotalBalancesOnInsertConstructor_r27(uint n) private    {
      // Empty()
  }
  function updateBalanceOfOnIncrementTotalIn_r4(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(totalIn[p].n,_delta);
      updateBalanceOfOnInsertTotalIn_r4(p,newValue);
  }
  function updateAllowanceOnIncrementAllowanceTotal_r24(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowanceTotal[o][s].m,_delta);
      updateAllowanceOnInsertAllowanceTotal_r24(o,s,newValue);
  }
  function updateBalanceOfOnInsertTotalIn_r4(address p,uint i) private    {
      TotalInTuple memory toDelete = totalIn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalIn_r4(p,toDelete.n);
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
  function updateTotalSupplyOnIncrementAllMint_r17(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allMint.n,_delta);
      updateTotalSupplyOnInsertAllMint_r17(newValue);
  }
  function updateTransferOnInsertTransferFrom_r14(address o,address r,uint n) private    {
      updateTotalOutOnInsertTransfer_r20(o,n);
      updateTotalInOnInsertTransfer_r10(r,n);
      emit Transfer(o,r,n);
  }
  function updateTotalInOnInsertTransfer_r10(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r4(p,delta0);
      totalIn[p].n += n;
  }
  function updateBalanceOfOnIncrementTotalBurn_r4(address p,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalBurn[p].n,_delta);
      updateBalanceOfOnInsertTotalBurn_r4(p,newValue);
  }
  function updateTotalOutOnInsertTransfer_r20(address p,uint n) private    {
      int delta2 = int(n);
      updateBalanceOfOnIncrementTotalOut_r4(p,delta2);
      totalOut[p].n += n;
  }
  function updateIncreaseAllowanceOnInsertRecv_increaseApproval_r12(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      if(validRecipient(s)) {
        updateAllowanceTotalOnInsertIncreaseAllowance_r28(o,s,n);
        emit IncreaseAllowance(o,s,n);
        return true;
      }
      return false;
  }
  function updateAllowanceOnDeleteSpentTotal_r24(address o,address s,uint l) private    {
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
  function updateAllMintOnInsertMint_r0(uint n) private    {
      int delta1 = int(n);
      updateTotalSupplyOnIncrementAllMint_r17(delta1);
      allMint.n += n;
  }
  function updateAllowanceOnDeleteDecreaseAllowanceTotal_r24(address o,address s,uint d) private    {
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
  function updateBurnOnInsertRecv_burn_r3(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        BalanceOfTuple memory balanceOfTuple = balanceOf[p];
        uint m = balanceOfTuple.n;
        if(p!=address(0) && n<=m) {
          updateTotalBurnOnInsertBurn_r15(p,n);
          updateAllBurnOnInsertBurn_r25(n);
          emit Burn(p,n);
          return true;
        }
      }
      return false;
  }
}