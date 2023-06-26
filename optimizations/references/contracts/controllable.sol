// Adopated from: https://github.com/ethereum/EIPs/issues/1644
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Controllable is ERC20 {
    address controller;

    event ControllerTransfer(address controller, address from, address to,
                            uint value);
    event ControllerRedemption(address controller, address tokenHolder, uint
                               value);

    // uint256 totalBalance;
    constructor(address _controller) ERC20("Token", "MCO") {
      controller = _controller;
      // totalBalance = 0;
    }

    modifier onlyController() {
      require(msg.sender == controller, 'NOT_CONTROLLER');
      _;
    }

    function controllerTransfer(address _from, address _to, uint256 _value) 
                                external onlyController {
        _transfer(_from, _to, _value);
        emit ControllerTransfer(msg.sender, _from, _to, _value);
    }

    function controllerRedeem(address _tokenHolder, uint256 _value) external
                                onlyController {
        _burn(_tokenHolder, _value);
        emit ControllerRedemption(msg.sender, _tokenHolder, _value);
        // totalBalance -= _value;
     }


    function mint(address account, uint256 amount) public {
        _mint(account, amount);
        // totalBalance += amount;
    }


    function burn(address account, uint256 amount) public {
        _burn(account, amount);
        // totalBalance -= amount;
    }

    // function equalBalance() public view {
    //   assert(totalSupply() == totalBalance);
    // }


}
