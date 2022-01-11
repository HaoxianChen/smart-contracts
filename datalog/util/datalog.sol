// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import './tuple.sol';


enum OPCODE { EQUAL, GREATER, SMALLER, UNEQUAL }

library Datalog {
    function join(Tuple[] memory leftTuples, 
                string[] memory _leftSchema,
                uint leftSize,
                Facts right, 
            string[] memory left_join_keys,
            string[] memory right_join_keys) public view returns (Tuple[] memory, uint) {

        string[] memory new_schema = merge_schema(_leftSchema, right.getSchema());
        uint N = leftSize * right.size();
        Tuple[] memory ret = new Tuple[](N);
        uint size = 0;

        for (uint i=0; i<leftSize;i++) {
            Tuple memory lt = leftTuples[i];
            require(lt.valid);
            uint256[] memory params = TupleHelper.project(lt,left_join_keys);
            (Tuple[] memory rightTuples, uint rightSize) = right.matchOn(right_join_keys, params);

            for (uint j=0; j<rightSize;j++) {
                Tuple memory rt = rightTuples[j];
                require(rt.valid);
                uint256[] memory new_fields = merge_fields(lt.fields,rt.fields);
                Tuple memory jt = Tuple(true, new_schema, new_fields);
                ret[size] = jt;
                size += 1;
            }
        }
        return (ret,size);
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

    function merge_fields(uint256[] memory left, uint256[] memory right)
            private pure returns (uint256[] memory) {
        
        uint N = left.length + right.length;
        uint256[] memory ret = new uint256[](N);
        for (uint i=0;i<left.length;i++) {
            ret[i]=left[i];
        }
        uint n1 = left.length;
        for (uint i=0;i<right.length;i++) {
            ret[n1+i]=right[i];
        }
        return ret;
    }
}

abstract contract Facts {
    string internal name;
    string[] internal schema;
    function getSchema() public view returns (string[] memory) {
        return schema;
    }
    function getName() public view returns (string memory) {
        return name;
    }

    // interfaces, all vritual, need to be implemented by sub-classes
    function pushTuple(Tuple memory _tuple) public virtual;
    function matchOn(string[] memory keys, uint256[] memory params) 
            public view virtual returns (Tuple[] memory, uint); 
    function size() public view virtual returns (uint);

    // helper functions

    function push(uint256[] memory _fields) public {
        Tuple memory _tuple = Tuple(true, schema, _fields);
        pushTuple(_tuple);
    }

    function matchTwoFields(uint256[] memory left, uint256[] memory right) internal 
            pure returns (bool){
        require(left.length == right.length);
        bool ret = true;
        for (uint i=0;i<left.length;i++) {
            if (left[i] != right[i]) {
                ret = false;
                break;
            }
        }
        return ret;
    }
}

contract FactsArray is Facts{
    // string private name;
    // string[] private schema;
    Tuple[] private tuples;

    event construction(string name, string[] _schema);
    constructor (string memory _name, string[] memory _schema) {
        emit construction(_name, _schema);
        name = _name;
        for (uint i=0; i<_schema.length;i++) {
            schema.push(_schema[i]);
        }
    }
    function size() override public view returns (uint) {
        return tuples.length;
    }
    function pushTuple(Tuple memory _tuple) override public {
        tuples.push(_tuple);
    }
    function pop() public {
        tuples.pop();
    }
    function get(uint index) public view returns (Tuple memory) {
        require(index < size());
        return tuples[index];
    }
    function getAllTuples() public view returns (Tuple[] memory) {
        return tuples;
    }
    function where(string memory _field, OPCODE op, Field memory param) 
        pure public returns (FactsArray) {
    }
    function matchOn(string[] memory keys, uint256[] memory params) public 
            view override returns (Tuple[] memory, uint){
        require(keys.length == params.length);
        Tuple[] memory ret = new Tuple[](tuples.length);
        uint _size = 0;
        for (uint i=0;i<tuples.length;i++) {
            Tuple memory t = tuples[i];
            uint256[] memory fs = TupleHelper.project(t,keys);
            if (matchTwoFields(fs,params)) {
                ret[i]=t;
                _size = _size+1;
            }
        }
        return (ret,_size);
    } 
}

contract FactsMap is Facts{
    // string private name;
    // string[] private schema;
    string keyname;
    uint private _size;
    mapping(uint256 => Tuple) private tupleMap;
    constructor (string memory _name, string[] memory _schema) {
        name = _name;
        for (uint i=0; i<_schema.length;i++) {
            schema.push(_schema[i]);
        }
        keyname = schema[0];
        _size = 0;
    }
    function size() override public view returns (uint) {
        return _size;
    }
    function pushTuple(Tuple memory _tuple) override public {
        uint256 key = getKey(_tuple.schema, _tuple.fields);
        if (!tupleMap[key].valid) {
            // Add a new tuple
            _size += 1;
        }
        tupleMap[key] = _tuple;
    }
    function get(uint256 key) public view returns (Tuple memory) {
        return tupleMap[key];
    }
    function matchOn(string[] memory _keys, uint256[] memory _params) public 
            view override returns (Tuple[] memory,uint){
        require(_keys.length == _params.length);
        uint256 key = getKey(_keys, _params);
        Tuple memory t = tupleMap[key];
        Tuple[] memory ret = new Tuple[](1);
        uint join_size = 0;
        if (matchTwoFields(t.fields, _params)) {
            ret[1];
            join_size=1;
        }
        return (ret,join_size);
    } 
    function getKeyName() private view returns (string memory) {
        return keyname;
    }
    function getKey(string[] memory _keys, uint256[] memory _params) private
            view returns(uint256) {
        for (uint i=0;i<_keys.length;i++) {
            if (Util.strcmp(_keys[i],keyname)) {
                return _params[i];
            }
        }
        assert(false);
        return 0;
    }

}

contract FactsSingle is Facts {
    // string private name;
    // string[] private schema;
    Tuple tuple;

    constructor (string memory _name, string[] memory _schema) {
        require(_schema.length == 1);
        name = _name;
        for (uint i=0; i<_schema.length;i++) {
            schema.push(_schema[i]);
        }
        require(schema.length==1);
    }
    function size() override public view returns (uint) {
        if (tuple.valid) {
            return 1;
        }
        else {
            return 0;
        }
    }
    function pushTuple(Tuple memory _tuple) override public {
        tuple = _tuple;
    }
    function get() public view returns (Tuple memory) {
        return tuple;
    }
    function matchOn(string[] memory keys, uint256[] memory params) public 
            view override returns (Tuple[] memory, uint){
        require(keys.length==1);
        require(params.length==1);
        Tuple[] memory ret = new Tuple[](1);
        uint _size = 0;
        if (matchTwoFields(tuple.fields, params)) {
            ret[0] = tuple;
            _size = 1;
        }
        return (ret, _size);
    } 
}