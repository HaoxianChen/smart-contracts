const fs = require('fs');
const path = require('path');
const _ = require('lodash');
const decimal = 2;
const {
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');
function range(n) {
	return [...Array(n).keys()];
}

function random(min, max) {  
  return Math.floor(
    Math.random() * (max - min) + min
  )
}

function round(value) {
  return Number(Math.round(value+'e'+decimal)+'e-'+decimal);
}


function runTests(transactionCounts, transactionFolders, testFolder, contractName) {
  var Contract = artifacts.require(contractName);
  contract(`${contractName}`, accounts => {
    range(transactionCounts).forEach(async(l) => {
        var transactionName = transactionFolders[l];
        console.log('transaction name: ', transactionName);
        const transactionFolderPath = path.join(testFolder, `/${transactionName}`);
        // get all files in the transaction folder
        const filesInTransaction = fs.readdirSync(transactionFolderPath, 'utf-8');
        // read setup
        const setupPath = path.join(transactionFolderPath, '/setup.txt');
        // transaction count default to 1
        var transactionCount; /*= filesInTransaction.length-2*/
        var aggregationMethod = 'average';
        // parsing setup.txt
        if (fs.existsSync(setupPath)) {
          console.log('setup exists');
          const setupFS = fs.readFileSync(setupPath, 'utf-8');
          const setupLines = setupFS.split(/\r?\n/);
          let i = 0;
          while(i < setupLines.length) {
            let sl = setupLines[i];
            if(sl.startsWith('method')) {
              aggregationMethod = sl.split(',')[1];
            }
            if (sl.startsWith('nt')) {
              transactionCount = +sl.split(',')[1];
            }
            i++;
          }
        }
        console.log('transaction count: ', transactionCount); 
        it(`Testing ${contractName}.${transactionName} gas consumption`, async() => {
          var resultTotal = 0;
          var resultArr = [];
          var instance;
          var line;
          var fromAccountIndex = -1;
          var valueTran = -1;
          var currentFuncName;
          var currentCallFrom;
          var opcodeData = '';
          var gasUsedOpTotal = 0;
          var gasUsedComputeTotal = 0;
          var gasUsedMemReadTotal = 0;
          var gasUsedMemWriteTotal = 0;
          var gasUsedMemTotal_others = 0;
          var gasUsedStorageTotal = 0;
          var storageOverheadTotal_read = 0;
          var storageOverheadTotal_write = 0;
          var readGasCostTotal = 0;
          var writeGasCostTotal = 0;
          var sload_2100_slotTotal = 0;
          var sload_100_slotTotal = 0;
          var sstore_22100_slotTotal = 0;
          var sstore_20000_slotTotal = 0;
          var sstore_5000_slotTotal = 0;
          var sstore_2900_slotTotal = 0;
          var sstore_100_slotTotal = 0;
          var storage_over_opTotal = 0;
          var read_over_opTotal = 0;
          var write_over_opTotal = 0;
          var read_over_writeTotal = 0;
          for (let i = 0; i < transactionCount; i++) {
            // get the tracefile based on the index
            var traceFileName = `${transactionName}_${i.toString()}.txt`;
            if(!traceFileName.startsWith(transactionName)) {
              continue;
            }
            opcodeData += `------------- opcode for test${i} --------------\n`;
            const transactionFS = fs.readFileSync(path.join(transactionFolderPath, `./${traceFileName}`), 'utf-8');

            const lineArr = transactionFS.split(/\r?\n/);
            const lineCount = lineArr.length;

            for(let j = 0; j < lineCount; j++) {
              line = lineArr[j];
              console.log(line);
              // split each line by comma
              const eachLineArr = line.split(',');
              var argArr = [];
              var argsCount;
              if(line != '') {
                // console.log(line);
                if(eachLineArr[3] != '') {
                  argArr = eachLineArr[3].split(' ');
                }
                argsCount = argArr.length;
                // convert args for the function to the correct data type

                if(argsCount > 0) {
                  for(let n = 0; n < argsCount; n++) {
                    let ele = argArr[n];
                    if(!isNaN(ele)) {
                      argArr[n] = +ele;
                    }
                    if(ele.startsWith('accounts')) {
                      let init = ele.indexOf('[');
                      let fin = ele.indexOf(']');
                      let accountsNum = +ele.substr(init+1,fin-init-1);
                      argArr[n] = accounts[accountsNum];
                    }
                    if(ele == 'emptyArr') {
                      let emptyArr = [];
                      argArr[n] = emptyArr;
                    }
                  }
                }

                if (eachLineArr[4] != '') {
                  fromAccountIndex = +eachLineArr[4];
                }
                if (eachLineArr[5] != '') {
                  if(eachLineArr[5].startsWith('web3.utils.toWei')) {
                    let valueStr = eachLineArr[5];
                    let parentOpen = valueStr.indexOf('(');
                    let parentClose = valueStr.indexOf(')');
                    let insideParent = valueStr.substr(parentOpen+1,parentClose-parentOpen-1);
                    let insideParentArr = insideParent.split(' ');
                    valueTran = web3.utils.toWei(insideParentArr[0], insideParentArr[1]);
                  } else {
                    valueTran = +eachLineArr[5];
                  }
                } 
                // call constructor
                if(eachLineArr[1] == 'constructor') {
                  if(fromAccountIndex != -1 && valueTran!= -1) {
                    // console.log('from + value');
                    instance = await Contract.new(...argArr, {from: accounts[fromAccountIndex], value: valueTran});
                  } else if(fromAccountIndex != -1) {
                    // console.log('from ');
                    instance = await Contract.new(...argArr, {from: accounts[fromAccountIndex]});
                  } else if(valueTran != -1) {
                    // console.log('value');
                    instance = await Contract.new(...argArr, {value: valueTran});
                  } else {
                    // console.log('neither from + value');
                    instance = await Contract.new(...argArr);
                  }  
                }
                // call transaction
                else if(eachLineArr[6].startsWith('true')) {
                  var result;
                  if(fromAccountIndex != -1 && valueTran!= -1) {
                    result = await instance[transactionName](...argArr, {from: accounts[fromAccountIndex], value: valueTran});
                  } else if(fromAccountIndex != -1) {
                    result = await instance[transactionName](...argArr, {from: accounts[fromAccountIndex]});
                  } else if(valueTran != -1) {
                    result = await instance[transactionName](...argArr, {value: valueTran});
                  } else {
                    result = await instance[transactionName](...argArr);
                  }   
                  let gasUsed = await result.receipt.gasUsed;
                  let hash = await result.tx;
                  resultTotal += gasUsed;
                  resultArr.push(gasUsed);
                  console.log(`Gas used by ${contractName}.${transactionName} (test ${i}): `, gasUsed);
                  // get trace of transaction
                  var gasUsedOp = 0;
                  var gasUsedCompute = 0;
                  var gasUsedMemWrite = 0;
                  var gasUsedMemRead = 0;
                  var gasUsedStorage = 0;
                  var gasUsedMem_others = 0;
                  var storageOverhead_write = 0; // slots (1 slot = 32 bytes)
                  var storageOverhead_read = 0; // slots (1 slot = 32 bytes)
                  var readGasCost = 0;
                  var writeGasCost = 0;
                  var sload_2100_slot = 0;
                  var sload_100_slot = 0;
                  var sstore_22100_slot = 0;
                  var sstore_20000_slot = 0;
                  var sstore_5000_slot = 0;
                  var sstore_2900_slot = 0;
                  var sstore_100_slot = 0;
                  var storage_over_op = 0;
                  var read_over_op = 0;
                  var write_over_op = 0;
                  var read_over_write = 0;
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
                     if(log.op == 'MSTORE' || log.op == 'MSTORE8') {
                       gasUsedMemWrite += +log.gasCost;
                     } else if ( log.op == 'MLOAD') {
                       gasUsedMemRead += +log.gasCost;
                     } else if(log.op == 'KECCAK256'|| log.op == 'CALLDATACOPY' || log.op == 'CODECOPY' || log.op == 'EXTCODECOPY' || log.op == 'RETURNDATACOPY' || log.op == 'LOG0' || log.op == 'LOG1' || log.op == 'LOG2' || log.op == 'LOG3' || log.op == 'LOG4' || log.op == 'CREATE' || log.op == 'CALL' || log.op == 'CALLCODE' || log.op == 'RETURN' || log.op == 'DELEGATECALL' || log.op == 'CREATE2' || log.op == 'STATICCALL') {
                       gasUsedMem_others += +log.gasCost;
                     } else if (log.op == 'SLOAD') {
                       gasUsedStorage += +log.gasCost;
                       readGasCost += +log.gasCost;
                       storageOverhead_read++;
                       if(+log.gasCost == 2100) {
                         sload_2100_slot++;
                       } 
                       else if (+log.gasCost == 100) {
                         sload_100_slot++;
                       }
                     } else if (log.op == 'SSTORE') {
                       gasUsedStorage += +log.gasCost;
                       writeGasCost += +log.gasCost;
                       storageOverhead_write++;
                       if(+log.gasCost == 22100) {
                         sstore_22100_slot++;
                       } 
                       else if(+log.gasCost == 20000) {
                         sstore_20000_slot++;
                       }
                       else if(+log.gasCost == 5000) {
                         sstore_5000_slot++;
                       }
                       else if(+log.gasCost == 2900) {
                         sstore_2900_slot++;
                       }
                       else if(+log.gasCost == 100) {
                         sstore_100_slot++;
                       }
                     }
                     else {
                       gasUsedCompute += +log.gasCost;
                     }
                     // export the opcode data to a file: 
                     opcodeData += `op: ${log.op} gas: ${log.gas} gasCost: ${log.gasCost}\n`;
                     opcodeData += `memory: ${log.memory}\n`;
                     opcodeData += `storage: ${JSON.stringify(log.storage)}\n\n`;
                   })
                 })
                 storage_over_op = round((gasUsedStorage / gasUsedOp) * 100);
                 read_over_op = round((readGasCost / gasUsedOp) * 100);
                 write_over_op = round((writeGasCost / gasUsedOp) * 100);
                 read_over_write = round((readGasCost / writeGasCost) * 100);
                 // storage_over_op.toFixed(decimal);
                 // read_over_op.toFixed(decimal);
                 // write_over_op.toFixed(decimal);
                 // read_over_write.toFixed(decimal);
                 opcodeData += `\nGas cost (from result.receipt): ${gasUsed}\n`;
                 opcodeData += `Gas cost (from opcodes): ${gasUsedOp}\n`;
                 opcodeData += `Gas cost (memory read operations): ${gasUsedMemRead}\n`;
                 opcodeData += `Gas cost (memory write operations): ${gasUsedMemWrite}\n`;
                 opcodeData += `Gas cost (memory_others operations): ${gasUsedMem_others}\n`;
                 opcodeData += `Gas cost (storage operations): ${gasUsedStorage}\n`;
                 opcodeData += `Gas cost (computation operations): ${gasUsedCompute}\n\n`;
                 opcodeData += `Transaction storage overhead (read): ${storageOverhead_read} slot(s)\n`;
                 opcodeData += `Read Gas Cost: ${readGasCost}\n`;
                 opcodeData += `Transaction storage overhead (write): ${storageOverhead_write} slot(s)\n`;
                 opcodeData += `Write Gas Cost: ${writeGasCost}\n`;
                 opcodeData += `SLOAD 2100 slot: ${sload_2100_slot}\n`;
                 opcodeData += `SLOAD 100 slot: ${sload_100_slot}\n`;
                 opcodeData += `SSTORE 22100 slot: ${sstore_22100_slot}\n`;
                 opcodeData += `SSTORE 20000 slot: ${sstore_20000_slot}\n`;
                 opcodeData += `SSTORE 5000 slot: ${sstore_5000_slot}\n`;
                 opcodeData += `SSTORE 2900 slot: ${sstore_2900_slot}\n`;
                 opcodeData += `SSTORE 100 slot: ${sstore_100_slot}\n`;
                 opcodeData += `Storage gas cost over Op: ${storage_over_op}%\n`;
                 opcodeData += `Read gas cost over Op: ${read_over_op}%\n`;
                 opcodeData += `Write gas cost over Op: ${write_over_op}%\n`;
                 opcodeData += `Read gas cost over write gas cost: ${read_over_write}%\n`;

                 gasUsedOpTotal += gasUsedOp;
                 gasUsedComputeTotal += gasUsedCompute;
                 gasUsedMemReadTotal += gasUsedMemRead;
                 gasUsedMemWriteTotal += gasUsedMemWrite;
                 gasUsedMemTotal_others += gasUsedMem_others;
                 gasUsedStorageTotal += gasUsedStorage;
                 storageOverheadTotal_read += storageOverhead_read;
                 storageOverheadTotal_write += storageOverhead_write;
                 readGasCostTotal += readGasCost;
                 writeGasCostTotal += writeGasCost;
                 sload_2100_slotTotal += sload_2100_slot;
                 sload_100_slotTotal += sload_100_slot;
                 sstore_22100_slotTotal += sstore_22100_slot;
                 sstore_20000_slotTotal += sstore_20000_slot;
                 sstore_5000_slotTotal += sstore_5000_slot;
                 sstore_2900_slotTotal += sstore_2900_slot;
                 sstore_100_slotTotal += sstore_100_slot;
                 storage_over_opTotal += storage_over_op;
                 read_over_opTotal += read_over_op;
                 write_over_opTotal += write_over_op;
                 read_over_writeTotal += read_over_write;
                }
                // call intermediate functions
                else {
                  currentFuncName = eachLineArr[1];
                  currentCallFrom = eachLineArr[2];
                  // if called from previous instance of the contract
                  if(currentCallFrom == 'instance') {
                    // console.log('calling intance ...');
                    if(fromAccountIndex != -1 && valueTran!= -1) {
                      // console.log('from + value');
                      await instance[currentFuncName](...argArr, {from: accounts[fromAccountIndex], value: valueTran});
                    } else if(fromAccountIndex != -1) {
                      // console.log('from ');
                      await instance[currentFuncName](...argArr, {from: accounts[fromAccountIndex]});
                    } else if(valueTran != -1) {
                      // console.log('value');
                      await instance[currentFuncName](...argArr, {value: valueTran});
                    } else {
                      // console.log('neither from + value');
                      await instance[currentFuncName](...argArr);
                    }                  
                  }
                  // if others
                  else if (currentCallFrom == 'time' && currentFuncName == 'increase') {
                    // get the time to increase
                    let bracketOpen = eachLineArr[3].indexOf('[');
                    let bracketClose = eachLineArr[3].indexOf(']');
                    let timeValue = +eachLineArr[3].substr(bracketOpen+1,bracketClose-bracketOpen-1);
                    // console.log(timeValue);
                    const timeUnit = eachLineArr[3].split('.')[2];
                    if(timeUnit.startsWith('seconds')) {
                      await time[currentFuncName](time.duration.seconds(timeValue));
                    }
                    if(timeUnit.startsWith('days')) {
                      await time[currentFuncName](time.duration.days(timeValue));
                    }

                  }
                  else if(currentCallFrom == 'time' && currentFuncName == 'advanceBlock') {
                    console.log('here!');
                    let height = +eachLineArr[3];
                    let currentBlock = await time.latestBlock();
                    await time.advanceBlockTo(currentBlock+height);
                  }
                }
                // reset value for 'from' and 'value'
                fromAccountIndex = -1;
                valueTran = -1;
              }
            }
          }
          // calculate aggregation
          var gasUsedAgg;
          var gasUsedOpAgg;
          var gasUsedMemReadAgg;
          var gasUsedMemWriteAgg;
          var gasUsedMemAgg_others;
          var gasUsedStorageAgg;
          var gasUsedComputeAgg;
          var storageOverheadAgg_read;
          var storageOverheadAgg_write;
          var readGasCostAgg;
          var writeGasCostAgg;
          var sload_2100_slotAgg;
          var sload_100_slotAgg;
          var sstore_22100_slotAgg;
          var sstore_20000_slotAgg;
          var sstore_5000_slotAgg;
          var sstore_2900_slotAgg;
          var sstore_100_slotAgg;
          var storage_over_opAgg;
          var read_over_opAgg;
          var write_over_opAgg;
          var read_over_writeAgg;
          if(aggregationMethod == 'average') {
            gasUsedAgg =  resultTotal / transactionCount;
            gasUsedOpAgg = gasUsedOpTotal / transactionCount;
            gasUsedMemReadAgg = gasUsedMemReadTotal / transactionCount;
            gasUsedMemWriteAgg = gasUsedMemWriteTotal / transactionCount;
            gasUsedMemAgg_others = gasUsedMemTotal_others / transactionCount;
            gasUsedStorageAgg = gasUsedStorageTotal / transactionCount;
            gasUsedComputeAgg = gasUsedComputeTotal / transactionCount;
            storageOverheadAgg_read = storageOverheadTotal_read / transactionCount; 
            storageOverheadAgg_write = storageOverheadTotal_write / transactionCount; 
            readGasCostAgg = readGasCostTotal / transactionCount;
            writeGasCostAgg = writeGasCostTotal / transactionCount;
            sload_2100_slotAgg = sload_2100_slotTotal / transactionCount;
            sload_100_slotAgg = sload_100_slotTotal / transactionCount;
            sstore_22100_slotAgg = sstore_22100_slotTotal / transactionCount;
            sstore_20000_slotAgg = sstore_20000_slotTotal / transactionCount;
            sstore_5000_slotAgg = sstore_5000_slotTotal / transactionCount;
            sstore_2900_slotAgg = sstore_2900_slotTotal / transactionCount;
            sstore_100_slotAgg = sstore_100_slotTotal / transactionCount;
            storage_over_opAgg = round(storage_over_opTotal / transactionCount);
            read_over_opAgg = round(read_over_opTotal / transactionCount);
            write_over_opAgg = round(write_over_opTotal / transactionCount);
            read_over_writeAgg = round(read_over_writeTotal / transactionCount);
            // storage_over_opAgg.toFixed(decimal);
            // read_over_opAgg.toFixed(decimal);
            // write_over_opAgg.toFixed(decimal);
            // read_over_writeAgg.toFixed(decimal);
          }
          console.log(`${contractName}.${transactionName} Gas Used (from result.receipt) (${aggregationMethod}): `, gasUsedAgg);
          console.log(`${contractName}.${transactionName} Gas Used (from opcodes)(${aggregationMethod}): `, gasUsedOpAgg);
          console.log(`${contractName}.${transactionName} Gas Used (memory read operations)(${aggregationMethod}): `, gasUsedMemReadAgg);
          console.log(`${contractName}.${transactionName} Gas Used (memory write operations)(${aggregationMethod}): `, gasUsedMemWriteAgg);
          console.log(`${contractName}.${transactionName} Gas Used (memory_others operations)(${aggregationMethod}): `, gasUsedMemAgg_others);
          console.log(`${contractName}.${transactionName} Gas Used (storage operations)(${aggregationMethod}): `, gasUsedStorageAgg);
          console.log(`${contractName}.${transactionName} Gas Used (computation operations)(${aggregationMethod}): `, gasUsedComputeAgg);
          console.log(`${contractName}.${transactionName} Storage overhead (read)(${aggregationMethod}): `, storageOverheadAgg_read);
          console.log(`${contractName}.${transactionName} Storage overhead (write)(${aggregationMethod}): `, storageOverheadAgg_write);
          console.log(`${contractName}.${transactionName} Read gas cost (${aggregationMethod}): `, readGasCostAgg);
          console.log(`${contractName}.${transactionName} Write gas cost (${aggregationMethod}): `, writeGasCostAgg);
          console.log(`${contractName}.${transactionName} SLOAD 2100 slot (${aggregationMethod}): `, sload_2100_slotAgg);
          console.log(`${contractName}.${transactionName} SLOAD 100 slot (${aggregationMethod}): `, sload_100_slotAgg);
          console.log(`${contractName}.${transactionName} SSTORE 22100 slot (${aggregationMethod}): `, sstore_22100_slotAgg);
          console.log(`${contractName}.${transactionName} SSTORE 20000 slot (${aggregationMethod}): `, sstore_20000_slotAgg);
          console.log(`${contractName}.${transactionName} SSTORE 5000 slot (${aggregationMethod}): `, sstore_5000_slotAgg);
          console.log(`${contractName}.${transactionName} SSTORE 2900 slot (${aggregationMethod}): `, sstore_2900_slotAgg);
          console.log(`${contractName}.${transactionName} SSTORE 100 slot (${aggregationMethod}): `, sstore_100_slotAgg);

          console.log(`${contractName}.${transactionName} Storage over op (${aggregationMethod}): `, storage_over_opAgg, '%');
          console.log(`${contractName}.${transactionName} Read over op (${aggregationMethod}): `, read_over_opAgg, '%');
          console.log(`${contractName}.${transactionName} Write over op (${aggregationMethod}): `, write_over_opAgg, '%');
          console.log(`${contractName}.${transactionName} Read over write (${aggregationMethod}): `, read_over_writeAgg, '%');
          // export opdata to file
          opcodeData += `summary:\n`;
          opcodeData += `gas: ${gasUsedAgg}\n`;
          opcodeData += `gas_op: ${gasUsedOpAgg}\n`;
          opcodeData += `gas_memory_read: ${gasUsedMemReadAgg}\n`;
          opcodeData += `gas_memory_write: ${gasUsedMemWriteAgg}\n`;
          opcodeData += `gas_memory_other: ${gasUsedMemAgg_others}\n`;
          opcodeData += `gas_storage: ${gasUsedStorageAgg}\n`;
          opcodeData += `gas_computation: ${gasUsedComputeAgg}\n`;
          opcodeData += `storage_overhead_read_slot: ${storageOverheadAgg_read}\n`;
          opcodeData += `storage_overhead_write_slot: ${storageOverheadAgg_write}\n`;
          opcodeData += `storage_read_cost: ${readGasCostAgg}\n`;
          opcodeData += `storage_write_cost: ${writeGasCostAgg}\n`;
          opcodeData += `sload_2100_slot: ${sload_2100_slotAgg}\n`;
          opcodeData += `sload_100_slot: ${sload_100_slotAgg}\n`;
          opcodeData += `sstore_22100_slot: ${sstore_22100_slotAgg}\n`;
          opcodeData += `sstore_20000_slot: ${sstore_20000_slotAgg}\n`;
          opcodeData += `sstore_5000_slot: ${sstore_5000_slotAgg}\n`;
          opcodeData += `sstore_2900_slot: ${sstore_2900_slotAgg}\n`;
          opcodeData += `sstore_100_slot: ${sstore_100_slotAgg}\n`;
          opcodeData += `storage_over_op: ${storage_over_opAgg}%\n`;
          opcodeData += `read_over_op: ${read_over_opAgg}%\n`;
          opcodeData += `write_over_op: ${write_over_opAgg}%\n`;
          opcodeData += `read_over_write: ${read_over_writeAgg}%\n`;
          fs.writeFileSync(path.join(transactionFolderPath, '/opcode.txt'), opcodeData);
        }) 
      })

  })
}

module.exports = { range, random, runTests };







