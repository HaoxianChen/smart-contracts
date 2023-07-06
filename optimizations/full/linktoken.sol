contract Linktoken {
  struct TotalInTuple {
    uint n;
    bool _valid;
  }
  struct TotalOutTuple {
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalMintTuple {
    uint n;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct AllMintTuple {
    uint n;
    bool _valid;
  }
  struct AllowanceTotalTuple {
    uint m;
    bool _valid;
  }
  struct SpentTotalTuple {
    uint m;
    bool _valid;
  }
  struct TotalBurnTuple {
    uint n;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  struct AllBurnTuple {
    uint n;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  mapping(address=>TotalInTuple) totalIn;
  mapping(address=>TotalOutTuple) totalOut;
  mapping(address=>TotalBurnTuple) totalBurn;
  OwnerTuple owner;
  mapping(address=>TotalMintTuple) totalMint;
  TotalSupplyTuple totalSupply;
  AllMintTuple allMint;
  mapping(address=>mapping(address=>AllowanceTotalTuple)) allowanceTotal;
  mapping(address=>mapping(address=>SpentTotalTuple)) spentTotal;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  mapping(address=>BalanceOfTuple) balanceOf;
  AllBurnTuple allBurn;
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
  function updateAllBurnOnInsertBurn_r20(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r13(delta0);
      allBurn.n += n;
  }
  function updateOwnerOnInsertConstructor_r9() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateSpentTotalOnInsertTransferFrom_r16(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r18(o,s,delta0);
      spentTotal[o][s].m += n;
  }
  function updateBalanceOfOnIncrementTotalOut_r7(address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateAllMintOnInsertMint_r2(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllMint_r13(delta0);
      allMint.n += n;
  }
  function updateTotalBalancesOnInsertConstructor_r22(uint n) private    {
      // Empty()
  }
  function updateTotalSupplyOnInsertConstructor_r17(uint n) private    {
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateTotalSupplyOnIncrementAllBurn_r13(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateBalanceOfOnIncrementTotalBurn_r7(address p,int m) private    {
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBurnOnInsertRecv_burn_r6(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        BalanceOfTuple memory balanceOfTuple = balanceOf[p];
        uint m = balanceOfTuple.n;
        if(p!=address(0) && n<=m) {
          updateAllBurnOnInsertBurn_r20(n);
          updateTotalBurnOnInsertBurn_r11(p,n);
          emit Burn(p,n);
          return true;
        }
      }
      return false;
  }
  function updateAllowanceOnIncrementAllowanceTotal_r18(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateMintOnInsertRecv_mint_r19(address p,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          updateAllMintOnInsertMint_r2(n);
          updateTotalMintOnInsertMint_r12(p,n);
          emit Mint(p,n);
          return true;
        }
      }
      return false;
  }
  function updateTotalOutOnInsertTransfer_r14(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r7(p,delta0);
      totalOut[p].n += n;
  }
  function updateTotalMintOnInsertMint_r12(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalMint_r7(p,delta0);
      totalMint[p].n += n;
  }
  function updateBalanceOfOnInsertConstructor_r8(uint n) private    {
      address p = msg.sender;
      balanceOf[p] = BalanceOfTuple(n,true);
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r21(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint m = allowanceTuple.n;
      if(validRecipient(s)) {
        uint d = n-m;
        updateAllowanceTotalOnInsertIncreaseAllowance_r23(o,s,d);
        emit IncreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updateTotalBurnOnInsertBurn_r11(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r7(p,delta0);
      totalBurn[p].n += n;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r0(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[o];
      uint m = balanceOfTuple.n;
      AllowanceTuple memory allowanceTuple = allowance[o][s];
      uint k = allowanceTuple.n;
      if(m>=n && k>=n && validRecipient(r)) {
        updateSpentTotalOnInsertTransferFrom_r16(o,s,n);
        updateTransferOnInsertTransferFrom_r1(o,r,n);
        emit TransferFrom(o,r,s,n);
        return true;
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
  function updateAllowanceTotalOnInsertIncreaseAllowance_r23(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r18(o,s,delta0);
      allowanceTotal[o][s].m += n;
  }
  function updateTransferOnInsertTransferFrom_r1(address o,address r,uint n) private    {
      updateTotalOutOnInsertTransfer_r14(o,n);
      updateTotalInOnInsertTransfer_r10(r,n);
      emit Transfer(o,r,n);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateTotalInOnInsertTransfer_r10(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r7(p,delta0);
      totalIn[p].n += n;
  }
  function updateTotalSupplyOnIncrementAllMint_r13(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateAllowanceOnIncrementSpentTotal_r18(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateTransferOnInsertRecv_transfer_r5(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      BalanceOfTuple memory balanceOfTuple = balanceOf[s];
      uint m = balanceOfTuple.n;
      if(n<=m && validRecipient(r)) {
        updateTotalOutOnInsertTransfer_r14(s,n);
        updateTotalInOnInsertTransfer_r10(r,n);
        emit Transfer(s,r,n);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalIn_r7(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBalanceOfOnIncrementTotalMint_r7(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
}