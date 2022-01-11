// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

library Util {
    function strcmp(string memory a, string memory b) public pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}

struct Field {
    uint256 value;
}

struct Tuple {
    bool valid;
    string[] schema;
    uint256[] fields;
}

library TupleHelper {
    using Util for string;
    // constructor () {
    //     util = new Util();
    // }
    function size(Tuple memory tuple) public pure returns (uint) {
        return tuple.fields.length;
    }
    function get(Tuple memory tuple, string memory key) public 
            // view returns (Field memory) {
            pure returns (uint256) {
        for (uint i=0; i<tuple.schema.length;i++) {
            if (Util.strcmp(tuple.schema[i],key)) {
                return tuple.fields[i];
            }
        }
        assert(false);
        return 0;
    }
    function project(Tuple memory tuple, string[] memory keys) 
            public pure returns (uint256[] memory) {
        // Field[] memory ret = new Field[](keys.length);
        uint256[] memory ret = new uint256[](keys.length);
        for (uint i=0; i<keys.length;i++) {
            // Field memory f = get(tuple,keys[i]);
            uint256 f = get(tuple,keys[i]);
            ret[i]=f;
        }
        return ret;
    }
}