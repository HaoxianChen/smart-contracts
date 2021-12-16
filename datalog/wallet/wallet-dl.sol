enum OPCODE { EQUAL, GREATER, SMALLER, UNEQUAL }

contract Wallet {
    // States, maintaining the views
    address owner;
    uint private totalSupply;
    mapping(address=>uint) private balanceOf;

    // Auxiliary facts
    string[] mint_schema;
    FactsArray recv_mint;

    constructor() {
        owner = msg.sender;

        // Create tables
        mint_schema.push("sender");
        mint_schema.push("receiver");
        mint_schema.push("amount");
        recv_mint = new FactsArray("recv_mint",mint_schema);
    }

    function getOwner() public view returns (address) {
        return owner;
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

        FactsArray commit_mint = recv_mint
                        .where("sender", OPCODE.EQUAL, Field(uint160(owner)))
                        .where("address", OPCODE.UNEQUAL, Field(0));
        // 2. Is the commit rule satisfy?
        assert (commit_mint.size() > 0);

        // 3. Derive view updates

        // 3. Check properties 

        // 4. Commit and update
        recv_mint.pop();
        commit_mint.pop();
    }
}

struct Field {
    uint256 value;
}

contract Tuple {
    Field[] private fields;
    string[] private schema;
    constructor (string[] memory _schema, Field[] memory _fields) {
        schema = _schema;
        fields = _fields;
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
    function where(string memory _field, OPCODE op, Field memory param) 
        pure public virtual returns (FactsArray);
    function join(Facts that, uint join_index_left, 
                uint join_index_right) pure public virtual returns (FactsArray);
}

contract FactsArray is Facts{
    string private name;
    string[] private schema;
    Tuple[] private tuples;
    constructor (string memory _name, string[] memory _schema) {
        name = _name;
        schema = _schema;
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
        override pure public returns (FactsArray) {
    }
    function join(Facts that, uint join_index_left, 
                uint join_index_right) override pure public returns (FactsArray) {
    }
}

contract FactsMap is Facts{
    string private name;
    string[] private schema;
    mapping(uint256 => Tuple) private tuples;
    constructor (string memory _name, string[] memory _schema) {
        name = _name;
        schema = _schema;
    }
    function pushTuple(Tuple _tuple) override public {
    }
    function push(Field[] memory _fields) override public {
    }
    function get() public view returns (Tuple) {
    }
    function where(string memory _field, OPCODE op, Field memory param) 
        override pure public returns (FactsArray) {
    }
    function join(Facts that, uint join_index_left, 
                uint join_index_right) override pure public returns (FactsArray) {
    }
}