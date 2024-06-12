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

const testFolder = path.join(__dirname, `../tracefiles/theta`);
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
      let unlockTime = helper.random(lowerBound, upperBound+1);
      let controllerIndex = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let text = `mint,constructor,,${unlockTime},${controllerIndex},,false\nmint,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${controllerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }  

  if(transactionName == 'allowPrecirculation') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let unlockTime = helper.random(lowerBound, upperBound+1);
      let controllerIndex = helper.random(0, deployAccountCount);
      let circAccountIndex = helper.random(0, deployAccountCount);
      let text = `allowPrecirculation,constructor,,${unlockTime},${controllerIndex},,false\nallowPrecirculation,allowPrecirculation,instance,accounts[${circAccountIndex}],${controllerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }   

  if(transactionName == 'disallowPrecirculation') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let unlockTime = helper.random(lowerBound, upperBound+1);
      let controllerIndex = helper.random(0, deployAccountCount);
      let circAccountIndex = helper.random(0, deployAccountCount);
      let text = `allowPrecirculation,constructor,,${unlockTime},${controllerIndex},,false\nallowPrecirculation,allowPrecirculation,instance,accounts[${circAccountIndex}],${controllerIndex},,false\ndisallowPrecirculation,disallowPrecirculation,instance,accounts[${circAccountIndex}],${controllerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }     
  

  if(transactionName == 'changeUnlockTime') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let unlockTime = helper.random(lowerBound, upperBound+1);
      let controllerIndex = helper.random(0, deployAccountCount);
      let newUnlockTime = helper.random(1, 5);
      let text = `changeUnlockTime,constructor,,${unlockTime},${controllerIndex},,false\nchangeUnlockTime,changeUnlockTime,instance,${newUnlockTime},${controllerIndex},,true\n`;
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
      let unlockTime = helper.random(lowerBound, upperBound+1);
      let controllerIndex = helper.random(0, deployAccountCount);
      let newUnlockTime = helper.random(1, 5);
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
      let transferAmount = helper.random(0, mintAmount+1);
      let text = `transfer,constructor,,${unlockTime},${controllerIndex},,false\ntransfer,changeUnlockTime,instance,${newUnlockTime},${controllerIndex},,false\ntransfer,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${controllerIndex},,false\ntransfer,allowPrecirculation,instance,accounts[${transferAccountIndex}],${controllerIndex},,false\ntransfer,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount},${mintAccountIndex},,true\n`;
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
      let unlockTime = helper.random(lowerBound, upperBound+1);
      let controllerIndex = helper.random(0, deployAccountCount);
      let newUnlockTime = helper.random(1, 5);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != mintAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approvAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(0, mintAmount+1);
      let text = `approve,constructor,,${unlockTime},${controllerIndex},,false\napprove,changeUnlockTime,instance,${newUnlockTime},${controllerIndex},,false\napprove,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${controllerIndex},,false\napprove,allowPrecirculation,instance,accounts[${approvAccountIndex}],${controllerIndex},,false\napprove,approve,instance,accounts[${approvAccountIndex}] ${approveAmount},${mintAccountIndex},,true\n`;
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
      let unlockTime = helper.random(lowerBound, upperBound+1);
      let controllerIndex = helper.random(0, deployAccountCount);
      let newUnlockTime = helper.random(1, 5);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != mintAccountIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approvAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(0, mintAmount+1);
      let transferFromToAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferFromAmount = helper.random(0, approveAmount+1);
      let text = `transferFrom,constructor,,${unlockTime},${controllerIndex},,false\ntransferFrom,changeUnlockTime,instance,${newUnlockTime},${controllerIndex},,false\ntransferFrom,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${controllerIndex},,false\ntransferFrom,allowPrecirculation,instance,accounts[${mintAccountIndex}],${controllerIndex},,false\ntransferFrom,approve,instance,accounts[${approvAccountIndex}] ${approveAmount},${mintAccountIndex},,false\ntransferFrom,allowPrecirculation,instance,accounts[${transferFromToAccountIndex}],${controllerIndex},,false\ntransferFrom,transferFrom,instance,accounts[${mintAccountIndex}] accounts[${transferFromToAccountIndex}] ${transferFromAmount},${approvAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }     

  if(transactionName == 'changeController') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let unlockTime = helper.random(lowerBound, upperBound+1);
      let controllerIndex = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != controllerIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let newControllerAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let text = `changeController,constructor,,${unlockTime},${controllerIndex},,false\nchangeController,changeController,instance,accounts[${newControllerAccountIndex}],${controllerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  } 
 
  


})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName)
