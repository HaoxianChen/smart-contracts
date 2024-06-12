contract Erc1155 {
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  mapping(uint=>mapping(address=>mapping(address=>AllowanceTuple))) allowance;
  mapping(uint=>mapping(address=>BalanceOfTuple)) balanceOf;
  mapping(uint=>TotalSupplyTuple) totalSupply;
  OwnerTuple owner;
  event Burn(uint tokenId,address p,uint amount);
  event Transfer(uint tokenId,address from,address to,uint amount);
  event TransferFrom(uint tokenId,address from,address to,address spender,uint amount);
  event Mint(uint tokenId,address p,uint amount);
  event IncreaseAllowance(uint tokenId,address p,address s,uint n);
  constructor() public {
    updateOwnerOnInsertConstructor_r6();
  }
  function approve(uint tokenId,address s,uint n) public    {
      bool r1 = updateIncreaseAllowanceOnInsertRecv_approve_r1(tokenId,s,n);
      if(r1==false) {
        revert("Rule condition failed");
      }
  }
  function mint(uint tokenId,address p,uint amount) public    {
      bool r7 = updateMintOnInsertRecv_mint_r7(tokenId,p,amount);
      if(r7==false) {
        revert("Rule condition failed");
      }
  }
  function burn(uint tokenId,address p,uint amount) public    {
      bool r4 = updateBurnOnInsertRecv_burn_r4(tokenId,p,amount);
      if(r4==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(uint tokenId,address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[tokenId][p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function transfer(uint tokenId,address to,uint amount) public    {
      bool r9 = updateTransferOnInsertRecv_transfer_r9(tokenId,to,amount);
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(uint tokenId,address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[tokenId][p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function transferFrom(uint tokenId,address from,address to,uint amount) public    {
      bool r18 = updateTransferFromOnInsertRecv_transferFrom_r18(tokenId,from,to,amount);
      if(r18==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply(uint tokenId) public view  returns (uint) {
      TotalSupplyTuple memory totalSupplyTuple = totalSupply[tokenId];
      uint n = totalSupplyTuple.n;
      return n;
  }
  function updateMintOnInsertRecv_mint_r7(uint t,address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          emit Mint(t,p,n);
          balanceOf[t][p].n += n;
          totalSupply[t].n += n;
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
  function updateOwnerOnInsertConstructor_r6() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r1(uint t,address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[t][o][s];
      uint m = allowanceTuple.n;
      uint d = n-m;
      emit IncreaseAllowance(t,o,s,d);
      allowance[t][o][s].n += n;
      return true;
      return false;
  }
  function updateTransferOnInsertRecv_transfer_r9(uint t,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[t][s];
      uint m = balanceOfTuple.n;
      if(n<=m) {
        emit Transfer(t,s,r,n);
        balanceOf[t][s].n -= n;
        balanceOf[t][r].n += n;
        return true;
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r18(uint t,address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[t][o][s];
      uint k = allowanceTuple.n;
      BalanceOfTuple memory balanceOfTuple = balanceOf[t][o];
      uint m = balanceOfTuple.n;
      if(m>=n && k>=n) {
        emit TransferFrom(t,o,r,s,n);
        emit Transfer(t,o,r,n);
        balanceOf[t][o].n -= n;
        balanceOf[t][r].n += n;
        allowance[t][o][s].n -= n;
        return true;
      }
      return false;
  }
  function updateBurnOnInsertRecv_burn_r4(uint t,address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        BalanceOfTuple memory balanceOfTuple = balanceOf[t][p];
        uint m = balanceOfTuple.n;
        if(p!=address(0) && n<=m) {
          emit Burn(t,p,n);
          totalSupply[t].n -= n;
          balanceOf[t][p].n -= n;
          return true;
        }
      }
      return false;
  }
}