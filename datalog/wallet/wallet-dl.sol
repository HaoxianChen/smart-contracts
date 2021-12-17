// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

enum OPCODE { EQUAL, GREATER, SMALLER, UNEQUAL }

contract Util {
    function strcmp(string memory a, string memory b) public pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}

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

struct Field {
    uint256 value;
}

contract Tuple {
    Field[] private fields;
    string[] private schema;
    Util util;
    constructor (string[] memory _schema, Field[] memory _fields) {
        require(_schema.length == _fields.length);
        for (uint i=0;i<_schema.length;i++) {
            schema.push(_schema[i]);
            fields.push(_fields[i]);
        }

        util = new Util();
    }
    function getSchema() public view returns (string[] memory) {
        return schema;
    }
    function get(string memory key) public view returns (Field memory) {
        for (uint i=0; i<schema.length;i++) {
            if (util.strcmp(schema[i],key)) {
                return fields[i];
            }
        }
        assert(false);
    }
}

abstract contract Facts {
    string[] private schema;
    function getSchema() public view returns (string[] memory) {
        return schema;
    }

    // interfaces
    function pushTuple(Tuple _tuple) public virtual;
    function push(Field[] memory _fields) public virtual;
    // function where(string memory _field, OPCODE op, Field memory param) 
    //     pure public virtual returns (FactsArray);
    // function join(Facts that, uint join_index_left, 
    //             uint join_index_right) pure public virtual returns (FactsArray);
}

contract FactsArray is Facts{
    string private name;
    string[] private schema;
    Tuple[] private tuples;
    constructor (string memory _name, string[] memory _schema) {
        name = _name;
        for (uint i=0; i<_schema.length;i++) {
            schema.push(_schema[i]);
        }
    }
    function size() public view returns (uint) {
        return tuples.length;
    }
    function pushTuple(Tuple _tuple) override public {
        tuples.push(_tuple);
    }
    function push(Field[] memory _fields) override public {
        Tuple _tuple = new Tuple(schema, _fields);
        tuples.push(_tuple);
    }
    function pop() public {
        tuples.pop();
    }
    function where(string memory _field, OPCODE op, Field memory param) 
        pure public returns (FactsArray) {
    }
    function join(Facts that, string[] memory join_index_left, 
                string[] memory join_index_right) pure public returns (FactsArray) {
    }
}

contract FactsMap is Facts{
    string private name;
    string[] private schema;
    mapping(uint256 => Tuple) private tupleMap;
    constructor (string memory _name, string[] memory _schema) {
        name = _name;
        for (uint i=0; i<_schema.length;i++) {
            schema.push(_schema[i]);
        }
    }
    function pushTuple(Tuple _tuple) override public {
    }
    function push(Field[] memory _fields) override public {
    }
    function get(uint256 key) public view returns (Tuple) {
        return tupleMap[key];
    }
}

contract FactsSingle is Facts {
    string private name;
    string[] private schema;
    Tuple tuple;

    constructor (string memory _name, string[] memory _schema) {
        require(_schema.length == 1);
        name = _name;
        for (uint i=0; i<_schema.length;i++) {
            schema.push(_schema[i]);
        }
    }
    function pushTuple(Tuple _tuple) override public {
    }
    function push(Field[] memory _fields) override public {
    }
    function get() public view returns (Tuple) {
        return tuple;
    }
}

