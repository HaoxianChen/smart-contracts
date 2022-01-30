// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./wallet-dl.sol";

contract TestWallet {

    Wallet wallet;
    address acc0;
    
    /// Initiate accounts variable
    constructor() {
        wallet = new Wallet();
        acc0 = address(1);

        testOwner();
    }

    function testOwner () public view returns (address) {
        address expected = address(this);
        address result = wallet.getOwner();
        require(result==expected, "unexpected owner");
        return result;
    }

    function testMint() public {
        wallet.mint(acc0, 100);
    }
}