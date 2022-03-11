contract Wallet {
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
  struct NegativeBalanceKeyTuple {
    address p;
  }
  mapping(address=>BalanceOfTuple) balanceOf;
  TotalSupplyTuple totalSupply;
  OwnerTuple owner;
  NegativeBalanceKeyTuple[] negativeBalanceKeyArray;
  event Transfer(address from,address to,int amount);
  event Mint(address p,int amount);
  event Burn(address p,int amount);
  constructor() public {
    updateOwnerOnInsertConstructor_r4();
  }
  function mint(address p,int amount) public    {
      bool r2 = updateMintOnInsertRecv_mint_r2(p,amount);
      if(r2==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (int) {
      int n = totalSupply.n;
      return n;
  }
  function transfer(address from,address to,int amount) public    {
      bool r3 = updateTransferOnInsertRecv_transfer_r3(from,to,amount);
      if(r3==false) {
        revert("Rule condition failed");
      }
  }
  function burn(address p,int amount) public    {
      bool r12 = updateBurnOnInsertRecv_burn_r12(p,amount);
      if(r12==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (int) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      int n = balanceOfTuple.n;
      return n;
  }
  function updateOwnerOnInsertConstructor_r4() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          owner = OwnerTuple(s,true);
        }
      }
  }
  function updateAllBurnOnInsertBurn_r10(int n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllBurn_r11(delta);
  }
  function updateAllMintOnInsertMint_r0(int n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllMint_r11(delta);
  }
  function updateBurnOnInsertRecv_burn_r12(address p,int n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          BalanceOfTuple memory balanceOfTuple = balanceOf[p];
          if(true) {
            int m = balanceOfTuple.n;
            if(n<=m) {
              updateTransferOnInsertBurn_r6(p,n);
              updateAllBurnOnInsertBurn_r10(n);
              emit Burn(p,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateTotalSupplyOnIncrementAllMint_r11(int m) private    {
      totalSupply.n += m;
  }
  function updateintByint(int x,int delta) private   returns (int) {
      int newValue = x+delta;
      return newValue;
  }
  function updateTotalInOnInsertTransfer_r8(address p,int n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalIn_r1(p,delta);
  }
  function updateBalanceOfOnIncrementTotalOut_r1(address p,int o) private    {
      balanceOf[p].n -= o;
  }
  function updateTransferOnInsertBurn_r6(address p,int n) private    {
      if(true) {
        updateTotalInOnInsertTransfer_r8(address(0),n);
        updateTotalOutOnInsertTransfer_r5(p,n);
        emit Transfer(p,address(0),n);
      }
  }
  function updateTotalOutOnInsertTransfer_r5(address p,int n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalOut_r1(p,delta);
  }
  function updateMintOnInsertRecv_mint_r2(address p,int n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(n>0) {
            updateAllMintOnInsertMint_r0(n);
            updateTransferOnInsertMint_r9(p,n);
            emit Mint(p,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateTransferOnInsertRecv_transfer_r3(address s,address r,int n) private   returns (bool) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[s];
      if(true) {
        int m = balanceOfTuple.n;
        if(m>=n) {
          updateTotalOutOnInsertTransfer_r5(s,n);
          updateTotalInOnInsertTransfer_r8(r,n);
          emit Transfer(s,r,n);
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalIn_r1(address p,int i) private    {
      balanceOf[p].n += i;
  }
  function updateTotalSupplyOnIncrementAllBurn_r11(int b) private    {
      totalSupply.n -= b;
  }
  function updateTransferOnInsertMint_r9(address p,int n) private    {
      if(true) {
        updateTotalInOnInsertTransfer_r8(p,n);
        updateTotalOutOnInsertTransfer_r5(address(0),n);
        emit Transfer(address(0),p,n);
      }
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
}