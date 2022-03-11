contract Erc20 {
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
    updateTotalBalancesOnInsertConstructor_r21();
    updateTotalSupplyOnInsertConstructor_r1();
    updateOwnerOnInsertConstructor_r7();
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r18 = updateTransferFromOnInsertRecv_transferFrom_r18(from,to,amount);
      if(r18==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address s,uint n) public    {
      bool r17 = updateIncreaseAllowanceOnInsertRecv_approve_r17(s,n);
      if(r17==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function mint(address p,uint amount) public    {
      bool r16 = updateMintOnInsertRecv_mint_r16(p,amount);
      if(r16==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function transfer(address to,uint amount) public    {
      bool r12 = updateTransferOnInsertRecv_transfer_r12(to,amount);
      if(r12==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function burn(address p,uint amount) public    {
      bool r4 = updateBurnOnInsertRecv_burn_r4(p,amount);
      if(r4==false) {
        revert("Rule condition failed");
      }
  }
  function updateTransferOnInsertTransferFrom_r0(address o,address r,uint n) private    {
      if(true) {
        updateTotalOutOnInsertTransfer_r13(o,n);
        updateTotalInOnInsertTransfer_r8(r,n);
        emit Transfer(o,r,n);
      }
  }
  function updateTotalOutOnInsertTransfer_r13(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalOut_r5(p,delta);
  }
  function updateTotalMintOnInsertMint_r10(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalMint_r5(p,delta);
  }
  function updateAllowanceOnIncrementSpentTotal_r15(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateTotalInOnInsertTransfer_r8(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalIn_r5(p,delta);
  }
  function updateAllMintOnInsertMint_r2(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllMint_r11(delta);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateBalanceOfOnIncrementTotalMint_r5(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r17(address s,uint n) private   returns (bool) {
      if(true) {
        address o = msg.sender;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        if(true) {
          uint m = allowanceTuple.n;
          if(true) {
            uint d = n-m;
            updateAllowanceTotalOnInsertIncreaseAllowance_r20(o,s,d);
            emit IncreaseAllowance(o,s,d);
            return true;
          }
        }
      }
      return false;
  }
  function updateTotalBurnOnInsertBurn_r9(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalBurn_r5(p,delta);
  }
  function updateMintOnInsertRecv_mint_r16(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(p!=address(0)) {
            updateTotalMintOnInsertMint_r10(p,n);
            updateAllMintOnInsertMint_r2(n);
            emit Mint(p,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalOut_r5(address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalBalancesOnInsertConstructor_r21() private    {
      if(true) {
        // Empty()
      }
  }
  function updateTotalSupplyOnIncrementAllBurn_r11(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateBalanceOfOnIncrementTotalBurn_r5(address p,int m) private    {
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateSpentTotalOnInsertTransferFrom_r6(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementSpentTotal_r15(o,s,delta);
  }
  function updateOwnerOnInsertConstructor_r7() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          owner = OwnerTuple(s,true);
        }
      }
  }
  function updateAllowanceOnIncrementAllowanceTotal_r15(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateTotalSupplyOnIncrementAllMint_r11(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateBurnOnInsertRecv_burn_r4(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          BalanceOfTuple memory balanceOfTuple = balanceOf[p];
          if(true) {
            uint m = balanceOfTuple.n;
            if(p!=address(0) && n<=m) {
              updateTotalBurnOnInsertBurn_r9(p,n);
              updateAllBurnOnInsertBurn_r19(n);
              emit Burn(p,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalIn_r5(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r20(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r15(o,s,delta);
  }
  function updateTransferOnInsertRecv_transfer_r12(address r,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        BalanceOfTuple memory balanceOfTuple = balanceOf[s];
        if(true) {
          uint m = balanceOfTuple.n;
          if(n<=m) {
            updateTotalOutOnInsertTransfer_r13(s,n);
            updateTotalInOnInsertTransfer_r8(r,n);
            emit Transfer(s,r,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateTotalSupplyOnInsertConstructor_r1() private    {
      if(true) {
        totalSupply = TotalSupplyTuple(0,true);
      }
  }
  function updateTransferFromOnInsertRecv_transferFrom_r18(address o,address r,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        if(true) {
          uint k = allowanceTuple.n;
          BalanceOfTuple memory balanceOfTuple = balanceOf[o];
          if(true) {
            uint m = balanceOfTuple.n;
            if(m>=n && k>=n) {
              updateTransferOnInsertTransferFrom_r0(o,r,n);
              updateSpentTotalOnInsertTransferFrom_r6(o,s,n);
              emit TransferFrom(o,r,s,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateAllBurnOnInsertBurn_r19(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllBurn_r11(delta);
  }
}