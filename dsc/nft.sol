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
    updateOwnerOnInsertConstructor_r9();
  }
  function getOwnerOf(uint tokenId) public view  returns (address) {
      OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
      address p = ownerOfTuple.p;
      return p;
  }
  function burn(uint tokenId) public  checkViolations  {
      bool r11 = updateTransferOnInsertRecv_burn_r11(tokenId);
      if(r11==false) {
        revert("Rule condition failed");
      }
  }
  function transferFrom(address from,address to,uint tokenId) public  checkViolations  {
      bool r6 = updateTransferOnInsertRecv_transferFrom_r6(from,to,tokenId);
      bool r4 = updateTransferOnInsertRecv_transferFrom_r4(from,to,tokenId);
      if(r6==false && r4==false) {
        revert("Rule condition failed");
      }
  }
  function getExists(uint tokenId) public view  returns (bool) {
      ExistsTuple memory existsTuple = exists[tokenId];
      bool b = existsTuple.b;
      return b;
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
  function transfer(address to,uint tokenId) public  checkViolations  {
      bool r7 = updateTransferOnInsertRecv_transfer_r7(to,tokenId);
      if(r7==false) {
        revert("Rule condition failed");
      }
  }
  function setApprovalForAll(address operator,bool _approved) public  checkViolations  {
      bool r1 = updateIsApprovedForAllOnInsertRecv_setApprovalForAll_r1(operator,_approved);
      if(r1==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      BalanceOfTuple memory balanceOfTuple = balanceOf[p];
      uint n = balanceOfTuple.n;
      return n;
  }
  function mint(uint tokenId,address to) public  checkViolations  {
      bool r3 = updateTransferOnInsertRecv_mint_r3(tokenId,to);
      if(r3==false) {
        revert("Rule condition failed");
      }
  }
  function setApproval(uint tokenId,address p,bool b) public  checkViolations  {
      bool r8 = updateApprovalOnInsertRecv_setApproval_r8(tokenId,p,b);
      if(r8==false) {
        revert("Rule condition failed");
      }
  }
  modifier checkViolations() {
      // Empty()
      _;
      // Empty()
  }
  function updateTransferOnInsertRecv_burn_r11(uint tokenId) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        if(true) {
          uint time = block.timestamp;
          if(s==owner.p) {
            ExistsTuple memory existsTuple = exists[tokenId];
            if(true==existsTuple.b) {
              OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
              if(true) {
                address p = ownerOfTuple.p;
                if(true) {
                  updateLatestTransferOnInsertTransfer_r12(tokenId,p,address(0),time);
                  emit Transfer(tokenId,p,address(0),time);
                  return true;
                }
              }
            }
          }
        }
      }
      return false;
  }
  function updateIsApprovedForAllOnInsertRecv_setApprovalForAll_r1(address o,bool b) private   returns (bool) {
      if(true) {
        address p = msg.sender;
        if(true) {
          isApprovedForAll[p][o] = IsApprovedForAllTuple(b,true);
          emit IsApprovedForAll(p,o,b);
          return true;
        }
      }
      return false;
  }
  function updateTransferOnInsertRecv_transferFrom_r4(address s,address r,uint tokenId) private   returns (bool) {
      if(true) {
        address o = msg.sender;
        if(true) {
          uint time = block.timestamp;
          OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
          if(s==ownerOfTuple.p) {
            IsApprovedForAllTuple memory isApprovedForAllTuple = isApprovedForAll[s][o];
            if(true==isApprovedForAllTuple.b) {
              if(true) {
                updateLatestTransferOnInsertTransfer_r12(tokenId,s,r,time);
                emit Transfer(tokenId,s,r,time);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
  function updateTransferOnInsertRecv_transferFrom_r6(address s,address r,uint tokenId) private   returns (bool) {
      if(true) {
        uint time = block.timestamp;
        ApprovedTuple memory approvedTuple = approved[tokenId][s];
        if(true==approvedTuple.b) {
          if(true) {
            updateLatestTransferOnInsertTransfer_r12(tokenId,s,r,time);
            emit Transfer(tokenId,s,r,time);
            return true;
          }
        }
      }
      return false;
  }
  function updateLatestTransferOnInsertTransfer_r12(uint tokenId,address s,address r,uint t) private    {
      LatestTransferTuple memory latestTransferTuple = latestTransfer[tokenId];
      uint _max = latestTransferTuple.time;
      if(t>_max) {
        updateExistsOnInsertLatestTransfer_r10(tokenId,r);
        updateOwnerOfOnInsertLatestTransfer_r0(tokenId,r);
        latestTransfer[tokenId] = LatestTransferTuple(s,r,t,true);
      }
  }
  function updateBalanceOfOnInsertOwnerOf_r5(uint _tokenId0,address p) private    {
      OwnerOfTuple memory toDelete = ownerOf[_tokenId0];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteOwnerOf_r5(_tokenId0,toDelete.p);
      }
      balanceOf[p].n += 1;
  }
  function updateApprovedOnInsertOwnerOf_r2(uint tokenId,address o) private    {
      OwnerOfTuple memory toDelete = ownerOf[tokenId];
      if(toDelete._valid==true) {
        updateApprovedOnDeleteOwnerOf_r2(tokenId,toDelete.p);
      }
      ApprovalTuple memory approvalTuple = approval[o][tokenId];
      if(true) {
        address p = approvalTuple.p;
        bool b = approvalTuple.b;
        if(true) {
          approved[tokenId][p] = ApprovedTuple(b,true);
        }
      }
  }
  function updateOwnerOfOnInsertLatestTransfer_r0(uint tokenId,address p) private    {
      LatestTransferTuple memory toDelete = latestTransfer[tokenId];
      if(toDelete._valid==true) {
        updateOwnerOfOnDeleteLatestTransfer_r0(tokenId,toDelete.to);
      }
      if(p!=address(0)) {
        updateApprovedOnInsertOwnerOf_r2(tokenId,p);
        updateBalanceOfOnInsertOwnerOf_r5(tokenId,p);
        ownerOf[tokenId] = OwnerOfTuple(p,true);
      }
  }
  function updateApprovedOnInsertApproval_r2(address o,uint tokenId,address p,bool b) private    {
      ApprovalTuple memory toDelete = approval[o][tokenId];
      if(toDelete._valid==true) {
        updateApprovedOnDeleteApproval_r2(o,tokenId,toDelete.p,toDelete.b);
      }
      OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
      if(o==ownerOfTuple.p) {
        if(true) {
          approved[tokenId][p] = ApprovedTuple(b,true);
        }
      }
  }
  function updateApprovedOnDeleteApproval_r2(address o,uint tokenId,address p,bool b) private    {
      OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
      if(o==ownerOfTuple.p) {
        if(true) {
          ApprovedTuple memory approvedTuple = approved[tokenId][p];
          if(b==approvedTuple.b) {
            approved[tokenId][p] = ApprovedTuple(false,false);
          }
        }
      }
  }
  function updateBalanceOfOnDeleteOwnerOf_r5(uint _tokenId0,address p) private    {
      balanceOf[p].n -= 1;
  }
  function updateApprovalOnInsertRecv_setApproval_r8(uint tokenId,address p,bool b) private   returns (bool) {
      if(true) {
        address o = msg.sender;
        OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
        if(o==ownerOfTuple.p) {
          if(true) {
            updateApprovedOnInsertApproval_r2(o,tokenId,p,b);
            approval[o][tokenId] = ApprovalTuple(p,b,true);
            emit Approval(o,tokenId,p,b);
            return true;
          }
        }
      }
      return false;
  }
  function updateExistsOnInsertLatestTransfer_r10(uint tokenId,address to) private    {
      LatestTransferTuple memory toDelete = latestTransfer[tokenId];
      if(toDelete._valid==true) {
        updateExistsOnDeleteLatestTransfer_r10(tokenId,toDelete.to);
      }
      if(to!=address(0)) {
        exists[tokenId] = ExistsTuple(true,true);
      }
  }
  function updateOwnerOnInsertConstructor_r9() private    {
      if(true) {
        address s = msg.sender;
        if(true) {
          owner = OwnerTuple(s,true);
        }
      }
  }
  function updateExistsOnDeleteLatestTransfer_r10(uint tokenId,address to) private    {
      if(to!=address(0)) {
        ExistsTuple memory existsTuple = exists[tokenId];
        if(true==existsTuple.b) {
          exists[tokenId] = ExistsTuple(false,false);
        }
      }
  }
  function updateTransferOnInsertRecv_transfer_r7(address r,uint tokenId) private   returns (bool) {
      if(true) {
        uint time = block.timestamp;
        if(true) {
          address s = msg.sender;
          OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
          if(s==ownerOfTuple.p) {
            if(true) {
              updateLatestTransferOnInsertTransfer_r12(tokenId,s,r,time);
              emit Transfer(tokenId,s,r,time);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateTransferOnInsertRecv_mint_r3(uint tokenId,address to) private   returns (bool) {
      if(true) {
        address s = msg.sender;
        if(true) {
          uint time = block.timestamp;
          if(s==owner.p) {
            ExistsTuple memory existsTuple = exists[tokenId];
            if(false==existsTuple.b) {
              if(true) {
                updateLatestTransferOnInsertTransfer_r12(tokenId,address(0),to,time);
                emit Transfer(tokenId,address(0),to,time);
                return true;
              }
            }
          }
        }
      }
      return false;
  }
  function updateOwnerOfOnDeleteLatestTransfer_r0(uint tokenId,address p) private    {
      if(p!=address(0)) {
        updateBalanceOfOnDeleteOwnerOf_r5(tokenId,p);
        updateApprovedOnDeleteOwnerOf_r2(tokenId,p);
        OwnerOfTuple memory ownerOfTuple = ownerOf[tokenId];
        if(p==ownerOfTuple.p) {
          ownerOf[tokenId] = OwnerOfTuple(address(address(0)),false);
        }
      }
  }
  function updateApprovedOnDeleteOwnerOf_r2(uint tokenId,address o) private    {
      ApprovalTuple memory approvalTuple = approval[o][tokenId];
      if(true) {
        address p = approvalTuple.p;
        bool b = approvalTuple.b;
        if(true) {
          ApprovedTuple memory approvedTuple = approved[tokenId][p];
          if(b==approvedTuple.b) {
            approved[tokenId][p] = ApprovedTuple(false,false);
          }
        }
      }
  }
}