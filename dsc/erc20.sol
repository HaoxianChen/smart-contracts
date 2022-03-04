contract Erc20 {
  struct AllowanceTuple {
    int n;
    bool _valid;
  }
  struct BalanceOfTuple {
    int n;
    bool _valid;
  }
  struct TotalSupplyTuple {
    int n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  mapping(address=>BalanceOfTuple) balanceOf;
  TotalSupplyTuple totalSupply;
  OwnerTuple owner;
  event Transfer(address from,address to,int amount);
  event Mint(address p,int amount);
  event TransferFrom(address from,address to,address spender,int amount);
  event Burn(address p,int amount);
  event IncreaseAllowance(address p,address s,int n);
  constructor() public {
    updateOwnerOnInsertConstructor_r15();
  }
  function transferFrom(address from,address to,int amount) public  checkViolations  {
      bool r13 = updateTransferFromOnInsertRecv_transferFrom_r13(from,to,amount);
      bool r8 = updateTransferOnInsertRecv_transferFrom_r8(from,to,amount);
      if(r13==false && r8==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (int) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      int n = allowanceTuple.n;
      return n;
  }
  function burn(address p,int amount) public  checkViolations  {
      bool r11 = updateBurnOnInsertRecv_burn_r11(p,amount);
      if(r11==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address p,address s,int n) public  checkViolations  {
      bool r16 = updateIncreaseAllowanceOnInsertRecv_approve_r16(p,s,n);
      if(r16==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (int) {
      int n = totalSupply.n;
      return n;
  }
  function transfer(address from,address to,int amount) public  checkViolations  {
      bool r3 = updateTransferOnInsertRecv_transfer_r3(from,to,amount);
      if(r3==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,int amount) public  checkViolations  {
      bool r2 = updateMintOnInsertRecv_mint_r2(p,amount);
      if(r2==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (int) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      int n = balanceOfTuple.n;
      return n;
  }
  modifier checkViolations() {
      // Empty()
      _;
      // Empty()
  }
  function updateAllBurnOnInsertBurn_r9(int n) private    {
      int delta = n;
      updateTotalSupplyOnIncrementAllBurn_r10(delta);
  }
  function updateTotalOutOnInsertTransfer_r6(address p,int n) private    {
      int delta = n;
      updateBalanceOfOnIncrementTotalOut_r12(p,delta);
  }
  function updateTransferOnInsertRecv_transfer_r3(address s,address r,int n) private   returns (bool) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[s];
      if(true) {
        int m = balanceOfTuple.n;
        if(n>=m) {
          updateTotalOutOnInsertTransfer_r6(s,n);
          updateTotalInOnInsertTransfer_r1(r,n);
          emit Transfer(s,r,n);
          return true;
        }
      }
      return false;
  }
  function updateAllowanceOnIncrementAllowanceTotal_r5(address o,address s,int m) private    {
      allowance[o][s].n += m;
  }
  function updateTotalSupplyOnIncrementAllMint_r10(int m) private    {
      totalSupply.n += m;
  }
  function updateBalanceOfOnIncrementTotalMint_r12(address p,int n) private    {
      balanceOf[p].n += n;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r13(address o,address r,int n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        if(true) {
          int k = allowanceTuple.n;
          BalanceOfTuple memory balanceOfTuple = balanceOf[o];
          if(true) {
            int m = balanceOfTuple.n;
            if(m>=n && k>=n) {
              updateSpentTotalOnInsertTransferFrom_r17(o,s,n);
              emit TransferFrom(o,r,s,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r16(address o,address s,int n) private   returns (bool) {
      if(o==msg.sender) {
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        if(true) {
          int m = allowanceTuple.n;
          if(true) {
            int d = n-m;
            updateAllowanceTotalOnInsertIncreaseAllowance_r4(o,s,d);
            emit IncreaseAllowance(o,s,d);
            return true;
          }
        }
      }
      return false;
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r4(address o,address s,int n) private    {
      int delta = n;
      updateAllowanceOnIncrementAllowanceTotal_r5(o,s,delta);
  }
  function updateBalanceOfOnIncrementTotalIn_r12(address p,int i) private    {
      balanceOf[p].n += i;
  }
  function updateTransferOnInsertRecv_transferFrom_r8(address o,address r,int n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        if(true) {
          int k = allowanceTuple.n;
          BalanceOfTuple memory balanceOfTuple = balanceOf[o];
          if(true) {
            int m = balanceOfTuple.n;
            if(m>=n && k>=n) {
              updateTotalInOnInsertTransfer_r1(r,n);
              updateTotalOutOnInsertTransfer_r6(o,n);
              emit Transfer(o,r,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalOut_r12(address p,int o) private    {
      balanceOf[p].n -= o;
  }
  function updateBurnOnInsertRecv_burn_r11(address p,int n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          BalanceOfTuple memory balanceOfTuple = balanceOf[p];
          if(true) {
            int m = balanceOfTuple.n;
            if(n<=m) {
              updateAllBurnOnInsertBurn_r9(n);
              updateTotalBurnOnInsertBurn_r7(p,n);
              emit Burn(p,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateTotalInOnInsertTransfer_r1(address p,int n) private    {
      int delta = n;
      updateBalanceOfOnIncrementTotalIn_r12(p,delta);
  }
  function updateSpentTotalOnInsertTransferFrom_r17(address o,address s,int n) private    {
      int delta = n;
      updateAllowanceOnIncrementSpentTotal_r5(o,s,delta);
  }
  function updateMintOnInsertRecv_mint_r2(address p,int n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(n>0) {
            updateAllMintOnInsertMint_r0(n);
            updateTotalMintOnInsertMint_r14(p,n);
            emit Mint(p,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateTotalBurnOnInsertBurn_r7(address p,int n) private    {
      int delta = n;
      updateBalanceOfOnIncrementTotalBurn_r12(p,delta);
  }
  function updateAllMintOnInsertMint_r0(int n) private    {
      int delta = n;
      updateTotalSupplyOnIncrementAllMint_r10(delta);
  }
  function updateTotalSupplyOnIncrementAllBurn_r10(int b) private    {
      totalSupply.n -= b;
  }
  function updateBalanceOfOnIncrementTotalBurn_r12(address p,int m) private    {
      balanceOf[p].n -= m;
  }
  function updateOwnerOnInsertConstructor_r15() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          owner = OwnerTuple(s,true);
        }
      }
  }
  function updateTotalMintOnInsertMint_r14(address p,int n) private    {
      int delta = n;
      updateBalanceOfOnIncrementTotalMint_r12(p,delta);
  }
  function updateAllowanceOnIncrementSpentTotal_r5(address o,address s,int l) private    {
      allowance[o][s].n -= l;
  }
}