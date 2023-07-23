contract Matic {
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct IsPauserTuple {
    bool b;
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
  constructor() public {
    updateTotalBalancesOnInsertConstructor_r27();
    updateOwnerOnInsertConstructor_r20();
    updateIsPauserOnInsertConstructor_r8();
    updateTotalSupplyOnInsertConstructor_r12();
    updatePausedOnInsertConstructor_r5();
  }
  function approve(address s,uint n) public    {
      bool r25 = updateIncreaseAllowanceOnInsertRecv_approve_r25(s,n);
      if(r25==false) {
        revert("Rule condition failed");
      }
  }
  function addPauser(address p) public    {
      bool r21 = updateIsPauserOnInsertRecv_addPauser_r21(p);
      if(r21==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function pause() public    {
      bool r11 = updatePausedOnInsertRecv_pause_r11();
      if(r11==false) {
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
  function transferFrom(address from,address to,uint amount) public    {
      bool r1 = updateTransferFromOnInsertRecv_transferFrom_r1(from,to,amount);
      if(r1==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public    {
      bool r13 = updateMintOnInsertRecv_mint_r13(p,amount);
      if(r13==false) {
        revert("Rule condition failed");
      }
  }
  function unpause() public    {
      bool r23 = updatePausedOnInsertRecv_unpause_r23();
      if(r23==false) {
        revert("Rule condition failed");
      }
  }
  function burn(address p,uint amount) public    {
      bool r10 = updateBurnOnInsertRecv_burn_r10(p,amount);
      if(r10==false) {
        revert("Rule condition failed");
      }
  }
  function renouncePauser(address p) public    {
      bool r14 = updateIsPauserOnInsertRecv_renouncePauser_r14(p);
      if(r14==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function updateIsPauserOnInsertRecv_renouncePauser_r14(address p) private   returns (bool) {
      address s = msg.sender;
      // IsPauserTuple memory isPauserTuple = isPauser[s];
      if(true==isPauser[s].b) {
        isPauser[p] = IsPauserTuple(false,true);
        emit IsPauser(p,false);
        return true;
      }
      return false;
  }
  function updateOwnerOnInsertConstructor_r20() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateBurnOnInsertRecv_burn_r10(address p,uint n) private   returns (bool) {
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
  function updateMintOnInsertRecv_mint_r13(address p,uint n) private   returns (bool) {
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
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateIsPauserOnInsertRecv_addPauser_r21(address p) private   returns (bool) {
      address s = msg.sender;
      // IsPauserTuple memory isPauserTuple = isPauser[s];
      if(true==isPauser[s].b) {
        isPauser[p] = IsPauserTuple(true,true);
        emit IsPauser(p,true);
        return true;
      }
      return false;
  }
  function updatePausedOnInsertRecv_unpause_r23() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        paused = PausedTuple(false,true);
        emit Paused(false);
        return true;
      }
      return false;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r25(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      // AllowanceTuple memory allowanceTuple = allowance[o][s];
      // uint m = allowanceTuple.n;
      uint m = allowance[o][s].n;
      uint d = n-m;
      emit IncreaseAllowance(o,s,d);
      allowance[o][s].n += n;
      return true;
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
  function updateIsPauserOnInsertConstructor_r8() private    {
      address s = msg.sender;
      isPauser[s] = IsPauserTuple(true,true);
      emit IsPauser(s,true);
  }
  function updatePausedOnInsertRecv_pause_r11() private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        paused = PausedTuple(true,true);
        emit Paused(true);
        return true;
      }
      return false;
  }
  function updateTotalSupplyOnInsertConstructor_r12() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updatePausedOnInsertConstructor_r5() private    {
      paused = PausedTuple(false,true);
      emit Paused(false);
  }
  function updateTransferOnInsertRecv_transfer_r3(address r,uint n) private   returns (bool) {
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
  function updateTotalBalancesOnInsertConstructor_r27() private    {
      // Empty()
  }
}
