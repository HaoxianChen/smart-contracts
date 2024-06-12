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
const partitionLowerBound = 1;
const partitionUpperBound = 10;

const testFolder = path.join(__dirname, `../tracefiles/tokenPartition`);
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

  if(transactionName == 'issueByPartition') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let issueAccountIndex = helper.random(0, deployAccountCount);
      let partition = helper.random(partitionLowerBound, partitionUpperBound+1);
      let issueAmount = helper.random(lowerBound, upperBound+1);
      let text = `issueByPartition,constructor,,,${ownerIndex},,false\nissueByPartition,issueByPartition,instance,accounts[${issueAccountIndex}] ${partition} ${issueAmount},${ownerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }
  
  if(transactionName == 'redeemByPartition') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let issueAccountIndex = helper.random(0, deployAccountCount);
      let partition = helper.random(partitionLowerBound, partitionUpperBound+1);
      let issueAmount = helper.random(lowerBound, upperBound+1);
      let redeemAmount = helper.random(0, issueAmount+1);
      let text = `redeemByPartition,constructor,,,${ownerIndex},,false\nredeemByPartition,issueByPartition,instance,accounts[${issueAccountIndex}] ${partition} ${issueAmount},${ownerIndex},,false\nredeemByPartition,redeemByPartition,instance,accounts[${issueAccountIndex}] ${partition} ${redeemAmount},${ownerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }
    
  if(transactionName == 'transferByPartition') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let issueAccountIndex = helper.random(0, deployAccountCount);
      let partition = helper.random(partitionLowerBound, partitionUpperBound+1);
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
      let text = `transferByPartition,constructor,,,${ownerIndex},,false\ntransferByPartition,issueByPartition,instance,accounts[${issueAccountIndex}] ${partition} ${issueAmount},${ownerIndex},,false\ntransferByPartition,transferByPartition,instance,accounts[${issueAccountIndex}] accounts[${transferAccountIndex}] ${partition} ${issueAmount},${ownerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }
  
 

  





    


})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName)
