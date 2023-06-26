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

const testFolder = path.join(__dirname, `../tracefiles/tether`);
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

  if(transactionName == 'issue') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let issueAccountIndex = helper.random(0, deployAccountCount);
      let issueAmount = helper.random(lowerBound, upperBound+1);
      let text = `issue,constructor,,,${ownerIndex},,false\nissue,issue,instance,accounts[${issueAccountIndex}] ${issueAmount},${ownerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }
  if(transactionName == 'redeem') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let issueAccountIndex = helper.random(0, deployAccountCount);
      let issueAmount = helper.random(lowerBound, upperBound+1);
      let redeemAmount = helper.random(0, issueAmount+1);
      let text = `redeem,constructor,,,${ownerIndex},,false\nredeem,issue,instance,accounts[${issueAccountIndex}] ${issueAmount},${ownerIndex},,false\nredeem,redeem,instance,accounts[${issueAccountIndex}] ${redeemAmount},${ownerIndex},,true\n`;
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
      let ownerIndex = helper.random(0, deployAccountCount);
      let issueAccountIndex = helper.random(0, deployAccountCount);
      let issueAmount = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != issueAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(0, issueAmount+1);
      let text = `approve,constructor,,,${ownerIndex},,false\napprove,issue,instance,accounts[${issueAccountIndex}] ${issueAmount},${ownerIndex},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${issueAccountIndex},,true\n`;
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
      let ownerIndex = helper.random(0, deployAccountCount);
      let issueAccountIndex = helper.random(0, deployAccountCount);
      let issueAmount = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != issueAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let transferAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferAmount = helper.random(0, issueAmount+1);
      let text = `transfer,constructor,,,${ownerIndex},,false\ntransfer,issue,instance,accounts[${issueAccountIndex}] ${issueAmount},${ownerIndex},,false\ntransfer,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount},${issueAccountIndex},,true\n`;
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
      let ownerIndex = helper.random(0, deployAccountCount);
      let issueAccountIndex = helper.random(0, deployAccountCount);
      let issueAmount = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != issueAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(0, issueAmount+1);
      let transferFromAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferFromAmount = helper.random(0, approveAmount+1);
      let text = `transferFrom,constructor,,,${ownerIndex},,false\ntransferFrom,issue,instance,accounts[${issueAccountIndex}] ${issueAmount},${ownerIndex},,false\ntransferFrom,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${issueAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${issueAccountIndex}] accounts[${transferFromAccountIndex}] ${transferFromAmount},${approveAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }






    


})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName)
