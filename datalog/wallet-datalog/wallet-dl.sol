// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import '../util/datalog.sol';

contract Wallet {
    // States, maintaining the views
    FactsSingle owner;
    FactsSingle totalSuply;
    FactsMap balanceOf;

    // Auxiliary facts
    string[] mint_schema;
    FactsArray recv_mint;

    // Events
    event Mint(address indexed to, uint amount);
    event Project(Tuple t, string[] fields, uint len);
    event Get(Tuple t, string key);

    constructor() {
        string[] memory owner_schema = new string[](1);
        owner_schema[0] = "owner";
        owner = new FactsSingle("owner", owner_schema);
        uint256[] memory  _fields = new uint256[](1);
        _fields[0] = uint160(msg.sender);
        owner.push(_fields);

        // Create tables
        mint_schema.push("sender");
        mint_schema.push("receiver");
        mint_schema.push("amount");
        assert(mint_schema.length==3);
        recv_mint = new FactsArray("recv_mint",mint_schema);
    }

    function getOwner() public view returns (address) {
        Tuple memory _tuple = owner.get();
        require(_tuple.valid);
        uint256 f = Datalog.get(_tuple,"owner");
        return address(uint160(f));
    }

    // Transactions
    // commit mint(p, n) :- 
    //       recv mint(p, n), owner(p) n!=0.
    function mint(address p, uint amount) public {
        // 1. Derive all logical conclusions
        uint256[] memory _fields = new uint256[](3);
        _fields[0] = uint160(msg.sender);
        _fields[1] = uint160(p);
        _fields[2] = amount;
        recv_mint.push(_fields);

        // 2. Is the commit rule satisfy?
        emit Mint(p, amount);
        Tuple[] memory commit_mint = getCommitMint(recv_mint);
        // require (commit_mint.length > 0);

        // 3. Derive updates to the aggreates

        // 4. Check properties 
        // FactsArray add = new FactsArray("add", []);

        // 5. Commit and update
        // recv_mint.pop();
    }

    // function update_totalSupply(Tuple _tuple) public pure 
    //         returns (FactsArray) {
    //     if (_tuple.getSchema() == recv_mint.getSchema()) {
    //         uint updateValue = _tuple.get("amount");
    //     }
    // }

    // function getCommitMint(FactsArray _recv_mint) private view
    function getCommitMint(FactsArray _recv_mint) private
            returns (Tuple[] memory) {
        string[] memory left_join_keys = new string[](1);
        string[] memory right_join_keys = new string[](1);
        left_join_keys[0] = "sender";
        right_join_keys[0] = "owner";
        
        (Tuple[] memory newTuples, uint ret_size) = Datalog.join(
                 _recv_mint.getAllTuples(), 
                _recv_mint.getSchema(), _recv_mint.size(),
                owner, left_join_keys, right_join_keys);


        // Copy the join results to a new array.
        Tuple[] memory ret = new Tuple[](ret_size);
        for (uint i=0;i<ret_size;i++) {
            ret[i] = newTuples[i];
        }
        return ret;
    }

    function check_overflow(FactsArray _add) 
        private view {
        // FactsArray integer_overflow = _add.where("a",OPCODE.GREATER,Field(0))
        //                                     .where("b",OPCODE.GREATER,Field(0))
        //                                     .where("c",OPCODE.SMALLER,Field(0));
        // assert(integer_overflow.size() == 0);
    }
}
