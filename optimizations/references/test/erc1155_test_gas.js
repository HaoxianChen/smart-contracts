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

const dataLowerBound = 0;
const dataUpperBound = 9*(10**15);
const mintLowerBound = 10;
const mintUpperBound = 1000;
const mintIdUpperBound = 500;
const mintIdLowerBound = 1;
const uri = 'a_fake_uri';

const testFolder = path.join(__dirname, `../tracefiles/erc1155`);
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
      let mintMsgSender = helper.random(0, deployAccountCount);
      let burnMsgSender = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintLowerBound, mintUpperBound+1);
      let mintId = helper.random(mintIdLowerBound, mintIdUpperBound+2);
      let mintData = helper.random(dataLowerBound, dataUpperBound);
      let burnAmount = helper.random(0, mintAmount+1);
      let text = `burn,constructor,,${uri},,,false\nburn,mint,instance,accounts[${mintAccountIndex}] ${mintId} ${mintAmount} ${mintData},${mintMsgSender},,false\nburn,burn,instance,accounts[${mintAccountIndex}] ${mintId} ${burnAmount},${burnMsgSender},,true\n`;
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
      let mintMsgSender = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintLowerBound, mintUpperBound+1);
      let mintId = helper.random(mintIdLowerBound, mintIdUpperBound+2);
      let mintData = helper.random(dataLowerBound, dataUpperBound);
      let text = `mint,constructor,,${uri},,,false\nmint,mint,instance,accounts[${mintAccountIndex}] ${mintId} ${mintAmount} ${mintData},${mintMsgSender},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }

  if(transactionName == 'safeTransferFrom') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let mintMsgSender = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintLowerBound, mintUpperBound+1);
      let mintId = helper.random(mintIdLowerBound, mintIdUpperBound+2);
      let mintData = helper.random(dataLowerBound, dataUpperBound);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != mintAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let setApprovalAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let safeTransferFromToAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let safeTransferFromAmount= helper.random(0, mintAmount+1);
      let text = `safeTransferFrom,constructor,,${uri},,,false\nsafeTransferFrom,mint,instance,accounts[${mintAccountIndex}] ${mintId} ${mintAmount} ${mintData},${mintMsgSender},,false\nsafeTransferFrom,setApprovalForAll,instance,accounts[${setApprovalAccountIndex}] true,${mintAccountIndex},,false\nsafeTransferFrom,safeTransferFrom,instance,accounts[${mintAccountIndex}] accounts[${safeTransferFromToAccountIndex}] ${mintId} ${safeTransferFromAmount} ${mintData},${setApprovalAccountIndex},,true\n`;
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
      let mintMsgSender = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintLowerBound, mintUpperBound+1);
      let mintId = helper.random(mintIdLowerBound, mintIdUpperBound+2);
      let mintData = helper.random(dataLowerBound, dataUpperBound);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != mintAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let setApprovalAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let random_bin = Math.random();
      let trueOrFalse;
      if(random_bin < 0.5) {
        trueOrFalse = 'true'
      } else {
        trueOrFalse = 'false';
      }

      let text = `setApprovalForAll,constructor,,${uri},,,false\nsetApprovalForAll,mint,instance,accounts[${mintAccountIndex}] ${mintId} ${mintAmount} ${mintData},${mintMsgSender},,false\nsetApprovalForAll,setApprovalForAll,instance,accounts[${setApprovalAccountIndex}] ${trueOrFalse},${mintAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }  



    


})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName)
