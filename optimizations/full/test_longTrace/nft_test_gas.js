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
const tokenIdLowerBound = 1;
const tokenIdUpperBound = 10;

const testFolder = path.join(__dirname, `../tracefiles/nft`);
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
  var tokenId = 0;


  if(transactionName == 'mint') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      // let tokenId = helper.random(tokenIdLowerBound, tokenIdUpperBound+1);
      tokenId++;
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount_1 = helper.random(lowerBound, upperBound+1);
      let mintAmount_2 = helper.random(lowerBound, upperBound+1);
      let text = `mint,constructor,,,${owner},,false\nmint,mint,instance,${tokenId} accounts[${mintAccountIndex}],${owner},,false\nmint,mint,instance,${tokenId+1} accounts[${mintAccountIndex}],${owner},,true\n`;
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
      let owner = helper.random(0, deployAccountCount);
      // let tokenId = helper.random(tokenIdLowerBound, tokenIdUpperBound+1);
      tokenId++;
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let text = `burn,constructor,,,${owner},,false\nburn,mint,instance,${tokenId} accounts[${mintAccountIndex}],${owner},,false\nburn,burn,instance,${tokenId},${owner},,false\nburn,mint,instance,${tokenId+1} accounts[${mintAccountIndex}],${owner},,false\nburn,burn,instance,${tokenId+1},${owner},,true\n`;
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
      // let tokenId = helper.random(tokenIdLowerBound, tokenIdUpperBound+1);
      tokenId++;
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
      let text = `transfer,constructor,,,${owner},,false\ntransfer,mint,instance,${tokenId} accounts[${mintAccountIndex}],${owner},,false\ntransfer,transfer,instance,accounts[${transferAccountIndex}] ${tokenId},${mintAccountIndex},,false\ntransfer,transfer,instance,accounts[${transferAccountIndex}] ${tokenId+1},${mintAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }

  if(transactionName == 'setApprovalForAll') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      // let tokenId = helper.random(tokenIdLowerBound, tokenIdUpperBound+1);
      tokenId++;
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let approveAccountIndex = helper.random(0, deployAccountCount);
      let trueOrFalse = Math.random()<0.5?0:1;
      let text = `setApprovalForAll,constructor,,,${owner},,false\nsetApprovalForAll,mint,instance,${tokenId} accounts[${mintAccountIndex}],${owner},,false\nsetApprovalForAll,setApprovalForAll,instance,accounts[${approveAccountIndex}] ${trueOrFalse},,,false\nsetApprovalForAll,setApprovalForAll,instance,accounts[${approveAccountIndex}] ${1-trueOrFalse},,,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }
    
  if(transactionName == 'setApproval') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      tokenId++;
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let approveAccountIndex = helper.random(0, deployAccountCount);
      let trueOrFalse = Math.random()<0.5?0:1;
      let text = `setApproval,constructor,,,${owner},,false\nsetApproval,mint,instance,${tokenId} accounts[${mintAccountIndex}],${owner},,false\nsetApproval,setApproval,instance,${tokenId} accounts[${approveAccountIndex}] ${trueOrFalse},${mintAccountIndex},,false\nsetApproval,setApproval,instance,${tokenId} accounts[${approveAccountIndex}] ${1-trueOrFalse},${mintAccountIndex},,true\n`;
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
      tokenId++;
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let trueOrFalse = 1;
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != mintAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let transferFromAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let text = `transferFrom,constructor,,,${owner},,false\ntransferFrom,mint,instance,${tokenId} accounts[${mintAccountIndex}],${owner},,false\ntransferFrom,setApprovalForAll,instance,accounts[${approveAccountIndex}] ${trueOrFalse},,,false\ntransferFrom,transferFrom,instance,accounts[${mintAccountIndex}] accounts[${transferFromAccountIndex}] ${tokenId},${approveAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }

 
})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName)
