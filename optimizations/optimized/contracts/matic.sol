contract Matic {
  struct OwnerTuple {
    address p;
  }
  struct TotalSupplyTuple {
    uint n;
  }
  struct IsPauserTuple {
    bool b;
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
  TotalSupplyTuple totalSupply;
  mapping(address=>IsPauserTuple) isPauser;
  mapping(address=>BalanceOfTuple) balanceOf;
  OwnerTuple owner;
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
  function updateTransferOnInsertRecv_transfer_r12(address r,uint n) private   returns (bool) {
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
  function updateIsPauserOnInsertRecv_addPauser_r6(address p) private   returns (bool) {
      address s = msg.sender;
      // IsPauserTuple memory isPauserTuple = isPauser[s];
      // if(true==isPauserTuple.b) {
      if(true==isPauser[s].b) {
        isPauser[p] = IsPauserTuple(true);
        emit IsPauser(p,true);
        return true;
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r1(address o,address r,uint n) private   returns (bool) {
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
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r28(address s,uint n) private   returns (bool) {
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
  function updateTotalMintOnInsertConstructor_r18(uint n) private    {
      address s = msg.sender;
      // Empty()
  }
  function updatePausedOnInsertRecv_pause_r2() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        paused = PausedTuple(true);
        emit Paused(true);
        return true;
      }
      return false;
  }
  function updateTotalSupplyOnInsertConstructor_r24(uint n) private    {
      totalSupply = TotalSupplyTuple(n);
  }
  function updateAllMintOnInsertConstructor_r13(uint n) private    {
      // Empty()
  }
  function updateOwnerOnInsertConstructor_r7() private    {
      address s = msg.sender;
      owner = OwnerTuple(s);
  }
  function updateBurnOnInsertRecv_burn_r9(address p,uint n) private   returns (bool) {
      address s = msg.sender;
      if(false==paused.b) {
        if(s==owner.p) {
          // BalanceOfTuple memory balanceOfTuple = balanceOf[p];
          // uint m = balanceOfTuple.n;
          uint m = balanceOf[p].n;
          if(p!=address(0) && n<=m) {
            emit Burn(p,n);
            balanceOf[p].n -= n;
            totalSupply.n -= n;
            return true;
          }
        }
      }
      return false;
  }
  function updateMintOnInsertRecv_mint_r10(address p,uint n) private   returns (bool) {
      if(false==paused.b) {
        address s = owner.p;
        if(s==msg.sender) {
          if(p!=address(0)) {
            emit Mint(p,n);
            totalSupply.n += n;
            balanceOf[p].n += n;
            return true;
          }
        }
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r29(uint n) private    {
      // Empty()
  }
  function updateIsPauserOnInsertConstructor_r5() private    {
      address s = msg.sender;
      isPauser[s] = IsPauserTuple(true);
      emit IsPauser(s,true);
  }
  function updateIsPauserOnInsertRecv_renouncePauser_r11(address p) private   returns (bool) {
      address s = msg.sender;
      // IsPauserTuple memory isPauserTuple = isPauser[s];
      // if(true==isPauserTuple.b) {
      if(true==isPauser[s].b) {
        isPauser[p] = IsPauserTuple(false);
        emit IsPauser(p,false);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnInsertConstructor_r4(uint n) private    {
      address s = msg.sender;
      balanceOf[s] = BalanceOfTuple(n);
  }
  function updatePausedOnInsertConstructor_r21() private    {
      paused = PausedTuple(false);
      emit Paused(false);
  }
  function updatePausedOnInsertRecv_unpause_r26() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        paused = PausedTuple(false);
        emit Paused(false);
        return true;
      }
      return false;
  }
}
