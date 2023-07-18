const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const helper = require("./helper_functions");
const fs = require('fs');
const path = require('path');

const name = 'name';
const symbol = 'symbol';
const dataLowerBound = 0;
const dataUpperBound = 9*(10**15);
const mintLowerBound = 10;
const mintUpperBound = 1000;

const testFolder = path.join(__dirname, `../tracefiles_long/erc777`);
// set up tests for contracts
const testPath = path.join(testFolder, '/setup.txt');
const setup = fs.readFileSync(testPath, 'utf-8');
let contractName;
let deployAccountCount = 10;
setup.split(/\r?\n/).some(line => {
  let lineArr = line.split(',');
  if(lineArr[0] == 'n') {
    contractName = lineArr[1];
    return true;
  }
  if(lineArr[0] == 'a') {
    deployAccountCount = +lineArr[1];
  }
})

// read setup.txt in each test folder
const transactionFolders = fs.readdirSync(testFolder, {withFileTypes: true})
  .filter(dirent => dirent.isDirectory())
  .map(dirent => dirent.name);
const transactionCounts = transactionFolders.length;
var transactionName;
var transactionFolderPath;
var setupPath;
var transactionCount = 1;
var tracefileCount = 0;

helper.range(transactionCounts).forEach(l => {
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

  if(transactionName == 'burn') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let mintMsgSender = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintLowerBound, mintUpperBound+1);
      let mintUserData = helper.random(dataLowerBound, dataUpperBound);
      let mintOperatorData = helper.random(dataLowerBound, dataUpperBound);
      let burnAmount_1 = helper.random(1, (mintAmount+1)/2);
      let burnAmount_2 = helper.random(1, (mintAmount+1)/2);
      let burnData = helper.random(dataLowerBound, dataUpperBound);
      let text = `burn,constructor,,,${owner},,false\nburn,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${owner},,false\nburn,burn,instance,accounts[${mintAccountIndex}] ${burnAmount_1},${owner},,false\nburn,burn,instance,accounts[${mintAccountIndex}] ${burnAmount_2},${owner},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }  

  if(transactionName == 'mint') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let mintMsgSender = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount_1 = helper.random(mintLowerBound, mintUpperBound+1);
      let mintAmount_2 = helper.random(mintLowerBound, mintUpperBound+1);
      let mintUserData = helper.random(dataLowerBound, dataUpperBound);
      let mintOperatorData = helper.random(dataLowerBound, dataUpperBound);
      let text = `mint,constructor,,,${owner},,false\nmint,mint,instance,accounts[${mintAccountIndex}] ${mintAmount_1},${owner},,false\nmint,mint,instance,accounts[${mintAccountIndex}] ${mintAmount_2},${owner},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }

  if(transactionName == 'approve') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let mintMsgSender = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintLowerBound, mintUpperBound+1);
      let mintUserData = helper.random(dataLowerBound, dataUpperBound);
      let mintOperatorData = helper.random(dataLowerBound, dataUpperBound);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != mintAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount_1 = helper.random(1, (mintAmount+1)/2);
      let approveAmount_2 = approveAmount_1 + helper.random(0, (mintAmount+1)/2);
      let text = `approve,constructor,,,${owner},,false\napprove,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${owner},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_1},${mintAccountIndex},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_2},${mintAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }  

  if(transactionName == 'approveOperator') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let anthSender = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != anthSender) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let authAccountIndex_1 = arrayRandom[helper.random(0, arrayRandomLen)];
      let authAccountIndex_2 = arrayRandom[helper.random(0, arrayRandomLen)];
      let text = `approveOperator,constructor,,,${owner},,false\napproveOperator,approveOperator,instance,accounts[${authAccountIndex_1}],${anthSender},,false\napproveOperator,approveOperator,instance,accounts[${authAccountIndex_2}],${anthSender},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }

  // if(transactionName == 'operatorBurn') {
  //   tracefileCount = transactionCount;
  //   helper.range(tracefileCount).forEach(testFileIndex => {
  //     let fileName = `${transactionName}_${testFileIndex}.txt`;
  //     let mintMsgSender = helper.random(0, deployAccountCount);
  //     let mintAccountIndex = helper.random(0, deployAccountCount);
  //     let mintAmount = helper.random(mintLowerBound, mintUpperBound+1);
  //     let mintUserData = helper.random(dataLowerBound, dataUpperBound);
  //     let mintOperatorData = helper.random(dataLowerBound, dataUpperBound);
  //     let arrayRandom = [];
  //     for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
  //       if(appIndex != mintAccountIndex) {
  //         arrayRandom.push(appIndex);
  //       }
  //     }
  //     let arrayRandomLen = arrayRandom.length;
  //     let authAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
  //     let operatorBurnAmount = helper.random(0, mintAmount+1);
  //     let text = `operatorBurn,constructor,,${name} ${symbol} emptyArr,,,false\noperatorBurn,mint,instance,accounts[${mintAccountIndex}] ${mintAmount} ${mintUserData} ${mintOperatorData},${mintMsgSender},,false\noperatorBurn,authorizeOperator,instance,accounts[${authAccountIndex}],${mintAccountIndex},,false\noperatorBurn,operatorBurn,instance,accounts[${mintAccountIndex}] ${operatorBurnAmount} ${mintUserData} ${mintOperatorData},${authAccountIndex},,true\n`;
  //     fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
  //       if (err) throw err;
  //       console.log('File is created successfully.');
  //     });
  //   }) 
  // } 


  // if(transactionName == 'operatorSend') {
  //   tracefileCount = transactionCount;
  //   helper.range(tracefileCount).forEach(testFileIndex => {
  //     let fileName = `${transactionName}_${testFileIndex}.txt`;
  //     let mintMsgSender = helper.random(0, deployAccountCount);
  //     let mintAccountIndex = helper.random(0, deployAccountCount);
  //     let mintAmount = helper.random(mintLowerBound, mintUpperBound+1);
  //     let mintUserData = helper.random(dataLowerBound, dataUpperBound);
  //     let mintOperatorData = helper.random(dataLowerBound, dataUpperBound);
  //     let arrayRandom = [];
  //     for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
  //       if(appIndex != mintAccountIndex) {
  //         arrayRandom.push(appIndex);
  //       }
  //     }
  //     let arrayRandomLen = arrayRandom.length;
  //     let authAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
  //     let operatorSendAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
  //     let operatorSendAmount = helper.random(0, mintAmount+1);
  //     let text = `operatorSend,constructor,,${name} ${symbol} emptyArr,,,false\noperatorSend,mint,instance,accounts[${mintAccountIndex}] ${mintAmount} ${mintUserData} ${mintOperatorData},${mintMsgSender},,false\noperatorSend,authorizeOperator,instance,accounts[${authAccountIndex}],${mintAccountIndex},,false\noperatorSend,operatorSend,instance,accounts[${mintAccountIndex}] accounts[${operatorSendAccountIndex}] ${operatorSendAmount} ${mintUserData} ${mintOperatorData},${authAccountIndex},,true\n`;
  //     fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
  //       if (err) throw err;
  //       console.log('File is created successfully.');
  //     });
  //   }) 
  // } 

  if(transactionName == 'revokeDefaultOperator') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let authSender = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != authSender) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let authAccountIndex_1 = arrayRandom[helper.random(0, arrayRandomLen)];
      let authAccountIndex_2 = arrayRandom[helper.random(0, arrayRandomLen)];
      let text = `revokeDefaultOperator,constructor,,,${owner},,false\nrevokeDefaultOperator,approveOperator,instance,accounts[${authAccountIndex_1}],${authSender},,false\nrevokeDefaultOperator,revokeDefaultOperator,instance,accounts[${authAccountIndex_1}],${authSender},,false\nrevokeDefaultOperator,approveOperator,instance,accounts[${authAccountIndex_2}],${authSender},,false\nrevokeDefaultOperator,revokeDefaultOperator,instance,accounts[${authAccountIndex_2}],${authSender},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }    

  // if(transactionName == 'send') {
  //   tracefileCount = transactionCount;
  //   helper.range(tracefileCount).forEach(testFileIndex => {
  //     let fileName = `${transactionName}_${testFileIndex}.txt`;
  //     let mintMsgSender = helper.random(0, deployAccountCount);
  //     let mintAccountIndex = helper.random(0, deployAccountCount);
  //     let mintAmount = helper.random(mintLowerBound, mintUpperBound+1);
  //     let mintUserData = helper.random(dataLowerBound, dataUpperBound);
  //     let mintOperatorData = helper.random(dataLowerBound, dataUpperBound);
  //     let arrayRandom = [];
  //     for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
  //       if(appIndex != mintAccountIndex) {
  //         arrayRandom.push(appIndex);
  //       }
  //     }
  //     let arrayRandomLen = arrayRandom.length;
  //     let sendAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
  //     let sendAmount = helper.random(0, mintAmount+1);
  //     let sendData = helper.random(dataLowerBound, dataUpperBound);
  //     let text = `send,constructor,,${name} ${symbol} emptyArr,,,false\nsend,mint,instance,accounts[${mintAccountIndex}] ${mintAmount} ${mintUserData} ${mintOperatorData},${mintMsgSender},,false\nsend,send,instance,accounts[${sendAccountIndex}] ${sendAmount} ${sendData},${mintAccountIndex},,true\n`;
  //     fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
  //       if (err) throw err;
  //       console.log('File is created successfully.');
  //     });
  //   }) 
  // }  


   if(transactionName == 'transfer') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let mintMsgSender = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintLowerBound, mintUpperBound+1);
      let mintUserData = helper.random(dataLowerBound, dataUpperBound);
      let mintOperatorData = helper.random(dataLowerBound, dataUpperBound);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != mintAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let transAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transAmount_1 = helper.random(1, (mintAmount+1)/2);
      let transAmount_2 = helper.random(1, (mintAmount+1)/2);
      let text = `transfer,constructor,,,${owner},,false\ntransfer,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${owner},,false\ntransfer,transfer,instance,accounts[${transAccountIndex}] ${transAmount_1},${mintAccountIndex},,false\ntransfer,transfer,instance,accounts[${transAccountIndex}] ${transAmount_2},${mintAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  } 
   

   if(transactionName == 'transferFrom') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let mintMsgSender = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintLowerBound, mintUpperBound+1);
      let mintUserData = helper.random(dataLowerBound, dataUpperBound);
      let mintOperatorData = helper.random(dataLowerBound, dataUpperBound);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != mintAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(0, mintAmount+1);
      let transferFromToAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferFromAmount_1 = helper.random(1, (approveAmount+1)/2);
      let transferFromAmount_2 = helper.random(1, (approveAmount+1)/2);
      let text = `transferFrom,constructor,,,${owner},,false\ntransferFrom,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${owner},,false\ntransferFrom,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${mintAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${mintAccountIndex}] accounts[${transferFromToAccountIndex}] ${transferFromAmount_1},${approveAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${mintAccountIndex}] accounts[${transferFromToAccountIndex}] ${transferFromAmount_2},${approveAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  } 


    


})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName)
