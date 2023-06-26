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
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let issueAmount = helper.random(lowerBound, upperBound+1);
      let text = `issue,constructor,,${totalSupply} ${name} ${symbol} ${decimal},${ownerIndex},,false\nissue,issue,instance,${issueAmount},${ownerIndex},,true\n`;
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
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let issueAmount = helper.random(lowerBound, upperBound+1);
      let redeemAmount = helper.random(0, issueAmount+1);
      let text = `redeem,constructor,,${totalSupply} ${name} ${symbol} ${decimal},${ownerIndex},,false\nredeem,issue,instance,${issueAmount},${ownerIndex},,false\nredeem,redeem,instance,${redeemAmount},${ownerIndex},,true\n`;
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
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let transferAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferAmount = helper.random(0, totalSupply+1);
      let text = `transfer,constructor,,${totalSupply} ${name} ${symbol} ${decimal},${ownerIndex},,false\ntransfer,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount},${ownerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }


  if(transactionName == 'transferOwnership') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let newOwnerIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let text = `transferOwnership,constructor,,${totalSupply} ${name} ${symbol} ${decimal},${ownerIndex},,false\ntransferOwnership,transferOwnership,instance,accounts[${newOwnerIndex}],${ownerIndex},,true\n`;
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
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(0, totalSupply+1);
      let text = `approve,constructor,,${totalSupply} ${name} ${symbol} ${decimal},${ownerIndex},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${ownerIndex},,true\n`;
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
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(0, totalSupply+1);
      let transferFromToAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferFromAmount = helper.random(0, approveAmount+1);
      let text = `transferFrom,constructor,,${totalSupply} ${name} ${symbol} ${decimal},${ownerIndex},,false\ntransferFrom,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${ownerIndex},,false\ntransferFrom,transferFrom,instance,accounts[${ownerIndex}] accounts[${transferFromToAccountIndex}] ${transferFromAmount},${approveAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }

  if(transactionName == 'pause') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let text = `pause,constructor,,${totalSupply} ${name} ${symbol} ${decimal},${ownerIndex},,false\npause,pause,instance,,${ownerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }  

  if(transactionName == 'unpause') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let text = `unpause,constructor,,${totalSupply} ${name} ${symbol} ${decimal},${ownerIndex},,false\nunpause,pause,instance,,${ownerIndex},,false\nunpause,unpause,instance,,${ownerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }  

  if(transactionName == 'addBlackList') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let evilAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let text = `addBlackList,constructor,,${totalSupply} ${name} ${symbol} ${decimal},${ownerIndex},,false\naddBlackList,addBlackList,instance,accounts[${evilAccountIndex}],${ownerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }
  if(transactionName == 'removeBlackList') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let evilAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let text = `removeBlackList,constructor,,${totalSupply} ${name} ${symbol} ${decimal},${ownerIndex},,false\nremoveBlackList,addBlackList,instance,accounts[${evilAccountIndex}],${ownerIndex},,false\nremoveBlackList,removeBlackList,instance,accounts[${evilAccountIndex}],${ownerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }
  if(transactionName == 'destroyBlackFunds') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let evilAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferAmount = helper.random(0, totalSupply+1);
      let text = `destroyBlackFunds,constructor,,${totalSupply} ${name} ${symbol} ${decimal},${ownerIndex},,false\ndestroyBlackFunds,transfer,instance,accounts[${evilAccountIndex}] ${transferAmount},${ownerIndex},,false\ndestroyBlackFunds,addBlackList,instance,accounts[${evilAccountIndex}],${ownerIndex},,false\ndestroyBlackFunds,destroyBlackFunds,instance,accounts[${evilAccountIndex}],${ownerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }  

  if(transactionName == 'setParams') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let newBasisPoints = helper.random(0, 20);
      let newMaxFee = helper.random(0, 50);
      let text = `setParams,constructor,,${totalSupply} ${name} ${symbol} ${decimal},${ownerIndex},,false\nsetParams,setParams,instance,${newBasisPoints} ${newMaxFee},${ownerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  } 

 


  


})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName)
