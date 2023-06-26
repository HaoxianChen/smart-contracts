/**
 *Submitted for verification at Etherscan.io on 2019-03-06
*/

// pragma solidity ^0.4.18;
pragma solidity ^0.8.0;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint a, uint b) internal pure returns (uint) {
    if (a == 0) {
      return 0;
    }
    uint c = a * b;
    require(c / a == b);
    return c;
  }

  function div(uint a, uint b) internal pure returns (uint) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint a, uint b) internal pure returns (uint) {
    require(b <= a);
    return a - b;
  }

  function add(uint a, uint b) internal pure returns (uint) {
    uint c = a + b;
    require(c >= a);
    return c;
  }
}

abstract contract ERC20 {

    function totalSupply() virtual public view returns (uint);
    
    function balanceOf(address _owner) virtual public view returns (uint);
    
    function transfer(address _to, uint _value) virtual public returns (bool);
    
    function transferFrom(address _from, address _to, uint _value) virtual public returns (bool);
    
    function approve(address _spender, uint _value) virtual public returns (bool);
    
    function allowance(address _owner, address _spender) virtual public view returns (uint);

    event Transfer(address indexed _from, address indexed _to, uint _value);
    
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}


contract StandardToken is ERC20 {

    using SafeMath for uint;

    uint _totalSupply;

    mapping (address => uint) balances;

    // uint balanceTotal;
    
    mapping (address => mapping (address => uint)) allowed;

    function totalSupply() override public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address _owner) override public view returns (uint balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint _value) override virtual public returns (bool success) {
        require(balances[msg.sender] >= _value && _value > 0);
        
        balances[msg.sender] = balances[msg.sender].sub(_value);
        // balanceTotal = balanceTotal.sub(_value);
        balances[_to] = balances[_to].add(_value);
        // balanceTotal = balanceTotal.add(_value);
        emit Transfer(msg.sender, _to, _value);
        
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) override virtual public returns (bool success) {
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
        
        balances[_from] = balances[_from].sub(_value);
        // balanceTotal = balanceTotal.sub(_value);
        balances[_to] = balances[_to].add(_value);
        // balanceTotal = balanceTotal.add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        
        return true;
    }

    function approve(address _spender, uint _value) override public returns (bool success) {
        // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
            revert();
        }
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) override public view returns (uint remaining) {
        return allowed[_owner][_spender];
    }

}

contract Controlled {

    address public controller;

    constructor() {
        controller = msg.sender;
    }

    function changeController(address _newController) public only_controller {
        controller = _newController;
    }
    
    function getController() view public returns (address) {
        return controller;
    }

    modifier only_controller { 
        require(msg.sender == controller);
        _; 
    }

}


contract ThetaToken is StandardToken, Controlled {
    
    using SafeMath for uint;

    string public constant name = "Theta Token";

    string public constant symbol = "THETA";

    uint8 public constant decimals = 18;

    // tokens can be transferred amoung holders only after unlockTime
    uint unlockTime;
    
    // for token circulation on platforms that integrate Theta before unlockTime
    mapping (address => bool) internal precirculated;

    constructor (uint _unlockTime) {
        unlockTime = _unlockTime;
    }

    function transfer(address _to, uint _amount) can_transfer(msg.sender, _to) override public returns (bool success) {
        return super.transfer(_to, _amount);
    }

    function transferFrom(address _from, address _to, uint _amount) override can_transfer(_from, _to) public returns (bool success) {
        return super.transferFrom(_from, _to, _amount);
    }

    function mint(address _owner, uint _amount) external only_controller returns (bool) {
        _totalSupply = _totalSupply.add(_amount);
        balances[_owner] = balances[_owner].add(_amount);
        // balanceTotal = balanceTotal.add(_amount);

        emit Transfer(address(0), _owner, _amount);
        return true;
    }

    function allowPrecirculation(address _addr) only_controller public {
        precirculated[_addr] = true;
    }

    function disallowPrecirculation(address _addr) only_controller public {
        precirculated[_addr] = false;
    }

    function isPrecirculationAllowed(address _addr) view public returns(bool) {
        return precirculated[_addr];
    }
    
    function changeUnlockTime(uint _unlockTime) only_controller public {
        unlockTime = _unlockTime;
    }

    function getUnlockTime() view public returns (uint) {
        return unlockTime;
    }

    modifier can_transfer(address _from, address _to) {
        require((block.number >= unlockTime) || (isPrecirculationAllowed(_from) && isPrecirculationAllowed(_to)));
        _;
    }

    // function check() public view {
    //   assert(balanceTotal == totalSupply());
    // }

}
