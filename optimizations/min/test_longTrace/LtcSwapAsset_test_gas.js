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

const lowerBound = 10;
const upperBound = 1000;

const testFolder = path.join(__dirname, `../tracefiles_long/ltcSwapAsset`);
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


  if(transactionName == 'mint') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != owner) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let swapAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let swapAmount = helper.random(lowerBound, upperBound+1);
      let mintAccountIndex_1 = helper.random(0, deployAccountCount);
      let mintAmount_1 = helper.random(lowerBound, upperBound+1);      
      let mintAmount_2 = helper.random(lowerBound, upperBound+1);
      let text = `mint,constructor,,,${owner},,false\nmint,mint,instance,accounts[${owner}] ${mintAmount_1},${owner},,false\nmint,mint,instance,accounts[${owner}] ${mintAmount_2},${owner},,true\n`;
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
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != owner) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount_1 = helper.random(lowerBound, upperBound+1);
      let approveAmount_2 = approveAmount_1+ helper.random(0, upperBound+1);
      let text = `approve,constructor,,,${owner},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_1},${owner},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_2},${owner},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }

  if(transactionName == 'swapOwner') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != owner) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let swapAccountIndex_1 = arrayRandom[helper.random(0, arrayRandomLen)];
      let swapAmount_1 = helper.random(1, 10);
      arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != swapAccountIndex_1) {
          arrayRandom.push(appIndex);
        }
      }
      arrayRandomLen = arrayRandom.length;
      let swapAccountIndex_2 = arrayRandom[helper.random(0, arrayRandomLen)];
      let swapAmount_2 = helper.random(1, 10);
      let text = `swapOwner,constructor,,,${owner},,false\nswapOwner,swapOwner,instance,accounts[${owner}] accounts[${swapAccountIndex_1}] ${swapAmount_1},${owner},,false\nswapOwner,increase,time,time.duration.seconds[${swapAmount_1+1}],,,false\nswapOwner,swapOwner,instance,accounts[${swapAccountIndex_1}] accounts[${swapAccountIndex_2}] ${swapAmount_2},${swapAccountIndex_1},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }


  if(transactionName == 'burn') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let constructorSenderIndex = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let burnAmount_1  = helper.random(1, (mintAmount+1)/2);
      let burnAmount_2  = helper.random(1, (mintAmount+1)/2);
      let text = `burn,constructor,,,${constructorSenderIndex},,false\nburn,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${constructorSenderIndex},,false\nburn,burn,instance,accounts[${mintAccountIndex}] ${burnAmount_1},${constructorSenderIndex},,false\nburn,burn,instance,accounts[${mintAccountIndex}] ${burnAmount_2},${constructorSenderIndex},,true\n`;
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
      let constructorSenderIndex = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != mintAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(1, mintAmount+1);
      let transferFromToAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferFromAmount_1 = helper.random(1, (approveAmount+1)/2);
      let transferFromAmount_2 = helper.random(1, (approveAmount+1)/2);
      let text = `transferFrom,constructor,,,${constructorSenderIndex},,false\ntransferFrom,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${constructorSenderIndex},,false\ntransferFrom,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${mintAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${mintAccountIndex}] accounts[${transferFromToAccountIndex}] ${transferFromAmount_1},${approveAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${mintAccountIndex}] accounts[${transferFromToAccountIndex}] ${transferFromAmount_2},${approveAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }  

  if(transactionName == 'transfer') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != mintAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let transferAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferAmount_1 = helper.random(1, (mintAmount+1)/2);
      let transferAmount_2 = helper.random(1, (mintAmount+1)/2);
      let text = `transfer,constructor,,,${owner},,false\ntransfer,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${owner},,false\ntransfer,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount_1},${mintAccountIndex},,false\ntransfer,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount_2},${mintAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }

})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName)
