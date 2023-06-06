contract Linktoken {
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  TotalSupplyTuple totalSupply;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  OwnerTuple owner;
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event Transfer(address from,address to,uint amount);
  constructor() public {
    updateTotalSupplyOnInsertConstructor_r2();
    updateTotalBalancesOnInsertConstructor_r22();
    updateOwnerOnInsertConstructor_r10();
  }
  function mint(address p,uint amount) public    {
      bool r18 = updateMintOnInsertRecv_mint_r18(p,amount);
      if(r18==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address s,uint n) public    {
      bool r20 = updateIncreaseAllowanceOnInsertRecv_approve_r20(s,n);
      if(r20==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function burn(address p,uint amount) public    {
      bool r7 = updateBurnOnInsertRecv_burn_r7(p,amount);
      if(r7==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r0 = updateTransferFromOnInsertRecv_transferFrom_r0(from,to,amount);
      if(r0==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public    {
      bool r6 = updateTransferOnInsertRecv_transfer_r6(to,amount);
      if(r6==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function updateTotalSupplyOnInsertConstructor_r2() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updateBurnOnInsertRecv_burn_r7(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        BalanceOfTuple memory balanceOfTuple = balanceOf[p];
        uint m = balanceOfTuple.n;
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
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateMintOnInsertRecv_mint_r18(address p,uint n) private   returns (bool) {
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
  function updateTransferOnInsertRecv_transfer_r6(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[s];
      uint m = balanceOfTuple.n;
      if(n<=m && validRecipient(r)) {
        emit Transfer(s,r,n);
        balanceOf[s].n -= n;
        balanceOf[r].n += n;
        return true;
      }
      return false;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r20(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      if(validRecipient(s)) {
        uint d = n-m;
        emit IncreaseAllowance(o,s,d);
        allowance[o][s].n += n;
        return true;
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r0(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[o];
      uint m = balanceOfTuple.n;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint k = allowanceTuple.n;
      if(m>=n && k>=n && validRecipient(r)) {
        emit TransferFrom(o,r,s,n);
        emit Transfer(o,r,n);
        balanceOf[o].n -= n;
        balanceOf[r].n += n;
        allowance[o][s].n -= n;
        return true;
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r22() private    {
      // Empty()
  }
  function updateOwnerOnInsertConstructor_r10() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
}