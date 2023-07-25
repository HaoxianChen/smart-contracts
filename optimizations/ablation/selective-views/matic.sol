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
    updateBalanceOfOnInsertConstructor_r20(n);
    updatePausedOnInsertConstructor_r25();
    updateTotalMintOnInsertConstructor_r22(n);
    updateOwnerOnInsertConstructor_r8();
    updateTotalBalancesOnInsertConstructor_r32(n);
    updateIsPauserOnInsertConstructor_r5();
    updateAllMintOnInsertConstructor_r15(n);
    updateTotalSupplyOnInsertConstructor_r28(n);
  }
  function burn(address p,uint amount) public    {
      bool r11 = updateBurnOnInsertRecv_burn_r11(p,amount);
      if(r11==false) {
        revert("Rule condition failed");
      }
  }
  function unpause() public    {
      bool r9 = updatePausedOnInsertRecv_unpause_r9();
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function increaseApproval(address p,uint n) public    {
      bool r13 = updateIncreaseAllowanceOnInsertRecv_increaseApproval_r13(p,n);
      if(r13==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function getBalanceOf(address p) public view  returns (uint) {
      uint n = balanceOf[p].n;
      return n;
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r2 = updateTransferFromOnInsertRecv_transferFrom_r2(from,to,amount);
      if(r2==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public    {
      bool r4 = updateMintOnInsertRecv_mint_r4(p,amount);
      if(r4==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address s,uint n) public    {
      bool r31 = updateIncreaseAllowanceOnInsertRecv_approve_r31(s,n);
      if(r31==false) {
        revert("Rule condition failed");
      }
  }
  function addPauser(address p) public    {
      bool r7 = updateIsPauserOnInsertRecv_addPauser_r7(p);
      if(r7==false) {
        revert("Rule condition failed");
      }
  }
  function decreaseApproval(address p,uint n) public    {
      bool r19 = updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r19(p,n);
      if(r19==false) {
        revert("Rule condition failed");
      }
  }
  function pause() public    {
      bool r3 = updatePausedOnInsertRecv_pause_r3();
      if(r3==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      uint n = allowance[p][s].n;
      return n;
  }
  function transfer(address to,uint amount) public    {
      bool r14 = updateTransferOnInsertRecv_transfer_r14(to,amount);
      if(r14==false) {
        revert("Rule condition failed");
      }
  }
  function renouncePauser() public    {
      bool r0 = updateIsPauserOnInsertRecv_renouncePauser_r0();
      if(r0==false) {
        revert("Rule condition failed");
      }
  }
  function updateIsPauserOnInsertRecv_addPauser_r7(address p) private   returns (bool) {
      address s = msg.sender;
      if(true==isPauser[s].b) {
        isPauser[p] = IsPauserTuple(true,true);
        emit IsPauser(p,true);
        return true;
      }
      return false;
  }
  function updateOwnerOnInsertConstructor_r8() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updatePausedOnInsertConstructor_r25() private    {
      paused = PausedTuple(false,true);
      emit Paused(false);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r2(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      if(false==paused.b) {
        uint m = balanceOf[o].n;
        uint k = allowance[o][s].n;
        if(m>=n && k>=n) {
          emit TransferFrom(o,r,s,n);
          emit Transfer(o,r,n);
          totalOut[o].n += n;
          balanceOf[o].n -= n;
          totalIn[r].n += n;
          balanceOf[r].n += n;
          spentTotal[o][s].m += n;
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
      allowanceTotal[o][s].m += d;
      allowance[o][s].n += d;
      return true;
      return false;
  }
  function updatePausedOnInsertRecv_pause_r3() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        paused = PausedTuple(true,true);
        emit Paused(true);
        return true;
      }
      return false;
  }
  function updatePausedOnInsertRecv_unpause_r9() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        paused = PausedTuple(false,true);
        emit Paused(false);
        return true;
      }
      return false;
  }
  function updateIncreaseAllowanceOnInsertRecv_increaseApproval_r13(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      emit IncreaseAllowance(o,s,n);
      allowanceTotal[o][s].m += n;
      allowance[o][s].n += n;
      return true;
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r32(uint n) private    {
      // Empty()
  }
  function updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r19(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      if(m>=n) {
        emit DecreaseAllowance(o,s,n);
        decreaseAllowanceTotal[o][s].m += n;
        allowance[o][s].n -= n;
        return true;
      }
      return false;
  }
  function updateTotalSupplyOnInsertConstructor_r28(uint n) private    {
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateIsPauserOnInsertRecv_renouncePauser_r0() private   returns (bool) {
      address s = msg.sender;
      if(true==isPauser[s].b) {
        isPauser[s] = IsPauserTuple(false,true);
        emit IsPauser(s,false);
        return true;
      }
      return false;
  }
  function updateTotalMintOnInsertConstructor_r22(uint n) private    {
      address s = msg.sender;
      totalMint[s] = TotalMintTuple(n,true);
  }
  function updateBurnOnInsertRecv_burn_r11(address p,uint n) private   returns (bool) {
      address s = msg.sender;
      if(false==paused.b) {
        if(s==owner.p) {
          uint m = balanceOf[p].n;
          if(p!=address(0) && n<=m) {
            emit Burn(p,n);
            totalBurn[p].n += n;
            balanceOf[p].n -= n;
            allBurn.n += n;
            totalSupply.n -= n;
            return true;
          }
        }
      }
      return false;
  }
  function updateTransferOnInsertRecv_transfer_r14(address r,uint n) private   returns (bool) {
      if(false==paused.b) {
        address s = msg.sender;
        uint m = balanceOf[s].n;
        if(n<=m) {
          emit Transfer(s,r,n);
          totalOut[s].n += n;
          balanceOf[s].n -= n;
          totalIn[r].n += n;
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
  function updateBalanceOfOnInsertConstructor_r20(uint n) private    {
      address s = msg.sender;
      balanceOf[s] = BalanceOfTuple(n,true);
  }
  function updateAllMintOnInsertConstructor_r15(uint n) private    {
      allMint = AllMintTuple(n,true);
  }
  function updateIsPauserOnInsertConstructor_r5() private    {
      address s = msg.sender;
      isPauser[s] = IsPauserTuple(true,true);
      emit IsPauser(s,true);
  }
  function updateMintOnInsertRecv_mint_r4(address p,uint n) private   returns (bool) {
      if(false==paused.b) {
        address s = owner.p;
        if(s==msg.sender) {
          if(p!=address(0)) {
            emit Mint(p,n);
            allMint.n += n;
            totalSupply.n += n;
            totalMint[p].n += n;
            balanceOf[p].n += n;
            return true;
          }
        }
      }
      return false;
  }
}