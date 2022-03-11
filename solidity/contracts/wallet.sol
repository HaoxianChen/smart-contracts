// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Wallet {
    address private _owner;
    mapping(address => int) private _balanceOf;
    int private _totalSupply;
    
    event Transfer(address from, address to, int amount);
    event Construction(address owner);
    
    constructor() {
        emit Construction(msg.sender);
        _owner = msg.sender;
    }

    function getOwner() public view returns (address) {
        return _owner;
    }
    
    function mint(address account,int amount) public {
        require(msg.sender == _owner);
        require(account != address(0));

        _totalSupply += amount;
        _balanceOf[account] += amount;
        emit Transfer(address(0), account, amount);
    }
    
    function burn(address account,int amount) public {
        require(msg.sender == _owner);
        require(account != address(0));
        
        _totalSupply -= amount;
        _balanceOf[account] -= amount;
        emit Transfer(account, address(0), amount);
    }
    
    function transfer(address from, address to, int amount) public {
        require(_balanceOf[from] >= amount);
        
        _balanceOf[from] -= amount;
        _balanceOf[to] += amount;
        
        require(_balanceOf[from] >= 0);
        emit Transfer(from, to, amount);
    }
    
    function totalSupply() public view returns(int) {
        return _totalSupply;
    }
    
    function balanceOf(address account) public view returns(int) {
        return _balanceOf[account];
    }
}