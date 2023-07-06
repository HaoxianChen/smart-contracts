contract Linktoken {
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
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
  TotalSupplyTuple totalSupply;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  OwnerTuple owner;
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event Transfer(address from,address to,uint amount);
  constructor(uint n) public {
    updateOwnerOnInsertConstructor_r9();
    updateTotalSupplyOnInsertConstructor_r17(n);
    updateTotalBalancesOnInsertConstructor_r22(n);
    updateBalanceOfOnInsertConstructor_r8(n);
  }
  function approve(address s,uint n) public    {
      bool r21 = updateIncreaseAllowanceOnInsertRecv_approve_r21(s,n);
      if(r21==false) {
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
  function mint(address p,uint amount) public    {
      bool r19 = updateMintOnInsertRecv_mint_r19(p,amount);
      if(r19==false) {
        revert("Rule condition failed");
      }
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r0 = updateTransferFromOnInsertRecv_transferFrom_r0(from,to,amount);
      if(r0==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public    {
      bool r5 = updateTransferOnInsertRecv_transfer_r5(to,amount);
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function burn(address p,uint amount) public    {
      bool r6 = updateBurnOnInsertRecv_burn_r6(p,amount);
      if(r6==false) {
        revert("Rule condition failed");
      }
  }
  function updateTransferOnInsertRecv_transfer_r5(address r,uint n) private   returns (bool) {
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
  function updateOwnerOnInsertConstructor_r9() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateMintOnInsertRecv_mint_r19(address p,uint n) private   returns (bool) {
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
  function updateBalanceOfOnInsertConstructor_r8(uint n) private    {
      address p = msg.sender;
      balanceOf[p] = BalanceOfTuple(n,true);
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
  function updateTotalBalancesOnInsertConstructor_r22(uint n) private    {
      // Empty()
  }
  function updateTotalSupplyOnInsertConstructor_r17(uint n) private    {
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateBurnOnInsertRecv_burn_r6(address p,uint n) private   returns (bool) {
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
  function updateIncreaseAllowanceOnInsertRecv_approve_r21(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      if(validRecipient(s)) {
        uint d = n-m;
        emit IncreaseAllowance(o,s,d);
        allowance[o][s].n += d;
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
}