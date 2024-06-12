const fs = require('fs');
const path = require('path');
const _ = require('lodash');
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
          var gasUsedMemTotal = 0;
          var gasUsedMemTotal_others = 0;
          var gasUsedStorageTotal = 0;
          var storageOverheadTotal_read = 0;
          var storageOverheadTotal_write = 0;
          var readGasCostTotal = 0;
          var writeGasCostTotal = 0;
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
                    if(ele.startsWith('arrOfAccounts')) {
                      let init = ele.indexOf('(');
                      let fin = ele.indexOf(')');
                      let range = ele.substr(init+1,fin-init-1);
                      let indexSmall = +range.split(';')[0];
                      let indexLarge = +range.split(';')[1];
                      argArr[n] = [];
                      for (let accountIndex = indexSmall; accountIndex < indexLarge+1; accountIndex++) {
                        argArr[n].push(accounts[accountIndex]);
                      }
                    }
                    if(ele.startsWith('arrOfShares')) {
                      let init = ele.indexOf('(');
                      let fin = ele.indexOf(')');
                      let range = +ele.substr(init+1,fin-init-1);
                      argArr[n] = [];
                      for(let sharesIndex = 0; sharesIndex < range; sharesIndex++) {
                        let rand = random(1, 8);
                        argArr[n].push(rand);
                      }
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
                  var gasUsedMem = 0;
                  var gasUsedStorage = 0;
                  var gasUsedMem_others = 0;
                  var storageOverhead_write = 0; // slots (1 slot = 32 bytes)
                  var storageOverhead_read = 0; // slots (1 slot = 32 bytes)
                  var readGasCost = 0;
                  var writeGasCost = 0;
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
                       readGasCost += +log.gasCost;
                       // // console.log('type of storage: ', typeof(log.storage));
                       // let storage_json = log.storage;
                       // // console.log('storage for SLOAD: ', JSON.stringify(storage_json));
                       // if (!_.isEqual(storage_json, curr_storage_sload)) {
                       //   // get the size of curr_storage_sload
                       //   let size_pre = Object.keys(curr_storage_sload).length;
                       //   let size_curr = Object.keys(storage_json).length;
                       //   if(size_curr < size_pre) {
                       //     console.log('sload size reduced');
                       //   }
                       //   storageOverhead_read += (size_curr - size_pre);
                       // } else {
                       //   // console.log('repeated read');
                       // }
                       // curr_storage_sload = storage_json;
                       storageOverhead_read++;
                     } else if (log.op == 'SSTORE') {
                       gasUsedStorage += +log.gasCost;
                       writeGasCost += +log.gasCost;
                       storageOverhead_write++;
                       // if_sstore = true;
                       // console.log('sstore');
                       // curr_storage_sstore = log.storage;
                     }
                     else {
                       gasUsedCompute += +log.gasCost;
                     }

                     // if(log.op != 'SSTORE' && if_sstore == true) {
                     //   // console.log('opcode following sstore');
                     //   for (const key of Object.keys(log.storage)) {
                     //     if(log.storage[key] != curr_storage_sstore[key]) {
                     //       // console.log('sstore changes storage');
                     //       storageOverhead_write ++;
                     //     }
                     //  }
                     //  if_sstore = false;
                     // }
                     // export the opcode data to a file: 
                     opcodeData += `op: ${log.op} gas: ${log.gas} gasCost: ${log.gasCost}\n`;
                     opcodeData += `memory: ${log.memory}\n`;
                     opcodeData += `storage: ${JSON.stringify(log.storage)}\n\n`;
                   })
                 })
                 opcodeData += `\nGas cost (from result.receipt): ${gasUsed}\n`;
                 opcodeData += `Gas cost (from opcodes): ${gasUsedOp}\n`;
                 opcodeData += `Gas cost (memory operations): ${gasUsedMem}\n`;
                 opcodeData += `Gas cost (memory_others operations): ${gasUsedMem_others}\n`;
                 opcodeData += `Gas cost (storage operations): ${gasUsedStorage}\n`;
                 opcodeData += `Gas cost (computation operations): ${gasUsedCompute}\n\n`;
                 opcodeData += `Transaction storage overhead (read): ${storageOverhead_read} slot(s)\n`;
                 opcodeData += `Read Gas Cost: ${readGasCost}\n`;
                 opcodeData += `Transaction storage overhead (write): ${storageOverhead_write} slot(s)\n`;
                 opcodeData += `Write Gas Cost: ${writeGasCost}\n`;

                 gasUsedOpTotal += gasUsedOp;
                 gasUsedComputeTotal += gasUsedCompute;
                 gasUsedMemTotal += gasUsedMem;
                 gasUsedMemTotal_others += gasUsedMem_others;
                 gasUsedStorageTotal += gasUsedStorage;
                 storageOverheadTotal_read += storageOverhead_read;
                 storageOverheadTotal_write += storageOverhead_write;
                 readGasCostTotal += readGasCost;
                 writeGasCostTotal += writeGasCost;
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
                  else if (currentCallFrom == 'time') {
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

                  } else if(currentCallFrom == 'fallback') {
                    // not used yet, in case transfer/send needs to be called
                    // // get the account to transfer to
                    // let transferToAccountIndex = +eachLineArr[3]
                    // console.log('transfer to account index: ', transferToAccountIndex);
                    // // get the transfer amount
                    // let valueStr = eachLineArr[5];
                    // let parentOpen = valueStr.indexOf('(');
                    // let parentClose = valueStr.indexOf(')');
                    // let insideParent = valueStr.substr(parentOpen+1,parentClose-parentOpen-1);
                    // let insideParentArr = insideParent.split(' ');
                    // let transferAmount = web3.utils.toWei(insideParentArr[0], insideParentArr[1]);
                    // await instance['send'](transferAmount, {value: transferAmount});
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
          var gasUsedMemAgg;
          var gasUsedMemAgg_others;
          var gasUsedStorageAgg;
          var gasUsedComputeAgg;
          var storageOverheadAgg_read;
          var storageOverheadAgg_write;
          var readGasCostAgg;
          var writeGasCostAgg;
          if(aggregationMethod == 'average') {
            gasUsedAgg =  resultTotal / transactionCount;
            gasUsedOpAgg = gasUsedOpTotal / transactionCount;
            gasUsedMemAgg = gasUsedMemTotal / transactionCount;
            gasUsedMemAgg_others = gasUsedMemTotal_others / transactionCount;
            gasUsedStorageAgg = gasUsedStorageTotal / transactionCount;
            gasUsedComputeAgg = gasUsedComputeTotal / transactionCount;
            storageOverheadAgg_read = storageOverheadTotal_read / transactionCount; 
            storageOverheadAgg_write = storageOverheadTotal_write / transactionCount; 
            readGasCostAgg = readGasCostTotal / transactionCount;
            writeGasCostAgg = writeGasCostTotal / transactionCount;
          }
          console.log(`${contractName}.${transactionName} Gas Used (from result.receipt) (${aggregationMethod}): `, gasUsedAgg);
          console.log(`${contractName}.${transactionName} Gas Used (from opcodes)(${aggregationMethod}): `, gasUsedOpAgg);
          console.log(`${contractName}.${transactionName} Gas Used (memory operations)(${aggregationMethod}): `, gasUsedMemAgg);
          console.log(`${contractName}.${transactionName} Gas Used (memory_others operations)(${aggregationMethod}): `, gasUsedMemAgg_others);
          console.log(`${contractName}.${transactionName} Gas Used (storage operations)(${aggregationMethod}): `, gasUsedStorageAgg);
          console.log(`${contractName}.${transactionName} Gas Used (computation operations)(${aggregationMethod}): `, gasUsedComputeAgg);
          console.log(`${contractName}.${transactionName} Storage overhead (read)(${aggregationMethod}): `, storageOverheadAgg_read);
          console.log(`${contractName}.${transactionName} Storage overhead (write)(${aggregationMethod}): `, storageOverheadAgg_write);
          console.log(`${contractName}.${transactionName} Read gas cost (${aggregationMethod}): `, readGasCostAgg);
          console.log(`${contractName}.${transactionName} Write gas cost ${aggregationMethod}): `, writeGasCostAgg);
          // export opdata to file
          opcodeData += `summary:\n`;
          opcodeData += `gas: ${gasUsedAgg}\n`;
          opcodeData += `gas_op: ${gasUsedOpAgg}\n`;
          opcodeData += `gas_memory: ${gasUsedMemAgg}\n`;
          opcodeData += `gas_memory_other: ${gasUsedMemAgg_others}\n`;
          opcodeData += `gas_storage: ${gasUsedStorageAgg}\n`;
          opcodeData += `gas_computation: ${gasUsedComputeAgg}\n`;
          opcodeData += `storage_overhead_read_slot: ${storageOverheadAgg_read}\n`;
          opcodeData += `storage_overhead_write_slot: ${storageOverheadAgg_write}\n`;
          opcodeData += `storage_read_cost: ${readGasCostAgg}\n`;
          opcodeData += `storage_write_cost: ${writeGasCostAgg}\n`;
          
          fs.writeFileSync(path.join(transactionFolderPath, '/opcode.txt'), opcodeData);
        }) 
      })

  })
}

module.exports = { range, random, runTests };







