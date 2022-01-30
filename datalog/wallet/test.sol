// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./example.sol";

contract TestWallet {
    Wallet wallet;
    address acc0;
    address acc1;
    
    constructor() {
        wallet = new Wallet();
        acc0 = address(1);
    }

    function testOwner () public view returns (address) {
        address expected = address(this);
        address result = wallet.getOwner();
        require(result==expected, "unexpected owner");
        return result;
    }

    function testMint() public {
        uint n = 100;
        wallet.mint(acc0, n);
        uint ret = wallet.balanceOf(acc0);
        require(ret == n, "Balance does not equal to mint amount");
    }

    function testTransfer() public {
    }
}