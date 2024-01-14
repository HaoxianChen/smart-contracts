/**
 *Submitted for verification at Etherscan.io on 2017-09-03
*/
// on etherscan: https://etherscan.io/token/0xfec0cf7fe078a500abf15f1284958f22049c2c7e#code
// digitize artwork, art investment platform
// https://www.maecenas.co/whats-maecenas/


library SafeMath {
  function mul(uint256  a, uint256  b) internal returns (uint256)  {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal  returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal  returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal  returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

abstract contract IToken  {
  function totalSupply() public view virtual returns (uint256 totalSupply);
  function mintTokens(address _to, uint256 _amount) public {}
}
abstract contract IMintableToken {
  function mintTokens(address _to, uint256 _amount) public {}
}
abstract contract IERC20Token {
  function totalSupply() public view virtual returns (uint256 totalSupply);
  function balanceOf(address _owner) public view virtual returns (uint256 balance);
  function transfer(address _to, uint256 _value) public virtual returns (bool success);
  function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
  function approve(address _spender, uint256 _value) public virtual returns (bool success);
  function allowance(address _owner, address _spender) public view virtual returns (uint256 remaining);

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

abstract contract ItokenRecipient {
  function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) public {}
}

contract Owned {
    address public owner;
    address public newOwner;

    function Owned_cons() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        assert(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != owner);
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnerUpdate(owner, newOwner);
        owner = newOwner;
        newOwner = address(0x0);
    }

    event OwnerUpdate(address _prevOwner, address _newOwner);
}
contract ReentrnacyHandlingContract{

    bool locked;

    modifier noReentrancy() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }
}

contract Lockable is Owned{

  uint256 public lockedUntilBlock;

  event ContractLocked(uint256 _untilBlock, string  _reason);

  modifier lockAffected {
      require(block.number > lockedUntilBlock);
      _;
  }

  function lockFromSelf(uint256 _untilBlock, string memory _reason) internal {
    lockedUntilBlock = _untilBlock;
    emit ContractLocked(_untilBlock, _reason);
  }


  function lockUntil(uint256 _untilBlock, string memory _reason) public onlyOwner {
    lockedUntilBlock = _untilBlock;
    emit ContractLocked(_untilBlock, _reason);
  }
}


contract Token is IERC20Token, Owned, Lockable{

  using SafeMath for uint256;

  /* Public variables of the token */
  string public standard;
  string public name;
  string public symbol;
  uint8 public decimals;

  address public crowdsaleContractAddress;

  /* Private variables of the token */
  uint256 supply = 0;
  mapping (address => uint256) balances;
  mapping (address => mapping (address => uint256)) allowances;

  /* Events */
  event Mint(address indexed _to, uint256 _value);

  /* Returns total supply of issued tokens */
  function totalSupply()  public view  override returns (uint256) {
    return supply;
  }

  /* Returns balance of address */
  function balanceOf(address _owner) public view override returns (uint256 balance) {
    return balances[_owner];
  }

  /* Transfers tokens from your address to other */
  function transfer(address _to, uint256 _value) lockAffected public override returns (bool success) {
    require(_to != address(0x0) && _to != address(this));
    balances[msg.sender] = balances[msg.sender].sub(_value); // Deduct senders balance
    balances[_to] = balances[_to].add(_value);               // Add recivers blaance
    emit Transfer(msg.sender, _to, _value);                       // Raise Transfer event
    return true;
  }

  /* Approve other address to spend tokens on your account */
  function approve(address _spender, uint256 _value) lockAffected public override returns (bool success) {
    allowances[msg.sender][_spender] = _value;        // Set allowance
    emit Approval(msg.sender, _spender, _value);           // Raise Approval event
    return true;
  }

  /* Approve and then communicate the approved contract in a single tx */
  function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData) lockAffected public returns (bool success) {
    ItokenRecipient spender = ItokenRecipient(_spender);            // Cast spender to tokenRecipient contract
    approve(_spender, _value);                                      // Set approval to contract for _value
    spender.receiveApproval(msg.sender, _value, address(this), _extraData);  // Raise method on _spender contract
    return true;
  }

  /* A contract attempts to get the coins */
  function transferFrom(address _from, address _to, uint256 _value) lockAffected public override returns (bool success) {
    require(_to != address(0x0) && _to != address(this));
    balances[_from] = balances[_from].sub(_value);                              // Deduct senders balance
    balances[_to] = balances[_to].add(_value);                                  // Add recipient blaance
    allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);  // Deduct allowance for this address
    emit Transfer(_from, _to, _value);                                               // Raise Transfer event
    return true;
  }

  function allowance(address _owner, address _spender) public view override returns (uint256 remaining) {
    return allowances[_owner][_spender];
  }

  function mintTokens(address _to, uint256 _amount) public {
    require(msg.sender == crowdsaleContractAddress);

    supply = supply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Mint(_to, _amount);
    emit Transfer(address(0x0), _to, _amount);
  }

  function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) public onlyOwner{
    IERC20Token(_tokenAddress).transfer(_to, _amount);
  }
}



contract MaecenasToken is Token {

  /* Initializes contract */
  function MaecenasToken_cons() public {
    standard = "Maecenas token v1.0";
    name = "Maecenas ART Token";
    symbol = "ART";
    decimals = 18;
    crowdsaleContractAddress = 0x9B60874D7bc4e4fBDd142e0F5a12002e4F7715a6; 
    lockFromSelf(4366494, "Lock before crowdsale starts");
  }
}