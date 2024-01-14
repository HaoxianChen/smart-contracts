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

const testFolder = path.join(__dirname, `../tracefiles_long/wbtc`);
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
      let ownerIndex = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount_1 = helper.random(lowerBound, upperBound+1);
      let mintAmount_2 = helper.random(lowerBound, upperBound+1);
      let text = `mint,constructor,,,${ownerIndex},,false\nmint,mint,instance,accounts[${mintAccountIndex}] ${mintAmount_1},${ownerIndex},,false\nmint,mint,instance,accounts[${mintAccountIndex}] ${mintAmount_2},${ownerIndex},,true\n`;
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
      let ownerIndex = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(lowerBound, upperBound+1);
      let burnAmount_1 = helper.random(1, (mintAmount+1)/2);
      let burnAmount_2 = helper.random(1, (mintAmount+1)/2);
      let text = `burn,constructor,,,${ownerIndex},,false\nburn,mint,instance,accounts[${ownerIndex}] ${mintAmount},${ownerIndex},,false\nburn,burn,instance,${burnAmount_1},${ownerIndex},,false\nburn,burn,instance,${burnAmount_2},${ownerIndex},,true\n`;
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
      let approveAmount_1 = helper.random(1, (mintAmount+1)/2);
      let approveAmount_2 = approveAmount_1+ helper.random(0, (mintAmount+1)/2);
      let text = `approve,constructor,,,${ownerIndex},,false\napprove,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${ownerIndex},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_1},${mintAccountIndex},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_2},${mintAccountIndex},,true\n`;
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
      let transferAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferAmount_1 = helper.random(1, (mintAmount+1)/2);
      let transferAmount_2 = helper.random(1, (mintAmount+1)/2);
      let text = `transfer,constructor,,,${ownerIndex},,false\ntransfer,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${ownerIndex},,false\ntransfer,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount_1},${mintAccountIndex},,false\ntransfer,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount_2},${mintAccountIndex},,true\n`;
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
      let approveAmount = helper.random(2, mintAmount+1);
      let transferFromAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferFromAmount_1 = helper.random(1, (approveAmount+1)/2);
      let transferFromAmount_2 = helper.random(1, (approveAmount+1)/2);
      let text = `transferFrom,constructor,,,${ownerIndex},,false\ntransferFrom,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${ownerIndex},,false\ntransferFrom,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${mintAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${mintAccountIndex}] accounts[${transferFromAccountIndex}] ${transferFromAmount_1},${approveAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${mintAccountIndex}] accounts[${transferFromAccountIndex}] ${transferFromAmount_2},${approveAccountIndex},,true\n`;
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
      let transferFromAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferFromAmount = helper.random(0, approveAmount+1);
      let text = `pause,constructor,,,${ownerIndex},,false\npause,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${ownerIndex},,false\npause,pause,instance,,${ownerIndex},,false\npause,unpause,instance,,${ownerIndex},,false\npause,pause,instance,,${ownerIndex},,true\n`;
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
      let transferFromAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferFromAmount = helper.random(0, approveAmount+1);
      let text = `unpause,constructor,,,${ownerIndex},,false\nunpause,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${ownerIndex},,false\nunpause,pause,instance,,${ownerIndex},,false\nunpause,unpause,instance,,${ownerIndex},,false\nunpause,pause,instance,,${ownerIndex},,false\nunpause,unpause,instance,,${ownerIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }
  if(transactionName == 'transferOwner') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let transferOwnerAccountIndex_1 = arrayRandom[helper.random(0, arrayRandomLen)];
      arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex && appIndex != transferOwnerAccountIndex_1) {
          arrayRandom.push(appIndex);
        }
      }
      arrayRandomLen = arrayRandom.length;
      let transferOwnerAccountIndex_2 = arrayRandom[helper.random(0, arrayRandomLen)];
      let text = `transferOwner,constructor,,,${ownerIndex},,false\ntransferOwner,transferOwner,instance,accounts[${transferOwnerAccountIndex_1}],${ownerIndex},,false\ntransferOwner,claimOwnership,instance,,${transferOwnerAccountIndex_1},,false\ntransferOwner,transferOwner,instance,accounts[${transferOwnerAccountIndex_2}],${transferOwnerAccountIndex_1},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }
 
  if(transactionName == 'claimOwnership') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let transferOwnerAccountIndex_1 = arrayRandom[helper.random(0, arrayRandomLen)];
      arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex && appIndex != transferOwnerAccountIndex_1) {
          arrayRandom.push(appIndex);
        }
      }
      arrayRandomLen = arrayRandom.length;
      let transferOwnerAccountIndex_2 = arrayRandom[helper.random(0, arrayRandomLen)];
      let text = `claimOwnership,constructor,,,${ownerIndex},,false\nclaimOwnership,transferOwnership,instance,accounts[${transferOwnerAccountIndex_1}],${ownerIndex},,false\nclaimOwnership,claimOwnership,instance,,${transferOwnerAccountIndex_1},,false\nclaimOwnership,transferOwnership,instance,accounts[${transferOwnerAccountIndex_2}],${transferOwnerAccountIndex_1},,false\nclaimOwnership,claimOwnership,instance,,${transferOwnerAccountIndex_2},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }

  if(transactionName == 'reclaimToken') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
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
      let transferAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferAmount_1 = helper.random(1, (mintAmount+1)/2);
      let transferAmount_2 = helper.random(1, (mintAmount+1)/2);
      let text = `reclaimToken,constructor,,,${ownerIndex},,false\nreclaimToken,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${ownerIndex},,false\nreclaimToken,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount_1},${mintAccountIndex},,false\nreclaimToken,reclaimToken,instance,,${ownerIndex},,false\nreclaimToken,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount_2},${mintAccountIndex},,false\nreclaimToken,reclaimToken,instance,,${ownerIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  } 


  if(transactionName == 'increaseApproval') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
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
      let increaseAmount_1 = helper.random(1, 10);
      let increaseAmount_2 = helper.random(10, 20);
      let text = `increaseApproval,constructor,,,${ownerIndex},,false\nincreaseApproval,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${ownerIndex},,false\nincreaseApproval,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${mintAccountIndex},,false\nincreaseApproval,increaseApproval,instance,accounts[${approveAccountIndex}] ${increaseAmount_1},${mintAccountIndex},,false\nincreaseApproval,increaseApproval,instance,accounts[${approveAccountIndex}] ${increaseAmount_2},${mintAccountIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }
  if(transactionName == 'decreaseApproval') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
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
      let decreaseAmount_1 = helper.random(1, (approveAmount+1)/2);
      let decreaseAmount_2 = helper.random(1, (approveAmount+1)/2);
      let text = `decreaseApproval,constructor,,,${ownerIndex},,false\ndecreaseApproval,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${ownerIndex},,false\ndecreaseApproval,increaseApproval,instance,accounts[${approveAccountIndex}] ${approveAmount},${mintAccountIndex},,false\ndecreaseApproval,decreaseApproval,instance,accounts[${approveAccountIndex}] ${decreaseAmount_1},${mintAccountIndex},,false\ndecreaseApproval,decreaseApproval,instance,accounts[${approveAccountIndex}] ${decreaseAmount_2},${mintAccountIndex},,true\n`;
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
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let transferOwnerAccountIndex_1 = arrayRandom[helper.random(0, arrayRandomLen)];
      arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != ownerIndex && appIndex != transferOwnerAccountIndex_1) {
          arrayRandom.push(appIndex);
        }
      }
      arrayRandomLen = arrayRandom.length;
      let transferOwnerAccountIndex_2 = arrayRandom[helper.random(0, arrayRandomLen)];
      let text = `transferOwnership,constructor,,,${ownerIndex},,false\ntransferOwnership,transferOwnership,instance,accounts[${transferOwnerAccountIndex_1}],${ownerIndex},,false\ntransferOwnership,claimOwnership,instance,,${transferOwnerAccountIndex_1},,false\ntransferOwnership,transferOwnership,instance,accounts[${transferOwnerAccountIndex_2}],${transferOwnerAccountIndex_1},,true\n`;
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
