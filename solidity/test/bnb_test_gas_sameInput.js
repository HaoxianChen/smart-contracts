const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const fs = require('fs');
const path = require('path');

// set up tests for contracts
const testPath = path.join(__dirname, '../tracefiles/bnb/setup.txt');
const setup = fs.readFileSync(testPath, 'utf-8');
let contractName;
setup.split(/\r?\n/).some(line => {
  if(line[0] == 'n' && line[1] != 'a') {
    let lineArr = line.split(',');
    contractName = lineArr[1];
    return true;
  }
})

var BNB = artifacts.require(contractName);

contract(`${contractName}`, async accounts => {
  const testFolder = path.join(__dirname, `../tracefiles/${contractName}`);
  const testFiles = fs.readdirSync(testFolder);
  const filesCount = testFiles.length;
  for(let m = 0; m < filesCount; m++) {
    const file = testFiles[m];
    if(file != 'setup.txt') {
      it(``, async() => {
        const transactionName = file.split('.')[0];
        console.log(transactionName);
        const transactionFS = fs.readFileSync(path.join(testFolder, `./${file}`), 'utf-8');
        const lineArr = transactionFS.split(/\r?\n/);
        const lineCount = lineArr.length;
        var transactionCount = lineArr[0].split(',')[1];
        var resultArr = [];
        var instance;
        var line;
        var fromAccountIndex = -1;
        var valueTran = -1;
        var currentFuncName;
        var currentCallFrom;
        for(let i = 0; i < transactionCount; i++) {
          for(let j = 0; j < lineCount; j++) {
            line = lineArr[j];
            // split each line by comma
            const eachLineArr = line.split(',');
            var argArr = [];
            var argsCount;
            if(line != '' && j != 0) {
              console.log(line);
              // if(j == 1) {
              //   // call constructor
              //   console.log(`${transactionName} calling constructor ...`);
              // } else if(eachLineArr[0] == eachLineArr[1]) {
              //   console.log(`${transactionName} calling transaction ...`);
              // } else {
              //   console.log(`${transactionName} calling intermediate functions ...`);
              // }
              // parsing arguments for the current functions
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
              if(j == 1) {
                if(fromAccountIndex != -1 && valueTran!= -1) {
                  // console.log('from + value');
                  instance = await BNB.new(...argArr, {from: accounts[fromAccountIndex], value: valueTran});
                } else if(fromAccountIndex != -1) {
                  // console.log('from ');
                  instance = await BNB.new(...argArr, {from: accounts[fromAccountIndex]});
                } else if(valueTran != -1) {
                  // console.log('value');
                  instance = await BNB.new(...argArr, {value: valueTran});
                } else {
                  // console.log('neither from + value');
                  instance = await BNB.new(...argArr);
                }  
              }
              // call transaction
              else if(eachLineArr[0] == eachLineArr[1]) {
                var result;
                if(fromAccountIndex != -1 && valueTran!= -1) {
                  // console.log('from + value');
                  result = await instance[transactionName](...argArr, {from: accounts[fromAccountIndex], value: valueTran});
                } else if(fromAccountIndex != -1) {
                  // console.log('from ');
                  result = await instance[transactionName](...argArr, {from: accounts[fromAccountIndex]});
                } else if(valueTran != -1) {
                  // console.log('value');
                  result = await instance[transactionName](...argArr, {value: valueTran});
                } else {
                  // console.log('neither from + value');
                  result = await instance[transactionName](...argArr);
                }   
                let gasUsed = await result.receipt.gasUsed;
                resultArr.push(gasUsed);
                console.log(`Gas used by ${contractName}.${transactionName} (test ${i+1}): `, gasUsed);                            
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
                  // console.log('calling time.increase() ...');
                  // console.log(currentCallFrom);
                  // console.log(currentFuncName);
                  // get the time to increase
                  let bracketOpen = eachLineArr[3].indexOf('[');
                  let bracketClose = eachLineArr[3].indexOf(']');
                  let timeValue = +eachLineArr[3].substr(bracketOpen+1,bracketClose-bracketOpen-1);
                  // console.log(timeValue);
                  await time[currentFuncName](time.duration.seconds(timeValue));
                }
              }
              // reset value for 'from' and 'value'
              fromAccountIndex = -1;
              valueTran = -1;
            }
          }
        }

        // calculate average
        let total = 0;
        resultArr.forEach((value, index) => {
          // console.log(value);
          total += value;
        })
        const gasUsedAvr =  total / transactionCount;
        console.log(`${contractName}.${transactionName} Gas Used: `, gasUsedAvr);

      })     
    }
  }
})









