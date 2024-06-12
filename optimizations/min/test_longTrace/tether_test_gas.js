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

const testFolder = path.join(__dirname, `../tracefiles_long/tether`);
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
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let ownerIndex = helper.random(0, deployAccountCount);
      let issueAccountIndex = helper.random(0, deployAccountCount);
      let issueAmount_1 = helper.random(lowerBound, upperBound+1);
      let issueAmount_2 = helper.random(lowerBound, upperBound+1);
      let text = `issue,constructor,,${totalSupply},${ownerIndex},,false\nissue,issue,instance,${issueAmount_1},${ownerIndex},,false\nissue,issue,instance,${issueAmount_2},${ownerIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }
  if(transactionName == 'redeem') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let ownerIndex = helper.random(0, deployAccountCount);
      let issueAccountIndex = helper.random(0, deployAccountCount);
      let issueAmount = helper.random(lowerBound, upperBound+1);
      let redeemAmount_1 = helper.random(1, (issueAmount+1)/2);
      let redeemAmount_2 = helper.random(1, (issueAmount+1)/2);
      let text = `redeem,constructor,,${totalSupply},${ownerIndex},,false\nredeem,issue,instance,${issueAmount},${ownerIndex},,false\nredeem,redeem,instance,${redeemAmount_1},${ownerIndex},,false\nredeem,redeem,instance,${redeemAmount_2},${ownerIndex},,true\n`;
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
      let approveAmount_1 = helper.random(1, (issueAmount+1)/2);
      let approveAmount_2 = approveAmount_1 + helper.random(0, (issueAmount - approveAmount_1 +1)/2);
      let text = `approve,constructor,,${totalSupply},${ownerIndex},,false\napprove,issue,instance,${issueAmount},${ownerIndex},,false\napprove,transfer,instance,accounts[${issueAccountIndex}] ${issueAmount},${ownerIndex},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_1},${issueAccountIndex},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_2},${issueAccountIndex},,true\n`;
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
      let transferAmount_1 = helper.random(1, (issueAmount+1)/2);
      let transferAmount_2 = helper.random(1, (issueAmount+1)/2);
      let text = `transfer,constructor,,${totalSupply},${ownerIndex},,false\ntransfer,issue,instance,${issueAmount},${ownerIndex},,false\ntransfer,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount_1},${ownerIndex},,false\ntransfer,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount_2},${ownerIndex},,true\n`;
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
      let approveAmount = helper.random(2, issueAmount+1);
      let transferFromAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferFromAmount_1 = helper.random(1, (approveAmount+1)/2);
      let transferFromAmount_2 = helper.random(1, (approveAmount+1)/2);
      let text = `transferFrom,constructor,,${totalSupply},${ownerIndex},,false\ntransferFrom,issue,instance,${issueAmount},${ownerIndex},,false\ntransferFrom,transfer,instance,accounts[${issueAccountIndex}] ${issueAmount},${ownerIndex},,false\ntransferFrom,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${issueAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${issueAccountIndex}] accounts[${transferFromAccountIndex}] ${transferFromAmount_1},${approveAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${issueAccountIndex}] accounts[${transferFromAccountIndex}] ${transferFromAmount_2},${approveAccountIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }


  if(transactionName == 'pause') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let text = `pause,constructor,,${totalSupply},${ownerIndex},,false\npause,pause,instance,,${ownerIndex},,false\npause,unpause,instance,,${ownerIndex},,false\npause,pause,instance,,${ownerIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }  

  if(transactionName == 'unpause') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let text = `unpause,constructor,,${totalSupply},${ownerIndex},,false\nunpause,pause,instance,,${ownerIndex},,false\nunpause,unpause,instance,,${ownerIndex},,false\nunpause,pause,instance,,${ownerIndex},,false\nunpause,unpause,instance,,${ownerIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
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
      let evilAccountIndex_1 = arrayRandom[helper.random(0, arrayRandomLen)];
      arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex && appIndex != evilAccountIndex_1) {
          arrayRandom.push(appIndex);
        }
      }
      arrayRandomLen = arrayRandom.length;      
      let evilAccountIndex_2 = arrayRandom[helper.random(0, arrayRandomLen)];
      let text = `addBlackList,constructor,,${totalSupply},${ownerIndex},,false\naddBlackList,addBlackList,instance,accounts[${evilAccountIndex_1}],${ownerIndex},,false\naddBlackList,addBlackList,instance,accounts[${evilAccountIndex_2}],${ownerIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
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
      let evilAccountIndex_1 = arrayRandom[helper.random(0, arrayRandomLen)];
      arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex && appIndex != evilAccountIndex_1) {
          arrayRandom.push(appIndex);
        }
      }
      arrayRandomLen = arrayRandom.length;
      let evilAccountIndex_2 = arrayRandom[helper.random(0, arrayRandomLen)];
      let text = `removeBlackList,constructor,,${totalSupply},${ownerIndex},,false\nremoveBlackList,addBlackList,instance,accounts[${evilAccountIndex_1}],${ownerIndex},,false\nremoveBlackList,removeBlackList,instance,accounts[${evilAccountIndex_1}],${ownerIndex},,false\nemoveBlackList,addBlackList,instance,accounts[${evilAccountIndex_2}],${ownerIndex},,false\nremoveBlackList,removeBlackList,instance,accounts[${evilAccountIndex_2}],${ownerIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
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
      let evilAccountIndex_1 = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferAmount_1 = helper.random(1, (totalSupply+1)/2);
      arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex && appIndex != evilAccountIndex_1) {
          arrayRandom.push(appIndex);
        }
      }
      arrayRandomLen = arrayRandom.length;
      let evilAccountIndex_2 = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferAmount_2 = helper.random(1, (totalSupply+1)/2);
      let text = `destroyBlackFunds,constructor,,${totalSupply},${ownerIndex},,false\ndestroyBlackFunds,transfer,instance,accounts[${evilAccountIndex_1}] ${transferAmount_1},${ownerIndex},,false\ndestroyBlackFunds,addBlackList,instance,accounts[${evilAccountIndex_1}],${ownerIndex},,false\ndestroyBlackFunds,destroyBlackFunds,instance,accounts[${evilAccountIndex_1}],${ownerIndex},,false\ndestroyBlackFunds,transfer,instance,accounts[${evilAccountIndex_2}] ${transferAmount_2},${ownerIndex},,false\ndestroyBlackFunds,addBlackList,instance,accounts[${evilAccountIndex_2}],${ownerIndex},,false\ndestroyBlackFunds,destroyBlackFunds,instance,accounts[${evilAccountIndex_2}],${ownerIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }  

  if(transactionName == 'setParams') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let newBasisPoints_1 = helper.random(1, 20);
      let newMaxFee_1 = helper.random(1, 50);     
      let newBasisPoints_2 = helper.random(1, 20);
      let newMaxFee_2 = helper.random(1, 50);
      let text = `setParams,constructor,,${totalSupply},${ownerIndex},,false\nsetParams,setParams,instance,${newBasisPoints_1} ${newMaxFee_1},${ownerIndex},,false\nsetParams,setParams,instance,${newBasisPoints_2} ${newMaxFee_2},${ownerIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
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
      let newOwnerIndex_1 = arrayRandom[helper.random(0, arrayRandomLen)];
      arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex && appIndex !=newOwnerIndex_1 ) {
          arrayRandom.push(appIndex);
        }
      }
      arrayRandomLen = arrayRandom.length;
      let newOwnerIndex_2 = arrayRandom[helper.random(0, arrayRandomLen)];
      let text = `transferOwnership,constructor,,${totalSupply},${ownerIndex},,false\ntransferOwnership,transferOwnership,instance,accounts[${newOwnerIndex_1}],${ownerIndex},,false\ntransferOwnership,transferOwnership,instance,accounts[${newOwnerIndex_2}],${newOwnerIndex_1},,true\n`;
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
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version)
