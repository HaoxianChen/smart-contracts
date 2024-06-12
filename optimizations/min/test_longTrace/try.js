const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');
const fs = require('fs');
const helper = require("./helper_functions");
var Bnb = artifacts.require("Bnb");
const testCount = 50;
const contractName = 'bnb';
const transactionName = 'mint';

contract("Bnb", async accounts => { 
    it("test Bnb.withdraw gas consumption", async () => {
      var result;
      var hash;
      var gasUsed = 0;
      var gasUsedOp = 0;
      var gasUsedCompute = 0;
      var gasUsedStorage = 0;
      var gasUsedMem_others = 0;
      var gasUsedMem = 0;
      var storageOverhead_write = 0;
      var storageOverhead_read = 0;
      var readGasCost = 0;
      var writeGasCost = 0;
      var opcodeData = '';
      var transferFromAmount = 10;

      const instance = await Bnb.new(11000);
      // await instance.transfer(accounts[5], 11000, {from: accounts[0]});
      // await instance.approve(accounts[9], 11000, {from: accounts[5]});
      // const result_1 = await instance.approve(accounts[6], 100, {from: accounts[0]});
      // const result_2 = await instance.approve(accounts[6], 101, {from: accounts[0]}); 
      for (let counter = 0; counter < testCount; counter++) {
        gasUsedOp = 0;
        gasUsedCompute = 0;
        gasUsedStorage = 0;
        gasUsedMem_others = 0;
        gasUsedMem = 0;
        storageOverhead_write = 0;
        storageOverhead_read = 0;
        readGasCost = 0;
        writeGasCost = 0;
        transferFromAmount ++;
        // result = await instance.transferFrom(accounts[5], accounts[4],transferFromAmount, {from: accounts[9]});
        var accountIndex = await helper.random(0, 10);
        var mintAmount = await helper.random(10, 1000);
        result = await instance.mint(accounts[accountIndex], mintAmount, {from: accounts[0]});
        hash = await result.tx;
        gasUsed = await result.receipt.gasUsed;
        await fetch('http://localhost:8545', {
          body: `{"jsonrpc":"2.0", "id": 1, "method": "debug_traceTransaction", "params": [ "${hash}"] }`,
          headers: {
            "Content-Type": "application/json"
          },
          method: "POST"
        })
       .then(res => res.json())
       .then(async(data) => {
         var structLogsCount = await data.result.structLogs.length;
         var logs = await data.result.structLogs;
         logs.forEach(log => {
           gasUsedOp += +log.gasCost;
           if(log.op == 'MSTORE' || log.op == 'MSTORE8' || log.op == 'MLOAD') {
             gasUsedMem += +log.gasCost;
           } else if(log.op == 'KECCAK256'|| log.op == 'CALLDATACOPY' || log.op == 'CODECOPY' || log.op == 'EXTCODECOPY' || log.op == 'RETURNDATACOPY' || log.op == 'LOG0' || log.op == 'LOG1' || log.op == 'LOG2' || log.op == 'LOG3' || log.op == 'LOG4' || log.op == 'CREATE' || log.op == 'CALL' || log.op == 'CALLCODE' || log.op == 'RETURN' || log.op == 'DELEGATECALL' || log.op == 'CREATE2' || log.op == 'STATICCALL') {
             gasUsedMem_others += +log.gasCost;
           } else if (log.op == 'SLOAD') {
             gasUsedStorage += +log.gasCost;
             readGasCost += +log.gasCost;
             storageOverhead_read++;
           } else if (log.op == 'SSTORE') {
             gasUsedStorage += +log.gasCost;
             writeGasCost += +log.gasCost;
             storageOverhead_write++;
           }
           else {
             gasUsedCompute += +log.gasCost;
           }
           // opcodeData += `op: ${log.op} gas: ${log.gas} gasCost: ${log.gasCost}\n`;
           // opcodeData += `memory: ${log.memory}\n`;
           // opcodeData += `storage: ${JSON.stringify(log.storage)}\n\n`;
         })
       })

      // console.log(`transaction: transferFrom(accounts[5], accounts[4], ${transferFromAmount}, {from: accounts[9]})`);
      opcodeData += `transaction: mint(accounts[${accountIndex}], ${mintAmount}, {from: accounts[0]})\n`;
      opcodeData += `Gas cost (from result.receipt): ${gasUsed}\n`;
      opcodeData += `Gas cost (from opcodes): ${gasUsedOp}\n`;
      opcodeData += `Gas cost (memory operations): ${gasUsedMem}\n`;
      opcodeData += `Gas cost (memory_others operations): ${gasUsedMem_others}\n`;
      opcodeData += `Gas cost (storage operations): ${gasUsedStorage}\n`;
      opcodeData += `Gas cost (computation operations): ${gasUsedCompute}\n`;
      opcodeData += `Transaction storage overhead (read): ${storageOverhead_read} slot(s)\n`;
      opcodeData += `Read Gas Cost: ${readGasCost}\n`;
      opcodeData += `Transaction storage overhead (write): ${storageOverhead_write} slot(s)\n`;
      opcodeData += `Write Gas Cost: ${writeGasCost}\n\n`;   
      // fs.writeFileSync('opcode_sameTransaction_1.txt', opcodeData_1);  
      // await console.log(opcodeData);

      }
      fs.writeFileSync(`tracefiles_long/${contractName}.${transactionName}.txt`, opcodeData); 
   //    const result_1 = await instance.transferFrom(accounts[5], accounts[4],100, {from: accounts[9]});
   //    const result_2 = await instance.transferFrom(accounts[5], accounts[4],150, {from: accounts[9]});
   //    const hash_1 = result_1.tx;
   //    const hash_2 = result_2.tx;
   //    const gasUsed_1 = await result_1.receipt.gasUsed;
   //    const gasUsed_2 = await result_2.receipt.gasUsed;
   //    console.log(`Bnb.transaction_1 Gas Used (from result.receipt): `, gasUsed_1);
   //    console.log(`Bnb.transaction_2 Gas Used (from result.receipt): `, gasUsed_2);


   //    var gasUsedOp_1 = 0;
   //    var gasUsedCompute_1 = 0;
   //    var gasUsedMem_1 = 0;
   //    var gasUsedStorage_1 = 0;
   //    var gasUsedMem_others_1 = 0;
   //    var storageOverhead_write_1 = 0; // slots (1 slot = 32 bytes)
   //    var storageOverhead_read_1 = 0; // slots (1 slot = 32 bytes)
   //    var readGasCost_1 = 0;
   //    var writeGasCost_1 = 0;
   //    var curr_storage_sload_1  = {};
   //    var curr_storage_sstore_1 = {};
   //    var opcodeData_1 = '';
   //    await fetch('http://localhost:8545', {
   //      body: `{"jsonrpc":"2.0", "id": 1, "method": "debug_traceTransaction", "params": [ "${hash_1}"] }`,
   //      headers: {
   //        "Content-Type": "application/json"
   //      },
   //      method: "POST"
   //    })
   //   .then(res => res.json())
   //   .then(data => {
   //     var structLogsCount = data.result.structLogs.length;
   //     var logs = data.result.structLogs;
   //     logs.forEach(log => {
   //       gasUsedOp_1 += +log.gasCost;
   //       if(log.op == 'MSTORE' || log.op == 'MSTORE8' || log.op == 'MLOAD') {
   //         gasUsedMem_1 += +log.gasCost;
   //       } else if(log.op == 'KECCAK256'|| log.op == 'CALLDATACOPY' || log.op == 'CODECOPY' || log.op == 'EXTCODECOPY' || log.op == 'RETURNDATACOPY' || log.op == 'LOG0' || log.op == 'LOG1' || log.op == 'LOG2' || log.op == 'LOG3' || log.op == 'LOG4' || log.op == 'CREATE' || log.op == 'CALL' || log.op == 'CALLCODE' || log.op == 'RETURN' || log.op == 'DELEGATECALL' || log.op == 'CREATE2' || log.op == 'STATICCALL') {
   //         gasUsedMem_others_1 += +log.gasCost;
   //       } else if (log.op == 'SLOAD') {
   //         gasUsedStorage_1 += +log.gasCost;
   //         readGasCost_1 += +log.gasCost;
   //         storageOverhead_read_1++;
   //       } else if (log.op == 'SSTORE') {
   //         gasUsedStorage_1 += +log.gasCost;
   //         writeGasCost_1 += +log.gasCost;
   //         storageOverhead_write_1++;
   //       }
   //       else {
   //         gasUsedCompute_1 += +log.gasCost;
   //       }
   //       opcodeData_1 += `op: ${log.op} gas: ${log.gas} gasCost: ${log.gasCost}\n`;
   //       opcodeData_1 += `memory: ${log.memory}\n`;
   //       opcodeData_1 += `storage: ${JSON.stringify(log.storage)}\n\n`;
   //     })
   //   })
   //  opcodeData_1 += `\nGas cost (from result.receipt): ${gasUsed_1}\n`;
   //  opcodeData_1 += `Gas cost (from opcodes): ${gasUsedOp_1}\n`;
   //  opcodeData_1 += `Gas cost (memory operations): ${gasUsedMem_1}\n`;
   //  opcodeData_1 += `Gas cost (memory_others operations): ${gasUsedMem_others_1}\n`;
   //  opcodeData_1 += `Gas cost (storage operations): ${gasUsedStorage_1}\n`;
   //  opcodeData_1 += `Gas cost (computation operations): ${gasUsedCompute_1}\n`;
   //  opcodeData_1 += `Transaction storage overhead (read): ${storageOverhead_read_1} slot(s)\n`;
   //  opcodeData_1 += `Read Gas Cost: ${readGasCost_1}\n`;
   //  opcodeData_1 += `Transaction storage overhead (write): ${storageOverhead_write_1} slot(s)\n`;
   //  opcodeData_1 += `Write Gas Cost: ${writeGasCost_1}\n`;   
   //  fs.writeFileSync('opcode_sameTransaction_1.txt', opcodeData_1);        


   //  var gasUsedOp_2 = 0;
   //  var gasUsedCompute_2 = 0;
   //  var gasUsedMem_2 = 0;
   //  var gasUsedStorage_2 = 0;
   //  var gasUsedMem_others_2 = 0;
   //  var storageOverhead_write_2 = 0; // slots (1 slot = 32 bytes)
   //  var storageOverhead_read_2 = 0; // slots (1 slot = 32 bytes)
   //  var readGasCost_2 = 0;
   //  var writeGasCost_2 = 0;
   //  var curr_storage_sload_2  = {};
   //  var curr_storage_sstore_2 = {};
   //  var opcodeData_2 = '';
   //  await fetch('http://localhost:8545', {
   //    body: `{"jsonrpc":"2.0", "id": 1, "method": "debug_traceTransaction", "params": [ "${hash_2}"] }`,
   //    headers: {
   //      "Content-Type": "application/json"
   //    },
   //    method: "POST"
   //  })
   // .then(res => res.json())
   // .then(data => {
   //   var structLogsCount = data.result.structLogs.length;
   //   var logs = data.result.structLogs;
   //   logs.forEach(log => {
   //     gasUsedOp_2 += +log.gasCost;
   //     if(log.op == 'MSTORE' || log.op == 'MSTORE8' || log.op == 'MLOAD') {
   //       gasUsedMem_2 += +log.gasCost;
   //     } else if(log.op == 'KECCAK256'|| log.op == 'CALLDATACOPY' || log.op == 'CODECOPY' || log.op == 'EXTCODECOPY' || log.op == 'RETURNDATACOPY' || log.op == 'LOG0' || log.op == 'LOG1' || log.op == 'LOG2' || log.op == 'LOG3' || log.op == 'LOG4' || log.op == 'CREATE' || log.op == 'CALL' || log.op == 'CALLCODE' || log.op == 'RETURN' || log.op == 'DELEGATECALL' || log.op == 'CREATE2' || log.op == 'STATICCALL') {
   //       gasUsedMem_others_2 += +log.gasCost;
   //     } else if (log.op == 'SLOAD') {
   //       gasUsedStorage_2 += +log.gasCost;
   //       readGasCost_2 += +log.gasCost;
   //       storageOverhead_read_2++;
   //     } else if (log.op == 'SSTORE') {
   //       gasUsedStorage_2 += +log.gasCost;
   //       writeGasCost_2 += +log.gasCost;
   //       storageOverhead_write_2++;
   //     }
   //     else {
   //       gasUsedCompute_2 += +log.gasCost;
   //     }
   //     opcodeData_2 += `op: ${log.op} gas: ${log.gas} gasCost: ${log.gasCost}\n`;
   //     opcodeData_2 += `memory: ${log.memory}\n`;
   //     opcodeData_2 += `storage: ${JSON.stringify(log.storage)}\n\n`;
   //   })
   // })
   // opcodeData_2 += `\nGas cost (from result.receipt): ${gasUsed_2}\n`;
   // opcodeData_2 += `Gas cost (from opcodes): ${gasUsedOp_2}\n`;
   // opcodeData_2 += `Gas cost (memory operations): ${gasUsedMem_2}\n`;
   // opcodeData_2 += `Gas cost (memory_others operations): ${gasUsedMem_others_2}\n`;
   // opcodeData_2 += `Gas cost (storage operations): ${gasUsedStorage_2}\n`;
   // opcodeData_2 += `Gas cost (computation operations): ${gasUsedCompute_2}\n`;
   // opcodeData_2 += `Transaction storage overhead (read): ${storageOverhead_read_2} slot(s)\n`;
   // opcodeData_2 += `Read Gas Cost: ${readGasCost_2}\n`;
   // opcodeData_2 += `Transaction storage overhead (write): ${storageOverhead_write_2} slot(s)\n`;
   // opcodeData_2 += `Write Gas Cost: ${writeGasCost_2}\n`;   
   // fs.writeFileSync('opcode_sameTransaction_2.txt', opcodeData_2);
  





    });


});