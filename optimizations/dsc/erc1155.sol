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
  function updateTotalMintOnInsertMint_r13(uint t,address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalMint_r2(t,p,delta0);
  }
  function updateAllowanceOnIncrementAllowanceTotal_r0(uint t,address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[t][o][s].n,_delta);
      allowance[t][o][s].n = newValue;
  }
  function updateAllowanceOnIncrementSpentTotal_r0(uint t,address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[t][o][s].n,_delta);
      allowance[t][o][s].n = newValue;
  }
  function updateMintOnInsertRecv_mint_r7(uint t,address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          updateTotalMintOnInsertMint_r13(t,p,n);
          updateAllMintOnInsertMint_r14(t,n);
          emit Mint(t,p,n);
          return true;
        }
      }
      return false;
  }
  function updateTotalBurnOnInsertBurn_r5(uint t,address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r2(t,p,delta0);
  }
  function updateTotalOutOnInsertTransfer_r12(uint t,address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r2(t,p,delta0);
  }
  function updateAllBurnOnInsertBurn_r3(uint t,uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r10(t,delta0);
  }
  function updateBurnOnInsertRecv_burn_r4(uint t,address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        BalanceOfTuple memory balanceOfTuple = balanceOf[t][p];
        uint m = balanceOfTuple.n;
        if(p!=address(0) && n<=m) {
          updateAllBurnOnInsertBurn_r3(t,n);
          updateTotalBurnOnInsertBurn_r5(t,p,n);
          emit Burn(t,p,n);
          return true;
        }
      }
      return false;
  }
  function updateAllMintOnInsertMint_r14(uint t,uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllMint_r10(t,delta0);
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r1(uint t,address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[t][o][s];
      uint m = allowanceTuple.n;
      uint d = n-m;
      updateAllowanceTotalOnInsertIncreaseAllowance_r16(t,o,s,d);
      emit IncreaseAllowance(t,o,s,d);
      return true;
      return false;
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r16(uint t,address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r0(t,o,s,delta0);
  }
  function updateBalanceOfOnIncrementTotalMint_r2(uint t,address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[t][p].n,_delta);
      balanceOf[t][p].n = newValue;
  }
  function updateTransferOnInsertRecv_transfer_r9(uint t,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[t][s];
      uint m = balanceOfTuple.n;
      if(n<=m) {
        updateTotalInOnInsertTransfer_r15(t,r,n);
        updateTotalOutOnInsertTransfer_r12(t,s,n);
        emit Transfer(t,s,r,n);
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
        updateTransferOnInsertTransferFrom_r8(t,o,r,n);
        updateSpentTotalOnInsertTransferFrom_r17(t,o,s,n);
        emit TransferFrom(t,o,r,s,n);
        return true;
      }
      return false;
  }
  function updateTotalInOnInsertTransfer_r15(uint t,address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r2(t,p,delta0);
  }
  function updateSpentTotalOnInsertTransferFrom_r17(uint t,address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r0(t,o,s,delta0);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateBalanceOfOnIncrementTotalOut_r2(uint t,address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[t][p].n,_delta);
      balanceOf[t][p].n = newValue;
  }
  function updateOwnerOnInsertConstructor_r6() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateTotalSupplyOnIncrementAllMint_r10(uint t,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply[t].n,_delta);
      totalSupply[t].n = newValue;
  }
  function updateTotalSupplyOnIncrementAllBurn_r10(uint t,int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply[t].n,_delta);
      totalSupply[t].n = newValue;
  }
  function updateTransferOnInsertTransferFrom_r8(uint t,address o,address r,uint n) private    {
      updateTotalInOnInsertTransfer_r15(t,r,n);
      updateTotalOutOnInsertTransfer_r12(t,o,n);
      emit Transfer(t,o,r,n);
  }
  function updateBalanceOfOnIncrementTotalBurn_r2(uint t,address p,int m) private    {
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[t][p].n,_delta);
      balanceOf[t][p].n = newValue;
  }
  function updateBalanceOfOnIncrementTotalIn_r2(uint t,address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[t][p].n,_delta);
      balanceOf[t][p].n = newValue;
  }
}