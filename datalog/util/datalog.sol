// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

enum OPCODE { EQUAL, GREATER, SMALLER, UNEQUAL }

contract Util {
    function strcmp(string memory a, string memory b) public pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}

contract Datalog {
    function join(FactsArray left, Facts right, 
            string[] memory left_join_keys,
            string[] memory right_join_keys) public payable returns (FactsArray) {
        string[] memory new_schema = merge_schema(left.getSchema(), right.getSchema());
        FactsArray ret = new FactsArray("join_result", new_schema);
        for (uint i=0; i<left.size();i++) {
            Tuple lt = left.get(i);
            Field[] memory params = lt.project(left_join_keys);
            FactsArray rightTable = matchOn(right, right_join_keys, params);
            for (uint j=0; j<rightTable.size();j++) {
                Tuple rt = rightTable.get(j);
                ret.pushTuple(rt);
            }
        }
        return ret;
    }

    function matchOn(Facts facts, string[] memory keys, Field[] memory params) 
            public payable returns (FactsArray) {
            
    }

    function merge_schema(string[] memory left, string[] memory right) 
            private pure returns (string[] memory) {
        uint N = left.length + right.length;
        string[] memory new_schema = new string[](N);
        for (uint i=0;i<left.length;i++) {
            new_schema[i]=left[i];
        }
        uint n1 = left.length;
        for (uint i=0;i<right.length;i++) {
            new_schema[n1+i]=right[i];
        }
        return new_schema;
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
    function project(string[] memory keys) public view returns (Field[] memory) {
        Field[] memory ret = new Field[](keys.length);
        for (uint i=0; i<keys.length;i++) {
            Field memory f = get(keys[i]);
            ret[i]=f;
        }
        return ret;
    }

}

abstract contract Facts {
    string[] private schema;
    function getSchema() public view returns (string[] memory) {
        return schema;
    }

    // interfaces, all vritual, need to be implemented by sub-classes
    function pushTuple(Tuple _tuple) public virtual;
    function push(Field[] memory _fields) public virtual;
    function matchOn(string[] memory keys, Field[] memory params) 
            public virtual returns (Tuple[] memory); 

    // helper functions
    function matchTwoFields(Field[] memory left, Field[] memory right) internal 
            pure returns (bool){
        require(left.length == right.length);
        bool ret = true;
        for (uint i=0;i<left.length;i++) {
            if (left[i].value != right[i].value) {
                ret = false;
                break;
            }
        }
        return ret;
    }
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
    function get(uint index) public view returns (Tuple) {
        require(index < size());
        return tuples[index];
    }
    function where(string memory _field, OPCODE op, Field memory param) 
        pure public returns (FactsArray) {
    }
    function matchOn(string[] memory keys, Field[] memory params) public 
            override returns (Tuple[] memory){
        require(keys.length == params.length);
        Tuple[] memory ret = new Tuple[];
        for (uint i=0;i<tuples.length;i++) {
            Tuple t = tuples[i];
            Field[] memory fs = t.project(keys);
            if (matchTwoFields(fs,params)) {
                ret.push(t);
            }
        }
        return ret;
    } 
}

contract FactsMap is Facts{
    string private name;
    string[] private schema;
    string keyname;
    mapping(uint256 => Tuple) private tupleMap;
    constructor (string memory _name, string[] memory _schema) {
        name = _name;
        for (uint i=0; i<_schema.length;i++) {
            schema.push(_schema[i]);
        }
        keyname = schema[0];
    }
    function pushTuple(Tuple _tuple) override public {
    }
    function push(Field[] memory _fields) override public {
    }
    function get(uint256 key) public view returns (Tuple) {
        return tupleMap[key];
    }
    function matchOn(string[] memory _keys, Field[] memory _params) public 
            override returns (Tuple[] memory){
        require(_keys.length == _params.length);
        uint256 key = getKey(_keys, _params);
        Tuple t = tupleMap[key];
        Tuple[] memory ret = Tuple[];
        if (matchTwoFields(t.fields, _params)) {
            ret.push(t);
        }
        return ret;
    } 
    function getKey(string[] memory _keys, Field[] memory _params) private
            pure returns(uint256) {
        for (uint i=0;i<_keys.length;i++) {
            if (_keys[i]==keyname) {
                return _params[i].value;
            }
        }
        assert(false);
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
        require(_fields.length==schema.length);
        tuple = new Tuple(schema, _fields);
    }
    function get() public view returns (Tuple) {
        return tuple;
    }
    function matchOn(string[] memory keys, Field[] memory params) public 
            override returns (Tuple[] memory){
        require(keys.length==1);
        require(params.length==1);
        Tuple[] memory ret = new Tuple[];
        if (matchTwoFields(tuple.fields, params)) {
            ret.push(tuple);
        }
        return ret;
    } 
}