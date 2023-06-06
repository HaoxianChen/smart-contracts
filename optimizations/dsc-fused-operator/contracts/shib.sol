contract Shib {
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
  event BurnFrom(address p,address from,uint n);
  event Transfer(address from,address to,uint amount);
  constructor() public {
    updateTotalSupplyOnInsertConstructor_r1();
    updateTotalBalancesOnInsertConstructor_r22();
    updateOwnerOnInsertConstructor_r8();
  }
  function burn(address p,uint amount) public    {
      bool r5 = updateBurnOnInsertRecv_burn_r5(p,amount);
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public    {
      bool r13 = updateTransferOnInsertRecv_transfer_r13(to,amount);
      if(r13==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public    {
      bool r18 = updateMintOnInsertRecv_mint_r18(p,amount);
      if(r18==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function burnFrom(address p,uint n) public    {
      bool r2 = updateBurnFromOnInsertRecv_burnFrom_r2(p,n);
      if(r2==false) {
        revert("Rule condition failed");
      }
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r20 = updateTransferFromOnInsertRecv_transferFrom_r20(from,to,amount);
      if(r20==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function approve(address s,uint n) public    {
      bool r19 = updateIncreaseAllowanceOnInsertRecv_approve_r19(s,n);
      if(r19==false) {
        revert("Rule condition failed");
      }
  }
  function updateTransferFromOnInsertRecv_transferFrom_r20(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint k = allowanceTuple.n;
      BalanceOfTuple memory balanceOfTuple = balanceOf[o];
      uint m = balanceOfTuple.n;
      if(m>=n && k>=n) {
        emit TransferFrom(o,r,s,n);
        emit Transfer(o,r,n);
        balanceOf[o].n -= n;
        balanceOf[r].n += n;
        allowance[o][s].n -= n;
        return true;
      }
      return false;
  }
  function updateBurnOnInsertRecv_burn_r5(address p,uint n) private   returns (bool) {
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
  function updateIncreaseAllowanceOnInsertRecv_approve_r19(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      uint d = n-m;
      emit IncreaseAllowance(o,s,d);
      allowance[o][s].n += n;
      return true;
      return false;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateOwnerOnInsertConstructor_r8() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateTotalSupplyOnInsertConstructor_r1() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updateTransferOnInsertRecv_transfer_r13(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[s];
      uint m = balanceOfTuple.n;
      if(n<=m) {
        emit Transfer(s,r,n);
        balanceOf[s].n -= n;
        balanceOf[r].n += n;
        return true;
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r22() private    {
      // Empty()
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
  function updateBurnFromOnInsertRecv_burnFrom_r2(address p,uint n) private   returns (bool) {
      address s = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint k = allowanceTuple.n;
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint m = balanceOfTuple.n;
      if(p!=address(0) && m>=n && k>=m) {
        emit BurnFrom(s,p,n);
        emit Burn(p,n);
        balanceOf[p].n -= n;
        totalSupply.n -= n;
        emit TransferFrom(s,p,address(0),n);
        emit Transfer(s,p,n);
        balanceOf[s].n -= n;
        balanceOf[p].n += n;
        allowance[s][address(0)].n -= n;
        return true;
      }
      return false;
  }
}