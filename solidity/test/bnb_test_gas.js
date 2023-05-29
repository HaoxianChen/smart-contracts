const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const fs = require('fs');
const path = require('path');
const lowerBoundInput = 10;
const upperBoundInput = 1000;

let range = n => [...Array(n).keys()]

function random(min, max) {  
  return Math.floor(
    Math.random() * (max - min) + min
  )
}


// set up tests for contracts
const testPath = path.join(__dirname, '../tracefiles/bnb/setup.txt');
const setup = fs.readFileSync(testPath, 'utf-8');
let contractName;
let deployAccountCount = 10;
setup.split(/\r?\n/).some(line => {
  let lineArr = line.split(',');
  if(line[0] == 'n' && line[1] != 'a') {
    contractName = lineArr[1];
    return true;
  }
  if(lineArr[0] == 'a') {
    deployAccountCount = +lineArr[1];
  }
})

console.log('deploy account count: ', deployAccountCount);

// generate tracefiles in bnb_rand
// read setup.txt in each test folder
const testFolder = path.join(__dirname, `../tracefiles/bnb`);
const transactionFolders = fs.readdirSync(testFolder, {withFileTypes: true})
  .filter(dirent => dirent.isDirectory())
  .map(dirent => dirent.name);
const transactionCounts = transactionFolders.length;
var transactionName;
var transactionFolderPath;
var setupPath;
var transactionCount = 1;
var tracefileCount = 0;


range(transactionCounts).forEach(l => {
  transactionName = transactionFolders[l];
  // get the setup file
  transactionFolderPath = path.join(testFolder, `/${transactionName}`);
  setupPath = path.join(transactionFolderPath, '/setup.txt');
  // get the transaction count in setup.txt for each transaction
  if (fs.existsSync(setupPath)) {
    console.log('setup exists');
    const setupFS = fs.readFileSync(setupPath, 'utf-8');
    const setupLines = setupFS.split(/\r?\n/);
    let i = 0;
    while(i < setupLines.length) {
      let sl = setupLines[i];
      if (sl.startsWith('nt')) {
        transactionCount = +sl.split(',')[1];
      }
      i++;
    }
  }

  if(transactionName == 'approve') {
    tracefileCount = transactionCount;
    range(tracefileCount).forEach(testFileIndex => {
      // construct file name
      let fileName = `${transactionName}_${testFileIndex}.txt`
      // generate random number from 10 to 1000
      let totalSupply =  random(lowerBoundInput, upperBoundInput+1);
      // transfer to a random account but accounts[0]
      let transferToAccountIndex = random(0, deployAccountCount);
      let transferAmount = random(1, totalSupply+1);
      // approve a random account but accounts[transferToAcountIndex]
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != transferToAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[random(0, arrayRandomLen)];
      let approveAmount = random(1, transferAmount);
      let text = `approve,constructor,,${totalSupply} BNBToken 18 BNB,,,false\napprove,transfer,instance,accounts[${transferToAccountIndex}] ${transferAmount},0,,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${transferToAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }

  if(transactionName == 'burn') {
    tracefileCount = transactionCount;
    range(tracefileCount).forEach(testFileIndex => {
      // construct file name
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let totalSupply =  random(lowerBoundInput, upperBoundInput+1);
      let transferToAccountIndex = random(0, deployAccountCount);
      let transferAmount = random(1, totalSupply+1);
      let burnAmount = random(1, transferAmount+1);
      let text = `burn,constructor,,${totalSupply} BNBToken 18 BNB,,,false\nburn,transfer,instance,accounts[${transferToAccountIndex}] ${transferAmount},,,false\nburn,burn,instance,${burnAmount},${transferToAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    })   
  }  

  if(transactionName == 'freeze') {
    tracefileCount = transactionCount;
    range(tracefileCount).forEach(testFileIndex => {
      // construct file name
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let totalSupply =  random(lowerBoundInput, upperBoundInput+1);
      let transferToAccountIndex = random(0, deployAccountCount);
      let transferAmount = random(1, totalSupply+1);
      let freezeAmount = random(1, transferAmount+1);
      let text = `freeze,constructor,,${totalSupply} BNBToken 18 BNB,,,false\nfreeze,transfer,instance,accounts[${transferToAccountIndex}] ${transferAmount},,,false\nfreeze,freeze,instance,${freezeAmount},${transferToAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    })  
  }

  if(transactionName == 'transfer') {
    tracefileCount = transactionCount;
    range(tracefileCount).forEach(testFileIndex => {
      // construct file name
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let totalSupply =  random(lowerBoundInput, upperBoundInput+1);
      let transferToAccountIndex = random(0, deployAccountCount);
      let transferAmount = random(1, totalSupply+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != transferToAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let transferToFinalAccountIndex = arrayRandom[random(0, arrayRandomLen)];
      let transferFinalAmount = random(1, transferAmount+1);
      let text = `transfer,constructor,,${totalSupply} BNBToken 18 BNB,,,false\ntransfer,transfer,instance,accounts[${transferToAccountIndex}] ${transferAmount},,,false\ntransfer,transfer,instance,accounts[${transferToFinalAccountIndex}] ${transferFinalAmount},${transferToAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    })  
  }  

  if(transactionName == 'transferFrom') {
    tracefileCount = transactionCount;
    range(tracefileCount).forEach(testFileIndex => {
      // construct file name
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let totalSupply = random(lowerBoundInput, upperBoundInput+1);
      let transferToAccountIndex = random(0, deployAccountCount);
      let transferAmount = random(1, totalSupply+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != transferToAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[random(0, arrayRandomLen)];
      let approveAmount = random(1, transferAmount+1);
      // transferFrom to a random account but the token's owner (after transfer)
      let transferFromToIndex = arrayRandom[random(0, arrayRandomLen)];
      let transferFromAmount = random(1, approveAmount+1);
      let text = `transferFrom,constructor,,${totalSupply} BNBToken 18 BNB,,,false\ntransferFrom,transfer,instance,accounts[${transferToAccountIndex}] ${transferAmount},,,false\ntransferFrom,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${transferToAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${transferToAccountIndex}] accounts[${transferFromToIndex}] ${transferFromAmount},${approveAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    })  

  }
  if(transactionName == 'unfreeze') {
    tracefileCount = transactionCount;
    range(tracefileCount).forEach(testFileIndex => {
      // construct file name
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let totalSupply = random(lowerBoundInput, upperBoundInput+1);
      let transferToAccountIndex = random(0, deployAccountCount);
      let transferAmount = random(1, totalSupply+1);
      let freezeAmount = random(1, transferAmount+1);
      let unfreezeAmount = random(1, freezeAmount+1);
      let text = `unfreeze,constructor,,${totalSupply} BNBToken 18 BNB,,,false\nunfreeze,transfer,instance,accounts[${transferToAccountIndex}] ${transferAmount},,,false\nunfreeze,freeze,instance,${freezeAmount},${transferToAccountIndex},,false\nunfreeze,unfreeze,instance,${unfreezeAmount},${transferToAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }
  if(transactionName == 'withdrawEther') {
    tracefileCount = transactionCount;
    range(tracefileCount).forEach(testFileIndex => {
      // construct file name
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let totalSupply = random(lowerBoundInput, upperBoundInput+1);
      let valueAmount = random(1, 10+1);
      let withdrawAmount = random(0, valueAmount+1);
      let text = `withdrawEther,constructor,,${totalSupply} BNBToken 18 BNB,,,false\nwithdrawEther,withdrawEther,instance,${withdrawAmount},,web3.utils.toWei(${valueAmount} ether),true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    })   
  }
})


var BNB = artifacts.require(contractName);

contract(`${contractName}`, accounts => {
  const testFolder = path.join(__dirname, `../tracefiles/bnb`);
  // get all transaction folders
  const transactionFolders = fs.readdirSync(testFolder, {withFileTypes: true})
    .filter(dirent => dirent.isDirectory())
    .map(dirent => dirent.name);
  const transactionCounts = transactionFolders.length;

  range(transactionCounts).forEach(async(l) => {
    var transactionName = transactionFolders[l];
    console.log('transaction name: ', transactionName);
    const transactionFolderPath = path.join(testFolder, `/${transactionName}`);
    // get all files in the transaction folder
    const filesInTransaction = fs.readdirSync(transactionFolderPath, 'utf-8');
    // read setup
    const setupPath = path.join(transactionFolderPath, '/setup.txt');
    // transaction count default to 1
    var transactionCount = filesInTransaction.length-2;
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

      for (let i = 0; i < transactionCount; i++) {
        // get the tracefile based on the index
        var traceFileName = `${transactionName}_${i.toString()}.txt`;
        if(!traceFileName.startsWith(transactionName)) {
          continue;
        }
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
              resultTotal += gasUsed;
              resultArr.push(gasUsed);
              console.log(`Gas used by ${contractName}.${transactionName} (test ${i}): `, gasUsed, '\n');                    
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
                let bracketOpen = eachLineArr[3].indexOf('(');
                let bracketClose = eachLineArr[3].indexOf(')');
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
            }
            // reset value for 'from' and 'value'
            fromAccountIndex = -1;
            valueTran = -1;
          }
        }
      }
      // calculate aggregation
      var gasUsedAgg;
      if(aggregationMethod == 'average') {
        // let total = 0;
        // resultArr.forEach((value, index) => {
        //   // console.log(value);
        //   total += value;
        // })
        gasUsedAgg =  resultTotal / transactionCount;
      }
      console.log(`${contractName}.${transactionName} Gas Used (${aggregationMethod}): `, gasUsedAgg);
    }) 
  })
})





