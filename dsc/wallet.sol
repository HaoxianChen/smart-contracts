contract Wallet {
  struct TotalSupplyTuple {
    uint n;
  }
  struct OwnerTuple {
    address p;
  }
  struct MsgSenderTuple {
    address p;
  }
  struct BalanceOfTuple {
    address p;
    uint n;
  }
  OwnerTuple owner;
  mapping(address=>uint) balanceOf;
  TotalSupplyTuple totalSupply;
  constructor() public {
    updateOwnerOnConstructor();
  }
  function transfer(address from,address to,uint amount) public  {
    updateTransferOnRecv_transfer(from,to,amount);
  }
  function getTotalSupply() public view returns (uint) {
    uint n = totalSupply.n;
    return n;
  }
  function mint(address p,uint amount) public  {
    updateMintOnRecv_mint(p,amount);
  }
  function burn(address p,uint amount) public  {
    updateBurnOnRecv_burn(p,amount);
  }
  function getBalanceOf(address p) public view returns (uint) {
    BalanceOfTuple memory balanceOfTuple = balanceOf[p];
    uint n = balanceOfTuple.n;
    return n;
  }
  function updateOwnerOnConstructor() private  {
    if(true) {
      address s = msg.sender;
      if(true) {
        owner = OwnerTuple(s);
      }
    }
  }
  function updateMintOnRecv_mint(address p,uint n) private  {
    address s = owner.p;
    require(s==msg.sender,"condition s==msg.sender is false.");
    require(n>0,"condition n>0 is false.");
    updateTotalMintOnMint(p,n);
    updateAllMintOnMint(n);
  }
  function updateTransferOnRecv_transfer(address s,address r,uint n) private  {
    BalanceOfTuple memory balanceOfTuple = balanceOf[s];
    uint m = balanceOfTuple.n;
    require(n>=m,"condition n>=m is false.");
    updateTotalOutOnTransfer(s,n);
    updateTotalInOnTransfer(r,n);
  }
  function updateBurnOnRecv_burn(address p,uint n) private  {
    address s = owner.p;
    require(s==msg.sender,"condition s==msg.sender is false.");
    BalanceOfTuple memory balanceOfTuple = balanceOf[p];
    uint m = balanceOfTuple.n;
    require(n<=m,"condition n<=m is false.");
    updateTotalBurnOnBurn(p,n);
    updateAllBurnOnBurn(n);
  }
  function updateTotalBurnOnBurn(address p,uint n) private  {
    uint delta = n;
    updateBalanceOfOnTotalBurn(p,delta);
  }
  function updateAllBurnOnBurn(uint n) private  {
    uint delta = n;
    updateTotalSupplyOnAllBurn(delta);
  }
  function updateAllMintOnMint(uint n) private  {
    uint delta = n;
    updateTotalSupplyOnAllMint(delta);
  }
  function updateTotalMintOnMint(address p,uint n) private  {
    uint delta = n;
    updateBalanceOfOnTotalMint(p,delta);
  }
  function updateTotalOutOnTransfer(address p,uint n) private  {
    uint delta = n;
    updateBalanceOfOnTotalOut(p,delta);
  }
  function updateTotalInOnTransfer(address p,uint n) private  {
    uint delta = n;
    updateBalanceOfOnTotalIn(p,delta);
  }
  function updateTotalSupplyOnAllMint(uint m) private  {
    totalSupply.n += m;
  }
  function updateBalanceOfOnTotalMint(address p,uint n) private  {
    balanceOf[p].n += n;
  }
  function updateBalanceOfOnTotalIn(address p,uint i) private  {
    balanceOf[p].n += i;
  }
  function updateBalanceOfOnTotalBurn(address p,uint m) private  {
    balanceOf[p].n -= m;
  }
  function updateTotalSupplyOnAllBurn(uint b) private  {
    totalSupply.n -= b;
  }
  function updateBalanceOfOnTotalOut(address p,uint o) private  {
    balanceOf[p].n -= o;
  }
}