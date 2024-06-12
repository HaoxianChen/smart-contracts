const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');
const ganache = require("ganache");
const fetch = require("node-fetch");
const options = {};
const provider = ganache.provider(options);
const fs = require('fs');
const _ = require('lodash');



var NFT = artifacts.require("NFT");

contract("NFT", async accounts => {
  it("test NFT.transferFrom gas consumption", async() => {
    var _data = '';
    const instance = await NFT.new();
    await instance.mint(accounts[0], 123);
    const result = await instance.transferFrom(accounts[0], accounts[1], 123,
        { gas: 5000000, gasPrice: 500000000 });
    const gasUsed = await result.receipt.gasUsed;
    const hash = await result.tx;
    console.log(result.receipt);
    var gasUsedOp = 0;
    var gasUsedCompute = 0;
    var gasUsedMem = 0;
    var gasUsedStorage = 0;
    var gasUsedMem_others = 0;
    var storageOverhead_write = 0; // slots (1 slot = 32 bytes)
    var storageOverhead_read = 0; // slots (1 slot = 32 bytes)
    var curr_storage_sload  = {};
    var curr_storage_sstore = {};
    var if_sstore = false;
    await fetch('http://localhost:8545', {
      body: `{"jsonrpc":"2.0", "id": 1, "method": "debug_traceTransaction", "params": [ "${hash}"] }`,
      headers: {
        "Content-Type": "application/json"
      },
      method: "POST"
    })
   .then(res => res.json())
   .then(data => {
     var structLogsCount = data.result.structLogs.length;
     var logs = data.result.structLogs;
     logs.forEach(log => {
       gasUsedOp += +log.gasCost;
       if(log.op == 'MSTORE' || log.op == 'MSTORE8' || log.op == 'MLOAD') {
         gasUsedMem += +log.gasCost;
       } else if(log.op == 'KECCAK256'|| log.op == 'CALLDATACOPY' || log.op == 'CODECOPY' || log.op == 'EXTCODECOPY' || log.op == 'RETURNDATACOPY' || log.op == 'LOG0' || log.op == 'LOG1' || log.op == 'LOG2' || log.op == 'LOG3' || log.op == 'LOG4' || log.op == 'CREATE' || log.op == 'CALL' || log.op == 'CALLCODE' || log.op == 'RETURN' || log.op == 'DELEGATECALL' || log.op == 'CREATE2' || log.op == 'STATICCALL') {
         gasUsedMem_others += +log.gasCost;
       } else if (log.op == 'SLOAD') {
         gasUsedStorage += +log.gasCost;
         console.log('type of storage: ', typeof(log.storage));
         let storage_json = log.storage;
         // console.log('storage for SLOAD: ', JSON.stringify(storage_json));
         if (!_.isEqual(storage_json, curr_storage_sload)) {
           // get the size of curr_storage_sload
           let size_pre = Object.keys(curr_storage_sload).length;
           let size_curr = Object.keys(storage_json).length;
           if(size_curr < size_pre) {
             console.log('sload size reduced');
           }
           storageOverhead_read += (size_curr - size_pre);
         } else {
           console.log('repeated read');
         }
         curr_storage_sload = storage_json;
       } else if(log.op == 'SSTORE') {
         gasUsedStorage += +log.gasCost;
         if_sstore = true;
         console.log('sstore');
         curr_storage_sstore = log.storage;
       } else {
         gasUsedCompute += +log.gasCost;
       }

       if(log.op != 'SSTORE' && if_sstore == true) {
         console.log('opcode following sstore');
         for (const key of Object.keys(log.storage)) {
           if(log.storage[key] != curr_storage_sstore[key]) {
             console.log('sstore changes storage');
             storageOverhead_write ++;
           }
        }
        if_sstore = false;
       }
 

       _data += `op: ${log.op} gas: ${log.gas} gasCost: ${log.gasCost}\n`;
       _data += `memory: ${log.memory}\n`;
       _data += `storage: ${JSON.stringify(log.storage)}\n\n`;
       // console.log(`op: ${log.op} gas: ${log.gas} gasCost: ${log.gasCost}`);
       // console.log('memeory: ', log.memory);
       // console.log('storage: ', log.storage);
       // console.log();
     })
   })

   _data += `\nGas cost (from result.receipt): ${gasUsed}\n`;
   _data += `Gas cost (from opcodes): ${gasUsedOp}\n`;
   _data += `Gas cost (mem operations): ${gasUsedMem}\n`;
   _data += `Gas cost (mem_others operations): ${gasUsedMem_others}\n`;
   _data += `Gas cost (storage operations): ${gasUsedStorage}\n`;
   _data += `Gas cost (computation operations): ${gasUsedCompute}\n`;
   _data += `Transaction storage overhead (read): ${storageOverhead_read} slot(s)\n`;
   _data += `Transaction storage overhead (write): ${storageOverhead_write} slot(s)\n`;
    // curl -H 'Content-Type: application/json'   --data '{"jsonrpc":"2.0", "id": 1, "method": "debug_traceTransaction", "params": [ "0x947e4af2f52483debffdf52f7daa60b203b146094c4e62e352b33fbb2ef4fd6a" ] }' http://localhost:8545 -o trace.json
    fs.writeFileSync('trace.txt', _data);

  });
})


