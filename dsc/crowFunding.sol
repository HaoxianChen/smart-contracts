contract CrowFunding {
  struct TargetTuple {
    uint t;
  }
  struct RaisedTuple {
    uint n;
  }
  struct ClosedTuple {
    bool b;
  }
  struct BeneficiaryTuple {
    address p;
  }
  struct OwnerTuple {
    address p;
  }
  struct MsgSenderTuple {
    address p;
  }
  struct MsgValueTuple {
    uint p;
  }
  struct BalanceOfTuple {
    address p;
    uint n;
  }
  TargetTuple target;
  RaisedTuple raised;
  ClosedTuple closed;
  BeneficiaryTuple beneficiary;
  mapping(address=>uint) balanceOf;
  OwnerTuple owner;
  constructor(uint t,address b) public {
    updateOwnerOnConstructor();
    updateTargetOnConstructor(t);
    updateBeneficiaryOnConstructor(b);
  }
  function getRaised() public view returns (uint) {
    uint n = raised.n;
    return n;
  }
  function invest() public  {
    updateInvestOnRecv_invest();
  }
  function getClosed() public view returns (bool) {
    bool b = closed.b;
    return b;
  }
  function close() public  {
    updateClosedOnRecv_close();
  }
  function refund() public  {
    updateRefundOnRecv_refund();
  }
  function withdraw() public  {
    updateWithdrawOnRecv_withdraw();
  }
  function updateBeneficiaryOnConstructor(address p) private  {
    if(true) {
      beneficiary = BeneficiaryTuple(p);
    }
  }
  function updateTargetOnConstructor(uint t) private  {
    if(true) {
      target = TargetTuple(t);
    }
  }
  function updateOwnerOnConstructor() private  {
    if(true) {
      address p = msg.sender;
      if(true) {
        owner = OwnerTuple(p);
      }
    }
  }
  function updateRefundOnRecv_refund() private  {
    require(true==closed.b,"condition true==closed.b is false.");
    address p = msg.sender;
    uint t = target.t;
    uint r = raised.n;
    BalanceOfTuple memory balanceOfTuple = balanceOf[p];
    uint n = balanceOfTuple.n;
    require(r<t && n>0,"condition r<t && n>0 is false.");
    updateRefundTotalOnRefund(p,n);
  }
  function updateInvestOnRecv_invest() private  {
    require(false==closed.b,"condition false==closed.b is false.");
    uint s = raised.n;
    uint t = target.t;
    uint n = msg.value;
    address p = msg.sender;
    require(s<t,"condition s<t is false.");
    updateInvestTotalOnInvest(p,n);
    updateRaisedOnInvest(n);
  }
  function updateClosedOnRecv_close() private  {
    address s = owner.p;
    require(s==msg.sender,"condition s==msg.sender is false.");
    closed = ClosedTuple(true);
  }
  function updateWithdrawOnRecv_withdraw() private  {
    address p = beneficiary.p;
    uint t = target.t;
    uint r = raised.n;
    require(p==msg.sender,"condition p==msg.sender is false.");
    require(r>=t,"condition r>=t is false.");
  }
  function updateInvestTotalOnInvest(address p,uint m) private  {
    uint delta = m;
    updateBalanceOfOnInvestTotal(p,delta);
  }
  function updateRaisedOnInvest(uint m) private  {
    raised.n += m;
  }
  function updateRefundTotalOnRefund(address p,uint m) private  {
    uint delta = m;
    updateBalanceOfOnRefundTotal(p,delta);
  }
  function updateBalanceOfOnInvestTotal(address p,uint i) private  {
    balanceOf[p].n += i;
  }
  function updateBalanceOfOnRefundTotal(address p,uint r) private  {
    balanceOf[p].n -= r;
  }
}