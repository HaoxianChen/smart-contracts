contract Stbt {
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct PermissionTuple {
    bool sendAllowed;
    bool receiveAllowed;
    uint expiryTime;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  struct LastDistributeTimeTuple {
    uint time;
    bool _valid;
  }
  struct MinIntervalTuple {
    uint time;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  LastDistributeTimeTuple lastDistributeTime;
  MinIntervalTuple minInterval;
  TotalSupplyTuple totalSupply;
  mapping(address=>PermissionTuple) permission;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  OwnerTuple owner;
  event DistributeInterests(uint n,uint time);
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event Mint(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event Transfer(address from,address to,uint amount);
  constructor() public {
    updateTotalBalancesOnInsertConstructor_r28();
    updateTotalSupplyOnInsertConstructor_r1();
    updateOwnerOnInsertConstructor_r8();
  }
  function approve(address s,uint n) public    {
      bool r26 = updateIncreaseAllowanceOnInsertRecv_approve_r26(s,n);
      if(r26==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address p,uint amount) public    {
      bool r24 = updateMintOnInsertRecv_mint_r24(p,amount);
      if(r24==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      AllowanceTuple memory allowanceTuple = allowance[p][s];
      uint n = allowanceTuple.n;
      return n;
  }
  function transfer(address to,uint amount) public    {
      bool r4 = updateTransferOnInsertRecv_transfer_r4(to,amount);
      if(r4==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r21 = updateTransferFromOnInsertRecv_transferFrom_r21(from,to,amount);
      if(r21==false) {
        revert("Rule condition failed");
      }
  }
  function burn(address p,uint amount) public    {
      bool r15 = updateBurnOnInsertRecv_burn_r15(p,amount);
      if(r15==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function distributeInterests(uint n) public    {
      bool r17 = updateDistributeInterestsOnInsertRecv_distributeInterests_r17(n);
      if(r17==false) {
        revert("Rule condition failed");
      }
  }
  function updateDistributeTotalOnInsertDistributeInterests_r9(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementDistributeTotal_r20(delta);
  }
  function updateAllBurnOnInsertBurn_r25(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllBurn_r20(delta);
  }
  function updateAllowanceOnIncrementSpentTotal_r23(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateAllowanceOnIncrementAllowanceTotal_r23(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateBurnOnInsertRecv_burn_r15(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          BalanceOfTuple memory balanceOfTuple = balanceOf[p];
          if(true) {
            uint m = balanceOfTuple.n;
            if(p!=address(0) && n<=m) {
              updateTotalBurnOnInsertBurn_r13(p,n);
              updateAllBurnOnInsertBurn_r25(n);
              emit Burn(p,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateTotalBurnOnInsertBurn_r13(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalBurn_r6(p,delta);
  }
  function updateTransferOnInsertRecv_transfer_r4(address r,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        BalanceOfTuple memory balanceOfTuple = balanceOf[s];
        if(true) {
          uint m = balanceOfTuple.n;
          if(n<=m && canSend(s) && canRecv(r)) {
            updateTotalOutOnInsertTransfer_r18(s,n);
            updateTotalInOnInsertTransfer_r10(r,n);
            emit Transfer(s,r,n);
            return true;
          }
        }
      }
      return false;
  }
  function canRecv(address s) private view  returns (bool) {
      PermissionTuple memory permissionTuple = permission[s];
      if(true==permissionTuple.receiveAllowed && 0==permissionTuple.expiryTime) {
        if(true) {
          return true;
        }
      }
      if(true) {
        uint t = block.timestamp;
        PermissionTuple memory permissionTuple = permission[s];
        if(true==permissionTuple.receiveAllowed) {
          uint recvExpire = permissionTuple.expiryTime;
          if(t<recvExpire) {
            return true;
          }
        }
      }
      return false;
  }
  function updateAllMintOnInsertMint_r2(uint n) private    {
      int delta = int(n);
      updateTotalSupplyOnIncrementAllMint_r20(delta);
  }
  function updateBalanceOfOnIncrementTotalBurn_r6(address p,int m) private    {
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalOutOnInsertTransfer_r18(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalOut_r6(p,delta);
  }
  function updateTotalInOnInsertTransfer_r10(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalIn_r6(p,delta);
  }
  function updateLastDistributeTimeOnInsertDistributeInterests_r3(uint t) private    {
      LastDistributeTimeTuple memory lastDistributeTimeTuple = lastDistributeTime;
      uint _max = lastDistributeTime.time;
      if(t>_max) {
        lastDistributeTime = LastDistributeTimeTuple(m,true);
      }
  }
  function updateTotalSupplyOnIncrementAllBurn_r20(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateTotalMintOnInsertMint_r14(address p,uint n) private    {
      int delta = int(n);
      updateBalanceOfOnIncrementTotalMint_r6(p,delta);
  }
  function updateTotalSupplyOnIncrementDistributeTotal_r20(int d) private    {
      int _delta = int(((-0)-1)*d);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r26(address s,uint n) private   returns (bool) {
      if(true) {
        address o = msg.sender;
        AllowanceTuple memory allowanceTuple = allowance[o][s];
        if(true) {
          uint m = allowanceTuple.n;
          if(true) {
            uint d = n-m;
            updateAllowanceTotalOnInsertIncreaseAllowance_r27(o,s,d);
            emit IncreaseAllowance(o,s,d);
            return true;
          }
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
  function updateDistributeInterestsOnInsertRecv_distributeInterests_r17(uint n) private   returns (bool) {
      if(true) {
        uint t1 = lastDistributeTime.time;
        if(true) {
          uint i = minInterval.time;
          if(true) {
            uint t = block.timestamp;
            if(t1-t>i) {
              updateDistributeTotalOnInsertDistributeInterests_r9(n);
              updateLastDistributeTimeOnInsertDistributeInterests_r3(t);
              emit DistributeInterests(n,t);
              return true;
            }
          }
        }
      }
      return false;
  }
  function canSend(address s) private view  returns (bool) {
      PermissionTuple memory permissionTuple = permission[s];
      if(true==permissionTuple.sendAllowed && 0==permissionTuple.expiryTime) {
        if(true) {
          return true;
        }
      }
      if(true) {
        uint t = block.timestamp;
        PermissionTuple memory permissionTuple = permission[s];
        if(true==permissionTuple.sendAllowed) {
          uint sendExpire = permissionTuple.expiryTime;
          if(t<sendExpire) {
            return true;
          }
        }
      }
      return false;
  }
  function updateOwnerOnInsertConstructor_r8() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          owner = OwnerTuple(s,true);
        }
      }
  }
  function updateTransferFromOnInsertRecv_transferFrom_r21(address o,address r,uint n) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        BalanceOfTuple memory balanceOfTuple = balanceOf[o];
        if(true) {
          uint m = balanceOfTuple.n;
          AllowanceTuple memory allowanceTuple = allowance[o][s];
          if(true) {
            uint k = allowanceTuple.n;
            if(m>=n && k>=n && canSend(s) && canRecv(r)) {
              updateTransferOnInsertTransferFrom_r12(o,r,n);
              updateSpentTotalOnInsertTransferFrom_r7(o,s,n);
              emit TransferFrom(o,r,s,n);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateTotalBalancesOnInsertConstructor_r28() private    {
      if(true) {
        // Empty()
      }
  }
  function updateSpentTotalOnInsertTransferFrom_r7(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementSpentTotal_r23(o,s,delta);
  }
  function updateBalanceOfOnIncrementTotalMint_r6(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalSupplyOnIncrementAllMint_r20(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateTotalSupplyOnInsertConstructor_r1() private    {
      if(true) {
        totalSupply = TotalSupplyTuple(0,true);
      }
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r27(address o,address s,uint n) private    {
      int delta = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r23(o,s,delta);
  }
  function updateBalanceOfOnIncrementTotalOut_r6(address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateMintOnInsertRecv_mint_r24(address p,uint n) private   returns (bool) {
      if(true) {
        address s = owner.p;
        if(s==msg.sender) {
          if(p!=address(0)) {
            updateTotalMintOnInsertMint_r14(p,n);
            updateAllMintOnInsertMint_r2(n);
            emit Mint(p,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalIn_r6(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTransferOnInsertTransferFrom_r12(address o,address r,uint n) private    {
      if(true) {
        updateTotalOutOnInsertTransfer_r18(o,n);
        updateTotalInOnInsertTransfer_r10(r,n);
        emit Transfer(o,r,n);
      }
  }
}