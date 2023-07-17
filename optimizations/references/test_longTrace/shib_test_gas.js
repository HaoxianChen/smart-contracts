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
const name = 'name';
const symbol = 'symbol';
const decimal = 18;

const testFolder = path.join(__dirname, `../tracefiles_long/shib`);
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
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let feeReceiverIndex = helper.random(0, deployAccountCount);
      let tokenOwnerAddressIndex = helper.random(0, deployAccountCount);
      let ownerIndex = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount_1 = helper.random(lowerBound, upperBound+1);
      let mintAmount_2 = helper.random(lowerBound, upperBound+1);
      let text = `mint,constructor,,${name} ${symbol} ${decimal} ${totalSupply} accounts[${feeReceiverIndex}] accounts[${tokenOwnerAddressIndex}],${ownerIndex},,false\nmint,mint,instance,accounts[${mintAccountIndex}] ${mintAmount_1},${ownerIndex},,false\nmint,mint,instance,accounts[${mintAccountIndex}] ${mintAmount_2},${ownerIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }
  if(transactionName == 'burn') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let feeReceiverIndex = helper.random(0, deployAccountCount);
      let tokenOwnerAddressIndex = helper.random(0, deployAccountCount);
      let ownerIndex = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let burnAmount_1 = helper.random(1, (totalSupply+1)/2);
      let burnAmount_2 = helper.random(1, (totalSupply+1)/2);
      let text = `burn,constructor,,${name} ${symbol} ${decimal} ${totalSupply} accounts[${feeReceiverIndex}] accounts[${tokenOwnerAddressIndex}],${ownerIndex},,false\nburn,burn,instance,accounts[${mintAccountIndex}] ${burnAmount_1},${ownerIndex},,false\nburn,burn,instance,accounts[${mintAccountIndex}] ${burnAmount_2},${ownerIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }  

  if(transactionName == 'approve') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let feeReceiverIndex = helper.random(0, deployAccountCount);
      let tokenOwnerAddressIndex = helper.random(0, deployAccountCount);
      let ownerIndex = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount_1 = helper.random(1, (totalSupply+1)/2);
      let approveAmount_2 = approveAmount_1+ helper.random(0, (totalSupply+1)/2);
      let text = `approve,constructor,,${name} ${symbol} ${decimal} ${totalSupply} accounts[${feeReceiverIndex}] accounts[${tokenOwnerAddressIndex}],${ownerIndex},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_1},${mintAccountIndex},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_2},${mintAccountIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }
  if(transactionName == 'transfer') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let feeReceiverIndex = helper.random(0, deployAccountCount);
      let tokenOwnerAddressIndex = helper.random(0, deployAccountCount);
      let ownerIndex = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let transferAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferAmount_1 = helper.random(1, (totalSupply+1)/2);
      let transferAmount_2 = helper.random(1, (totalSupply+1)/2);
      let text = `transfer,constructor,,${name} ${symbol} ${decimal} ${totalSupply} accounts[${feeReceiverIndex}] accounts[${tokenOwnerAddressIndex}],${ownerIndex},,false\ntransfer,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount_1},${tokenOwnerAddressIndex},,false\ntransfer,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount_2},${tokenOwnerAddressIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }  

  if(transactionName == 'transferFrom') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let feeReceiverIndex = helper.random(0, deployAccountCount);
      let tokenOwnerAddressIndex = helper.random(0, deployAccountCount);
      let ownerIndex = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(2, totalSupply+1);
      let transferFromAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferFromAmount_1 = helper.random(1, (approveAmount+1)/2);
      let transferFromAmount_2 = helper.random(1, (approveAmount+1)/2);
      let text = `transferFrom,constructor,,${name} ${symbol} ${decimal} ${totalSupply} accounts[${feeReceiverIndex}] accounts[${tokenOwnerAddressIndex}],${ownerIndex},,false\ntransferFrom,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${tokenOwnerAddressIndex},,false\ntransferFrom,transferFrom,instance,accounts[${tokenOwnerAddressIndex}] accounts[${transferFromAccountIndex}] ${transferFromAmount_1},${approveAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${tokenOwnerAddressIndex}] accounts[${transferFromAccountIndex}] ${transferFromAmount_2},${approveAccountIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }  

  if(transactionName == 'burnFrom') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let feeReceiverIndex = helper.random(0, deployAccountCount);
      let tokenOwnerAddressIndex = helper.random(0, deployAccountCount);
      let ownerIndex = helper.random(0, deployAccountCount);
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
      let approveAmount = helper.random(0, mintAmount+1);
      let burnFromAmount = helper.random(0, approveAmount+1);
      let mintApprovedAmount = approveAmount+100;
      let text = `burnFrom,constructor,,${name} ${symbol} ${decimal} ${totalSupply} accounts[${feeReceiverIndex}] accounts[${tokenOwnerAddressIndex}],${ownerIndex},,false\nburnFrom,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${ownerIndex},,false\nburnFrom,approve,accounts[${approveAccountIndex}] ${approveAmount},${mintAccountIndex},,,false\nburnFrom,mint,instance,accounts[${approveAccountIndex}] ${mintApprovedAmount},${ownerIndex},,false\nburnFrom,burnFrom,instance,accounts[${approveAccountIndex}] ${burnFromAmount},${mintAccountIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }
  if(transactionName == 'increaseAllowance') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let feeReceiverIndex = helper.random(0, deployAccountCount);
      let tokenOwnerAddressIndex = helper.random(0, deployAccountCount);
      let initialTransferAmount = helper.random(1, 10);
      let burnAmount = helper.random(0, totalSupply+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != tokenOwnerAddressIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(0, totalSupply+1);
      let increaseAmount_1 = helper.random(1, 100);
      let increaseAmount_2 = increaseAmount_1+ helper.random(0, 100);
      let text = `increaseAllowance,constructor,,${name} ${symbol} ${decimal} ${totalSupply} accounts[${feeReceiverIndex}] accounts[${tokenOwnerAddressIndex}],,web3.utils.toWei(${initialTransferAmount} ether),false\nincreaseAllowance,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${tokenOwnerAddressIndex},,false\nincreaseAllowance,increaseAllowance,instance,accounts[${approveAccountIndex}] ${increaseAmount_1},${tokenOwnerAddressIndex},,false\nincreaseAllowance,increaseAllowance,instance,accounts[${approveAccountIndex}] ${increaseAmount_2},${tokenOwnerAddressIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }
  if(transactionName == 'decreaseAllowance') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let feeReceiverIndex = helper.random(0, deployAccountCount);
      let tokenOwnerAddressIndex = helper.random(0, deployAccountCount);
      let initialTransferAmount = helper.random(1, 10);
      let burnAmount = helper.random(0, totalSupply+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != tokenOwnerAddressIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(2, totalSupply+1);
      let decreaseAmount_1 = helper.random(1, (approveAmount+1)/2);
      let decreaseAmount_2 = helper.random(1, (approveAmount+1)/2);
      let text = `decreaseAllowance,constructor,,${name} ${symbol} ${decimal} ${totalSupply} accounts[${feeReceiverIndex}] accounts[${tokenOwnerAddressIndex}],,web3.utils.toWei(${initialTransferAmount} ether),false\ndecreaseAllowance,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${tokenOwnerAddressIndex},,false\ndecreaseAllowance,decreaseAllowance,instance,accounts[${approveAccountIndex}] ${decreaseAmount_1},${tokenOwnerAddressIndex},,false\ndecreaseAllowance,decreaseAllowance,instance,accounts[${approveAccountIndex}] ${decreaseAmount_2},${tokenOwnerAddressIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }






    


})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName)
