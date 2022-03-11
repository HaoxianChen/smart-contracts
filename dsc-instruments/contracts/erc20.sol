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
  struct UnequalBalanceTuple {
    uint s;
    uint n;
    bool _valid;
  }
  struct TotalBalancesTuple {
    uint m;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  UnequalBalanceTuple unequalBalance;
  TotalSupplyTuple totalSupply;
  TotalBalancesTuple totalBalances;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  OwnerTuple owner;
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event Transfer(address from,address to,uint amount);
  constructor() public {
    updateTotalSupplyOnInsertConstructor_r1();
    updateTotalBalancesOnInsertConstructor_r21();
    updateOwnerOnInsertConstructor_r6();
  }
  function approve(address s,uint n) public  checkViolations  {
      bool r17 = updateIncreaseAllowanceOnInsertRecv_approve_r17(s,n);
      if(r17==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public  checkViolations  {
      bool r14 = updateTransferOnInsertRecv_transfer_r14(to,amount);
      if(r14==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function transferFrom(address from,address to,uint amount) public  checkViolations  {
      bool r18 = updateTransferFromOnInsertRecv_transferFrom_r18(from,to,amount);
      if(r18==false) {
        revert("Rule condition failed");
      }
  }
  function burn(address p,uint amount) public  checkViolations  {
      bool r9 = updateBurnOnInsertRecv_burn_r9(p,amount);
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function mint(address p,uint amount) public  checkViolations  {
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
  function checkUnequalBalance() private    {
      UnequalBalanceTuple memory unequalBalanceTuple = unequalBalance;
      if(unequalBalanceTuple._valid==true) {
        revert("unequalBalance");
      }
  }
  modifier checkViolations() {
      // Empty()
      _;
      checkUnequalBalance();
  }
  function updateAllowanceOnIncrementSpentTotal_r7(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateUnequalBalanceOnDeleteTotalSupply_r3(uint n) private    {
      if(true) {
        uint s = totalBalances.m;
        if(s!=n) {
          unequalBalance = UnequalBalanceTuple(0,0,false);
        }
      }
  }
  function updateTotalOutOnInsertTransfer_r15(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalOut_r4(p,delta);
  }
  function updateSpentTotalOnInsertTransferFrom_r5(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementSpentTotal_r7(o,s,delta);
  }
  function updateTotalInOnInsertTransfer_r8(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalIn_r4(p,delta);
  }
  function updateBalanceOfOnIncrementTotalIn_r4(address p,int i) private    {
      int delta = int(i);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta);
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateAllMintOnInsertMint_r2(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllMint_r13(delta);
  }
  function updateTotalSupplyOnIncrementAllMint_r13(int m) private    {
      int delta = int(m);
      updateUnequalBalanceOnIncrementTotalSupply_r3(delta);
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateAllowanceOnIncrementAllowanceTotal_r7(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateTotalBalancesOnInsertConstructor_r21() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalBalances_r3(uint(0));
        totalBalances = TotalBalancesTuple(0,true);
      }
  }
  function updateTotalMintOnInsertMint_r12(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalMint_r4(p,delta);
  }
  function updateTotalSupplyOnInsertConstructor_r1() private    {
      if(true) {
        updateUnequalBalanceOnInsertTotalSupply_r3(uint(0));
        totalSupply = TotalSupplyTuple(0,true);
      }
  }
  function updateTransferOnInsertRecv_transfer_r14(address r,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        BalanceOfTuple memory balanceOfTuple = balanceOf[s];
        if(true) {
          uint m = balanceOfTuple.n;
          if(n<=m) {
            updateTotalInOnInsertTransfer_r8(r,n);
            updateTotalOutOnInsertTransfer_r15(s,n);
            emit Transfer(s,r,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateTotalSupplyOnIncrementAllBurn_r13(int b) private    {
      int delta = int(-b);
      updateUnequalBalanceOnIncrementTotalSupply_r3(delta);
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateBalanceOfOnIncrementTotalBurn_r4(address p,int m) private    {
      int delta = int(-m);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta);
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTransferOnInsertTransferFrom_r0(address o,address r,uint n) private    {
      if(true) {
        updateTotalInOnInsertTransfer_r8(r,n);
        updateTotalOutOnInsertTransfer_r15(o,n);
        emit Transfer(o,r,n);
      }
  }
  function updateBurnOnInsertRecv_burn_r9(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          BalanceOfTuple memory balanceOfTuple = balanceOf[p];
          if(true) {
            uint m = balanceOfTuple.n;
            if(n<=m) {
              updateTotalBurnOnInsertBurn_r11(p,n);
              updateAllBurnOnInsertBurn_r19(n);
              emit Burn(p,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r20(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r7(o,s,delta);
  }
  function updateTotalBalancesOnIncrementBalanceOf_r16(int n) private    {
      int delta = int(n);
      updateUnequalBalanceOnIncrementTotalBalances_r3(delta);
      int _delta = int(n);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      totalBalances.m = newValue;
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
              updateSpentTotalOnInsertTransferFrom_r5(o,s,n);
              updateTransferOnInsertTransferFrom_r0(o,r,n);
              emit TransferFrom(o,r,s,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateUnequalBalanceOnInsertTotalSupply_r3(uint n) private    {
      TotalSupplyTuple memory toDelete = totalSupply;
      if(toDelete._valid==true) {
        updateUnequalBalanceOnDeleteTotalSupply_r3(toDelete.n);
      }
      if(true) {
        uint s = totalBalances.m;
        if(s!=n) {
          unequalBalance = UnequalBalanceTuple(s,n,true);
        }
      }
  }
  function updateBalanceOfOnIncrementTotalMint_r4(address p,int n) private    {
      int delta = int(n);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta);
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBalanceOfOnIncrementTotalOut_r4(address p,int o) private    {
      int delta = int(-o);
      updateTotalBalancesOnIncrementBalanceOf_r16(delta);
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalBurnOnInsertBurn_r11(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalBurn_r4(p,delta);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateUnequalBalanceOnIncrementTotalSupply_r3(int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      updateUnequalBalanceOnInsertTotalSupply_r3(newValue);
  }
  function updateUnequalBalanceOnInsertTotalBalances_r3(uint s) private    {
      TotalBalancesTuple memory toDelete = totalBalances;
      if(toDelete._valid==true) {
        updateUnequalBalanceOnDeleteTotalBalances_r3(toDelete.m);
      }
      if(true) {
        uint n = totalSupply.n;
        if(s!=n) {
          unequalBalance = UnequalBalanceTuple(s,n,true);
        }
      }
  }
  function updateAllBurnOnInsertBurn_r19(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllBurn_r13(delta);
  }
  function updateUnequalBalanceOnIncrementTotalBalances_r3(int s) private    {
      int _delta = int(s);
      uint newValue = updateuintByint(totalBalances.m,_delta);
      updateUnequalBalanceOnInsertTotalBalances_r3(newValue);
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
  function updateOwnerOnInsertConstructor_r6() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          owner = OwnerTuple(s,true);
        }
      }
  }
  function updateMintOnInsertRecv_mint_r10(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(n>0) {
            updateAllMintOnInsertMint_r2(n);
            updateTotalMintOnInsertMint_r12(p,n);
            emit Mint(p,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateUnequalBalanceOnDeleteTotalBalances_r3(uint s) private    {
      if(true) {
        uint n = totalSupply.n;
        if(s!=n) {
          unequalBalance = UnequalBalanceTuple(0,0,false);
        }
      }
  }
}