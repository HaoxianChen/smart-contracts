contract Nft {
  struct OwnerOfTuple {
    address p;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct ApprovedTuple {
    bool b;
    bool _valid;
  }
  struct LatestTransferTuple {
    address from;
    address to;
    uint time;
    bool _valid;
  }
  struct ApprovalTuple {
    address p;
    bool b;
    bool _valid;
  }
  struct ExistsTuple {
    bool b;
    bool _valid;
  }
  struct IsApprovedForAllTuple {
    bool b;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  mapping(uint=>OwnerOfTuple) ownerOf;
  mapping(uint=>mapping(address=>ApprovedTuple)) approved;
  mapping(uint=>LatestTransferTuple) latestTransfer;
  mapping(address=>mapping(uint=>ApprovalTuple)) approval;
  mapping(uint=>ExistsTuple) exists;
  mapping(address=>mapping(address=>IsApprovedForAllTuple)) isApprovedForAll;
  mapping(address=>BalanceOfTuple) balanceOf;
  OwnerTuple owner;
  event Transfer(uint tokenId,address from,address to,uint time);
  event Approval(address o,uint tokenId,address p,bool b);
  event IsApprovedForAll(address owner,address operator,bool b);
  constructor() public {
    updateOwnerOnInsertConstructor_r10();
  }
  function getOwnerOf(uint tokenId) public view  returns (address) {
      OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
      address p = ownerOfTuple.p;
      return p;
  }
  function transfer(address to,uint tokenId) public    {
      bool r9 = updateTransferOnInsertRecv_transfer_r9(to,tokenId);
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function getIsApprovedForAll(address owner,address operator) public view  returns (bool) {
      IsApprovedForAllTuple memory isApprovedForAllTuple = isApprovedForAll[owner][operator];
      bool b = isApprovedForAllTuple.b;
      return b;
  }
  function getApproved(uint tokenId,address p) public view  returns (bool) {
      ApprovedTuple memory approvedTuple = approved[tokenId][p];
      bool b = approvedTuple.b;
      return b;
  }
  function mint(uint tokenId,address to) public    {
      bool r3 = updateTransferOnInsertRecv_mint_r3(tokenId,to);
      if(r3==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function setApprovalForAll(address operator,bool _approved) public    {
      bool r2 = updateIsApprovedForAllOnInsertRecv_setApprovalForAll_r2(operator,_approved);
      if(r2==false) {
        revert("Rule condition failed");
      }
  }
  function burn(uint tokenId) public    {
      bool r12 = updateTransferOnInsertRecv_burn_r12(tokenId);
      if(r12==false) {
        revert("Rule condition failed");
      }
  }
  function setApproval(uint tokenId,address p,bool b) public    {
      bool r1 = updateApprovalOnInsertRecv_setApproval_r1(tokenId,p,b);
      if(r1==false) {
        revert("Rule condition failed");
      }
  }
  function getExists(uint tokenId) public view  returns (bool) {
      ExistsTuple memory existsTuple = exists[tokenId];
      bool b = existsTuple.b;
      return b;
  }
  function transferFrom(address from,address to,uint tokenId) public    {
      bool r7 = updateTransferOnInsertRecv_transferFrom_r7(from,to,tokenId);
      bool r6 = updateTransferOnInsertRecv_transferFrom_r6(from,to,tokenId);
      if(r7==false && r6==false) {
        revert("Rule condition failed");
      }
  }
  function updateIsApprovedForAllOnInsertRecv_setApprovalForAll_r2(address o,bool b) private   returns (bool) {
      address p = msg.sender;
      isApprovedForAll[p][o] = IsApprovedForAllTuple(b,true);
      emit IsApprovedForAll(p,o,b);
      return true;
      return false;
  }
  function updateApprovedOnDeleteOwnerOf_r4(uint tokenId,address o) private    {
      ApprovalTuple memory approvalTuple = approval[o][tokenId];
      address p = approvalTuple.p;
      bool b = approvalTuple.b;
      ApprovedTuple memory approvedTuple = approved[tokenId][p];
      if(b==approvedTuple.b) {
        approved[tokenId][p] = ApprovedTuple(false,false);
      }
  }
  function updateApprovedOnDeleteApproval_r4(address o,uint tokenId,address p,bool b) private    {
      OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
      if(o==ownerOfTuple.p) {
        ApprovedTuple memory approvedTuple = approved[tokenId][p];
        if(b==approvedTuple.b) {
          approved[tokenId][p] = ApprovedTuple(false,false);
        }
      }
  }
  function updateBalanceOfOnDeleteOwnerOf_r5(uint _tokenId0,address p) private    {
      int _delta = int(-1);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateApprovedOnInsertOwnerOf_r4(uint tokenId,address o) private    {
      OwnerOfTuple memory toDelete = ownerOf[tokenId];
      if(toDelete._valid==true) {
        updateApprovedOnDeleteOwnerOf_r4(tokenId,toDelete.p);
      }
      ApprovalTuple memory approvalTuple = approval[o][tokenId];
      address p = approvalTuple.p;
      bool b = approvalTuple.b;
      approved[tokenId][p] = ApprovedTuple(b,true);
  }
  function updateOwnerOfOnInsertLatestTransfer_r0(uint tokenId,address p) private    {
      LatestTransferTuple memory toDelete = latestTransfer[tokenId];
      if(toDelete._valid==true) {
        updateOwnerOfOnDeleteLatestTransfer_r0(tokenId,toDelete.to);
      }
      if(p!=address(0)) {
        updateApprovedOnInsertOwnerOf_r4(tokenId,p);
        updateBalanceOfOnInsertOwnerOf_r5(tokenId,p);
        ownerOf[tokenId] = OwnerOfTuple(p,true);
      }
  }
  function updateTransferOnInsertRecv_transferFrom_r7(address s,address r,uint tokenId) private   returns (bool) {
      address o = msg.sender;
      uint time = block.timestamp;
      OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
      if(s==ownerOfTuple.p) {
        IsApprovedForAllTuple memory isApprovedForAllTuple = isApprovedForAll[s][o];
        if(true==isApprovedForAllTuple.b) {
          if(r!=address(0)) {
            updateLatestTransferOnInsertTransfer_r13(tokenId,s,r,time);
            emit Transfer(tokenId,s,r,time);
            return true;
          }
        }
      }
      return false;
  }
  function updateTransferOnInsertRecv_burn_r12(uint tokenId) private   returns (bool) {
      address s = msg.sender;
      uint time = block.timestamp;
      if(s==owner.p) {
        ExistsTuple memory existsTuple = exists[tokenId];
        if(true==existsTuple.b) {
          OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
          address p = ownerOfTuple.p;
          updateLatestTransferOnInsertTransfer_r13(tokenId,p,address(0),time);
          emit Transfer(tokenId,p,address(0),time);
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnInsertOwnerOf_r5(uint _tokenId0,address p) private    {
      OwnerOfTuple memory toDelete = ownerOf[_tokenId0];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteOwnerOf_r5(_tokenId0,toDelete.p);
      }
      int _delta = int(1);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateExistsOnInsertLatestTransfer_r11(uint tokenId,address to) private    {
      LatestTransferTuple memory toDelete = latestTransfer[tokenId];
      if(toDelete._valid==true) {
        updateExistsOnDeleteLatestTransfer_r11(tokenId,toDelete.to);
      }
      if(to!=address(0)) {
        exists[tokenId] = ExistsTuple(true,true);
      }
  }
  function updateExistsOnDeleteLatestTransfer_r11(uint tokenId,address to) private    {
      if(to!=address(0)) {
        ExistsTuple memory existsTuple = exists[tokenId];
        if(true==existsTuple.b) {
          exists[tokenId] = ExistsTuple(false,false);
        }
      }
  }
  function updateApprovalOnInsertRecv_setApproval_r1(uint tokenId,address p,bool b) private   returns (bool) {
      address o = msg.sender;
      OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
      if(o==ownerOfTuple.p) {
        updateApprovedOnInsertApproval_r4(o,tokenId,p,b);
        approval[o][tokenId] = ApprovalTuple(p,b,true);
        emit Approval(o,tokenId,p,b);
        return true;
      }
      return false;
  }
  function updateTransferOnInsertRecv_mint_r3(uint tokenId,address to) private   returns (bool) {
      address s = msg.sender;
      uint time = block.timestamp;
      if(s==owner.p) {
        ExistsTuple memory existsTuple = exists[tokenId];
        if(false==existsTuple.b) {
          if(to!=address(0)) {
            updateLatestTransferOnInsertTransfer_r13(tokenId,address(0),to,time);
            emit Transfer(tokenId,address(0),to,time);
            return true;
          }
        }
      }
      return false;
  }
  function updateTransferOnInsertRecv_transferFrom_r6(address s,address r,uint tokenId) private   returns (bool) {
      uint time = block.timestamp;
      ApprovedTuple memory approvedTuple = approved[tokenId][s];
      if(true==approvedTuple.b) {
        if(r!=address(0)) {
          updateLatestTransferOnInsertTransfer_r13(tokenId,s,r,time);
          emit Transfer(tokenId,s,r,time);
          return true;
        }
      }
      return false;
  }
  function updateOwnerOnInsertConstructor_r10() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateApprovedOnInsertApproval_r4(address o,uint tokenId,address p,bool b) private    {
      ApprovalTuple memory toDelete = approval[o][tokenId];
      if(toDelete._valid==true) {
        updateApprovedOnDeleteApproval_r4(o,tokenId,toDelete.p,toDelete.b);
      }
      OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
      if(o==ownerOfTuple.p) {
        approved[tokenId][p] = ApprovedTuple(b,true);
      }
  }
  function updateTransferOnInsertRecv_transfer_r9(address r,uint tokenId) private   returns (bool) {
      uint time = block.timestamp;
      address s = msg.sender;
      OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
      if(s==ownerOfTuple.p) {
        if(r!=address(0)) {
          updateLatestTransferOnInsertTransfer_r13(tokenId,s,r,time);
          emit Transfer(tokenId,s,r,time);
          return true;
        }
      }
      return false;
  }
  function updateLatestTransferOnInsertTransfer_r13(uint tokenId,address s,address r,uint t) private    {
      LatestTransferTuple memory latestTransferTuple = latestTransfer[tokenId];
      uint _max = latestTransferTuple.time;
      if(t>_max) {
        updateExistsOnInsertLatestTransfer_r11(tokenId,r);
        updateOwnerOfOnInsertLatestTransfer_r0(tokenId,r);
        latestTransfer[tokenId] = LatestTransferTuple(s,r,t,true);
      }
  }
  function updateOwnerOfOnDeleteLatestTransfer_r0(uint tokenId,address p) private    {
      if(p!=address(0)) {
        updateBalanceOfOnDeleteOwnerOf_r5(tokenId,p);
        updateApprovedOnDeleteOwnerOf_r4(tokenId,p);
        OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
        if(p==ownerOfTuple.p) {
          ownerOf[tokenId] = OwnerOfTuple(address(address(0)),false);
        }
      }
  }
}