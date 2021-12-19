// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import '../util/datalog.sol';

contract Wallet {
    // States, maintaining the views
    FactsSingle owner;
    FactsSingle totalSuply;
    FactsMap balanceOf;
    string[] owner_schema;
    string[] totalSupply_schema;
    string[] balanceOf_schema;

    // Auxiliary facts
    string[] mint_schema;
    FactsArray recv_mint;

    constructor() {
        owner_schema.push("owner");
        owner = new FactsSingle("owner", owner_schema);
        Field[] memory  _fields = new Field[](1);
        _fields[0] = Field(uint160(msg.sender));
        owner.push(_fields);

        // Create tables
        mint_schema.push("sender");
        mint_schema.push("receiver");
        mint_schema.push("amount");
        recv_mint = new FactsArray("recv_mint",mint_schema);
    }

    function getOwner() public view returns (address) {
        Tuple _tuple = owner.get();
        Field memory f = _tuple.get("owner");
        return address(uint160(f.value));
    }

    // Transactions
    // commit mint(p, n) :- 
    //       recv mint(p, n), owner(p) n!=0.
    function mint(address p, uint amount) public {
        // 1. Derive all logical conclusions
        Field[] memory _fields = new Field[](3);
        _fields[0] = Field(uint160(msg.sender));
        _fields[1] = Field(uint160(p));
        _fields[2] = Field(amount);
        recv_mint.push(_fields);

        // 2. Is the commit rule satisfy?
        FactsArray commit_mint = getCommitMint(recv_mint);
        require (commit_mint.size() > 0);

        // 3. Derive updates to the aggreates

        // 4. Check properties 
        // FactsArray add = new FactsArray("add", []);

        // 5. Commit and update
        recv_mint.pop();
    }

    // function update_totalSupply(Tuple _tuple) public pure 
    //         returns (FactsArray) {
    //     if (_tuple.getSchema() == recv_mint.getSchema()) {
    //         uint updateValue = _tuple.get("amount");
    //     }
    // }

    function getCommitMint(FactsArray _recv_mint) private view
            returns (FactsArray) {
        string[] memory left_join_keys = new string[](1);
        string[] memory right_join_keys = new string[](1);
        left_join_keys[0] = "sneder";
        right_join_keys[0] = "owner";
        FactsArray _commit_mint = _recv_mint
                                    .join(owner,left_join_keys,right_join_keys)
                                    .where("address",OPCODE.UNEQUAL,Field(0));
        return _commit_mint;
    }

    function check_overflow(FactsArray _add) 
        private view {
        FactsArray integer_overflow = _add.where("a",OPCODE.GREATER,Field(0))
                                            .where("b",OPCODE.GREATER,Field(0))
                                            .where("c",OPCODE.SMALLER,Field(0));
        assert(integer_overflow.size() == 0);
    }
}
