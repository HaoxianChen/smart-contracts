// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    uint256 totalBalance;
    constructor() ERC20("Token", "MCO") {
      // totalBalance = 0;
    }

    function mint(address account, uint256 amount) public {
        _mint(account, amount);
        // totalBalance += amount;
    }


    function burn(address account, uint256 amount) public {
        _burn(account, amount);
        // totalBalance -= amount;
    }

//    function equalBalance() public view {
//      assert(totalSupply() == totalBalance);
//    }

}
