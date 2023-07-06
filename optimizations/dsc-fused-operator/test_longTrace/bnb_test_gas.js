const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const helper = require("./helper_functions");
// const helper = require("./helper_functions_geth");
const fs = require('fs');
const path = require('path');
const lowerBoundInput = 10;
const upperBoundInput = 1000;

const testFolder = path.join(__dirname, `../tracefiles_long/bnb`);
// set up tests for contracts
const testPath = path.join(testFolder, '/setup.txt');
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

  if(transactionName == 'approve') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      // construct file name
      let fileName = `${transactionName}_${testFileIndex}.txt`
      // generate random number from 10 to 1000
      let totalSupply =  helper.random(lowerBoundInput, upperBoundInput+1);
      // transfer to a random account but accounts[0]
      let transferToAccountIndex = helper.random(0, deployAccountCount);
      let transferAmount = helper.random(2, totalSupply+1);
      // approve a random account but accounts[transferToAcountIndex]
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != transferToAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount_1 = helper.random(1, (transferAmount+1)/2);
      let approveAmount_2 = helper.random(1, (transferAmount+1)/2) + approveAmount_1;
      let text = `approve,constructor,,${totalSupply},,,false\napprove,transfer,instance,accounts[${transferToAccountIndex}] ${transferAmount},0,,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_1},${transferToAccountIndex},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_2},${transferToAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }

  if(transactionName == 'burn') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      // construct file name
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let totalSupply = helper.random(lowerBoundInput, upperBoundInput+1);
      let transferToAccountIndex = helper.random(0, deployAccountCount);
      let transferAmount = helper.random(2, totalSupply+1);
      let burnAmount_1 = helper.random(1, (transferAmount+1)/2);
      let burnAmount_2 = helper.random(1, (transferAmount+1)/2);
      let text = `burn,constructor,,${totalSupply},,,false\nburn,transfer,instance,accounts[${transferToAccountIndex}] ${transferAmount},,,false\nburn,burn,instance,accounts[${transferToAccountIndex}] ${burnAmount_1},,,false\nburn,burn,instance,accounts[${transferToAccountIndex}] ${burnAmount_2},,,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    })   
  }  

  if(transactionName == 'freeze') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      // construct file name
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let totalSupply = helper.random(lowerBoundInput, upperBoundInput+1);
      let transferToAccountIndex = helper.random(0, deployAccountCount);
      let transferAmount = helper.random(2, totalSupply+1);
      let freezeAmount_1 = helper.random(1, (transferAmount+1)/2);
      let freezeAmount_2 = helper.random(1, (transferAmount+1)/2);
      let text = `freeze,constructor,,${totalSupply},,,false\nfreeze,transfer,instance,accounts[${transferToAccountIndex}] ${transferAmount},,,false\nfreeze,freeze,instance,${freezeAmount_1},${transferToAccountIndex},,false\nfreeze,freeze,instance,${freezeAmount_2},${transferToAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    })  
  }

  if(transactionName == 'transfer') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      // construct file name
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let totalSupply = helper.random(lowerBoundInput, upperBoundInput+1);
      let transferToAccountIndex = helper.random(0, deployAccountCount);
      let transferAmount = helper.random(1, totalSupply+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != transferToAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let transferToFinalAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferFinalAmount_1 = helper.random(1, (transferAmount+1)/2);
      let transferFinalAmount_2 = helper.random(1, (transferAmount+1)/2);
      let text = `transfer,constructor,,${totalSupply},,,false\ntransfer,transfer,instance,accounts[${transferToAccountIndex}] ${transferAmount},,,false\ntransfer,transfer,instance,accounts[${transferToFinalAccountIndex}] ${transferFinalAmount_1},${transferToAccountIndex},,false\ntransfer,transfer,instance,accounts[${transferToFinalAccountIndex}] ${transferFinalAmount_2},${transferToAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    })  
  }  

  if(transactionName == 'transferFrom') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      // construct file name
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let totalSupply = helper.random(lowerBoundInput, upperBoundInput+1);
      let transferToAccountIndex = helper.random(0, deployAccountCount);
      let transferAmount = helper.random(2, totalSupply+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != transferToAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(2, transferAmount+1);
      // transferFrom to a random account but the token's owner (after transfer)
      let transferFromToIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferFromAmount_1 = helper.random(1, (approveAmount+1)/2);
      let transferFromAmount_2 = helper.random(1, (approveAmount+1)/2);
      let text = `transferFrom,constructor,,${totalSupply},,,false\ntransferFrom,transfer,instance,accounts[${transferToAccountIndex}] ${transferAmount},,,false\ntransferFrom,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${transferToAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${transferToAccountIndex}] accounts[${transferFromToIndex}] ${transferFromAmount_1},${approveAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${transferToAccountIndex}] accounts[${transferFromToIndex}] ${transferFromAmount_2},${approveAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    })  

  }
  if(transactionName == 'unfreeze') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      // construct file name
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let totalSupply = helper.random(lowerBoundInput, upperBoundInput+1);
      let transferToAccountIndex = helper.random(0, deployAccountCount);
      let transferAmount = helper.random(2, totalSupply+1);
      let freezeAmount = helper.random(2, transferAmount+1);
      let unfreezeAmount_1 = helper.random(1, (freezeAmount+1)/2);
      let unfreezeAmount_2 = helper.random(1, (freezeAmount+1)/2);
      let text = `unfreeze,constructor,,${totalSupply},,,false\nunfreeze,transfer,instance,accounts[${transferToAccountIndex}] ${transferAmount},,,false\nunfreeze,freeze,instance,${freezeAmount},${transferToAccountIndex},,false\nunfreeze,unfreeze,instance,${unfreezeAmount_1},${transferToAccountIndex},,false\nunfreeze,unfreeze,instance,${unfreezeAmount_2},${transferToAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }
  if(transactionName == 'withdrawEther') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      // construct file name
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let owner = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBoundInput, upperBoundInput+1);
      let valueAmount = helper.random(1, 10+1);
      let withdrawAmount_1 = helper.random(1, valueAmount);
      let withdrawAmount_2 = helper.random(1, valueAmount);
      let text = `withdrawEther,constructor,,${totalSupply},${owner},,false\nwithdrawEther,withdrawEther,instance,${withdrawAmount_1},${owner},web3.utils.toWei(${withdrawAmount_1} ether),false\nwithdrawEther,withdrawEther,instance,${withdrawAmount_2},${owner},web3.utils.toWei(${withdrawAmount_2} ether),true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    })   
  }  

  if(transactionName == 'mint') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      // construct file name
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let owner = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBoundInput, upperBoundInput+1);
      let mintAmount_1 = helper.random(lowerBoundInput, upperBoundInput+1);
      let mintAmount_2 = helper.random(lowerBoundInput, upperBoundInput+1);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let text = `mint,constructor,,${totalSupply},${owner},,false\nmint,mint,instance,accounts[${mintAccountIndex}] ${mintAmount_1},${owner},,false\nmint,mint,instance,accounts[${mintAccountIndex}] ${mintAmount_2},${owner},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    })   
  }
})

helper.runTests(transactionCounts, transactionFolders, testFolder, contractName);





