/**
 *Submitted for verification at Etherscan.io on 2017-09-23
*/

// pragma solidity ^0.4.16;
pragma solidity ^0.8.0;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
// library SafeMath {
//   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
//     uint256 c = a * b;
//     require(a == 0 || c / a == b);
//     return c;
//   }
// 
//   function div(uint256 a, uint256 b) internal pure returns (uint256) {
//     // assert(b > 0); // Solidity automatically throws when dividing by 0
//     uint256 c = a / b;
//     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
//     return c;
//   }
// 
//   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
//     require(b <= a);
//     return a - b;
//   }
// 
//   function add(uint256 a, uint256 b) internal pure returns (uint256) {
//     uint256 c = a + b;
//     require(c >= a);
//     return c;
//   }
// }


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
abstract contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public virtual returns (uint256);
  function transfer(address to, uint256 value) public virtual returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}
/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
abstract contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public virtual view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public virtual returns (bool);
  function approve(address spender, uint256 value) public virtual returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

// abstract contract ERC677 is ERC20 {
  // function transferAndCall(address to, uint value, bytes data) returns (bool success);

  // event Transfer(address indexed from, address indexed to, uint value, bytes data);
// }

// contract ERC677Receiver {
//   // function onTokenTransfer(address _sender, uint _value, bytes _data);
// }
// 
// /**
//  * @title Basic token
//  * @dev Basic version of StandardToken, with no allowances. 
//  */
contract BasicToken is ERC20Basic {
  // using SafeMath for uint256;

  mapping(address => uint256) balances;

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) virtual public override returns (bool) {
    // balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[msg.sender] -= _value;
    // balances[_to] = balances[_to].add(_value);
    balances[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of. 
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view override returns (uint256) {
    return balances[_owner];
  }

}


/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) allowed;
  
  // uint256 balanceTotal;

  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) virtual override public returns (bool) {
    uint256 _allowance = allowed[_from][msg.sender];

    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
    require (_value <= _allowance);

    // balances[_from] = SafeMath.sub(balances[_from],_value);
    balances[_from] -= _value;
    // SafeMath.sub(balanceTotal, _value);
    // balances[_to] = SafeMath.add(balances[_to],_value);
    balances[_to] += _value;
    // SafeMath.add(balanceTotal, _value);
    // allowed[_from][msg.sender] = SafeMath.sub(_allowance,_value);
    allowed[_from][msg.sender] -= _value;
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) virtual override public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view override returns (uint256) {
    return allowed[_owner][_spender];
  }
  
    /*
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until 
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   */
  function increaseApproval (address _spender, uint _addedValue) 
    public returns (bool) {
    // allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender],_addedValue);
    allowed[msg.sender][_spender] += _addedValue;
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval (address _spender, uint _subtractedValue) public
    returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    // if (_subtractedValue > oldValue) {
    //   allowed[msg.sender][_spender] = 0;
    // } else {
    //   allowed[msg.sender][_spender] = SafeMath.sub(oldValue,_subtractedValue);
    // }
    require(_subtractedValue <= oldValue);
    allowed[msg.sender][_spender] -= _subtractedValue;
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

// contract ERC677Token is ERC677 {
// 
//   /**
//   * @dev transfer token to a contract address with additional data if the recipient is a contact.
//   * @param _to The address to transfer to.
//   * @param _value The amount to be transferred.
//   * @param _data The extra data to be passed to the receiving contract.
//   */
//   // function transferAndCall(address _to, uint _value, bytes _data)
//   //   public
//   //   returns (bool success)
//   // {
//   //   super.transfer(_to, _value);
//   //   Transfer(msg.sender, _to, _value, _data);
//   //   if (isContract(_to)) {
//   //     contractFallback(_to, _value, _data);
//   //   }
//   //   return true;
//   // }
// 
// 
//   // PRIVATE
// 
//   // function contractFallback(address _to, uint _value, bytes _data)
//   //   private
//   // {
//   //   ERC677Receiver receiver = ERC677Receiver(_to);
//   //   receiver.onTokenTransfer(msg.sender, _value, _data);
//   // }
// 
//   // function isContract(address _addr)
//   //   private
//   //   returns (bool hasCode)
//   // {
//   //   uint length;
//   //   assembly { length := extcodesize(_addr) }
//   //   return length > 0;
//   // }
// 
// }

// contract LinkToken is StandardToken, ERC677Token {
contract LinkToken is StandardToken {

  string public constant name = 'ChainLink Token';
  uint8 public constant decimals = 18;
  string public constant symbol = 'LINK';

  constructor(uint _initialSupply)
  {
    // totalSupply = 10**27;
    // balances[msg.sender] = totalSupply;
    totalSupply = _initialSupply;
    balances[msg.sender] = _initialSupply;
    // balanceTotal = totalSupply;
  }

  // /**
  // * @dev transfer token to a specified address with additional data if the recipient is a contract.
  // * @param _to The address to transfer to.
  // * @param _value The amount to be transferred.
  // * @param _data The extra data to be passed to the receiving contract.
  // */
  // function transferAndCall(address _to, uint _value, bytes _data)
  //   public
  //   validRecipient(_to)
  //   returns (bool success)
  // {
  //   return super.transferAndCall(_to, _value, _data);
  // }

  /**
  * @dev transfer token to a specified address.
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint _value)
    public override (BasicToken, ERC20Basic)
    validRecipient(_to)
    returns (bool)
  {
    return super.transfer(_to, _value);
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value)
    public override
    validRecipient(_spender)
    returns (bool)
  {
    return super.approve(_spender,  _value);
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value)
    public override
    validRecipient(_to)
    returns (bool)
  {
    return super.transferFrom(_from, _to, _value);
  }


  // MODIFIERS

  modifier validRecipient(address _recipient) {
    require(_recipient != address(0) && _recipient != address(this));
    _;
  }

  // function check() public view {
  //   assert(balanceTotal == totalSupply);
  // }

}