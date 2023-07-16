contract Linktoken {
  struct OwnerTuple {
    address p;
  }
  struct TotalSupplyTuple {
    uint n;
  }
  struct BalanceOfTuple {
    uint n;
  }
  struct AllowanceTuple {
    uint n;
  }
  TotalSupplyTuple totalSupply;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  OwnerTuple owner;
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event DecreaseAllowance(address p,address s,uint n);
  event IncreaseAllowance(address p,address s,uint n);
  event Transfer(address from,address to,uint amount);
  constructor(uint n) public {
    updateTotalBalancesOnInsertConstructor_r25(n);
    updateTotalSupplyOnInsertConstructor_r21(n);
    updateOwnerOnInsertConstructor_r10();
    updateBalanceOfOnInsertConstructor_r7(n);
  }
  function burn(address p,uint amount) public    {
      bool r5 = updateBurnOnInsertRecv_burn_r5(p,amount);
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function decreaseApproval(address p,uint n) public    {
      bool r9 = updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r9(p,n);
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      // AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowance[p][s].n;
      return n;
  }
  function approve(address s,uint n) public    {
      bool r24 = updateIncreaseAllowanceOnInsertRecv_approve_r24(s,n);
      if(r24==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public    {
      bool r4 = updateTransferOnInsertRecv_transfer_r4(to,amount);
      if(r4==false) {
        revert("Rule condition failed");
      }
  }
  function increaseApproval(address p,uint n) public    {
      bool r14 = updateIncreaseAllowanceOnInsertRecv_increaseApproval_r14(p,n);
      if(r14==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function getBalanceOf(address p) public view  returns (uint) {
      // BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOf[p].n;
      return n;
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r13 = updateTransferFromOnInsertRecv_transferFrom_r13(from,to,amount);
      if(r13==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public    {
      bool r11 = updateMintOnInsertRecv_mint_r11(p,amount);
      if(r11==false) {
        revert("Rule condition failed");
      }
  }
  function updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r9(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      // AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowance[o][s].n;
      if(m>=n && validRecipient(s)) {
        emit DecreaseAllowance(o,s,n);
        allowance[o][s].n -= n;
        return true;
      }
      return false;
  }
  function updateIncreaseAllowanceOnInsertRecv_increaseApproval_r14(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      if(validRecipient(s)) {
        emit IncreaseAllowance(o,s,n);
        allowance[o][s].n += n;
        return true;
      }
      return false;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r24(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      // AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowance[o][s].n;
      if(validRecipient(s)) {
        uint d = n-m;
        emit IncreaseAllowance(o,s,d);
        allowance[o][s].n += d;
        return true;
      }
      return false;
  }
  function updateBurnOnInsertRecv_burn_r5(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        // BalanceOfTuple memory balanceOfTuple = balanceOf[p];
        uint m = balanceOf[p].n;
        if(p!=address(0) && n<=m) {
          emit Burn(p,n);
          balanceOf[p].n -= n;
          totalSupply.n -= n;
          return true;
        }
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
  function updateMintOnInsertRecv_mint_r11(address p,uint n) private   returns (bool) {
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
  function updateOwnerOnInsertConstructor_r10() private    {
      address s = msg.sender;
      owner = OwnerTuple(s);
  }
  function updateTotalBalancesOnInsertConstructor_r25(uint n) private    {
      // Empty()
  }
  function updateTransferOnInsertRecv_transfer_r4(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      // BalanceOfTuple memory balanceOfTuple = balanceOf[s];
      uint m = balanceOf[s].n;
      if(n<=m && validRecipient(r)) {
        emit Transfer(s,r,n);
        balanceOf[s].n -= n;
        balanceOf[r].n += n;
        return true;
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r13(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      // BalanceOfTuple memory balanceOfTuple = balanceOf[o];
      uint m = balanceOf[o].n;
      // AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint k = allowance[o][s].n;
      if(m>=n && k>=n && validRecipient(r)) {
        emit TransferFrom(o,r,s,n);
        // emit Transfer(o,r,n);
        balanceOf[o].n -= n;
        balanceOf[r].n += n;
        allowance[o][s].n -= n;
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
  function updateBalanceOfOnInsertConstructor_r7(uint n) private    {
      address p = msg.sender;
      balanceOf[p] = BalanceOfTuple(n);
  }
  function updateTotalSupplyOnInsertConstructor_r21(uint n) private    {
      totalSupply = TotalSupplyTuple(n);
  }
}
