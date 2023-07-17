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
const decimals = 18;

const testFolder = path.join(__dirname, `../tracefiles_long/matic`);
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

  if(transactionName == 'approve') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
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
      let approveAmount_1 = helper.random(1, mintAmount+1);
      let approveAmount_2 = helper.random(1, mintAmount+1);
      let text = `approve,constructor,,${name} ${symbol} ${decimals} ${totalSupply},${owner},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_1},${mintAccountIndex},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_2},${mintAccountIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }  

  if(transactionName == 'increaseAllowance') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
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
      let increaseAllowanceAmount_1 = helper.random(1, (approveAmount+1)/2); 
      let increaseAllowanceAmount_2 = helper.random(1, (approveAmount+1)/2);


      let text = `increaseAllowance,constructor,,${name} ${symbol} ${decimals} ${totalSupply},${owner},,false\nincreaseAllowance,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${mintAccountIndex},,false\nincreaseAllowance,increaseAllowance,instance,accounts[${approveAccountIndex}] ${increaseAllowanceAmount_1},${mintAccountIndex},,false\nincreaseAllowance,increaseAllowance,instance,accounts[${approveAccountIndex}] ${increaseAllowanceAmount_2},${mintAccountIndex},,true\n`;
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
      let owner = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
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
      let decreaseAllowanceAmount_1 = helper.random(1, (approveAmount+1)/2); 
      let decreaseAllowanceAmount_2 = helper.random(1, (approveAmount+1)/2);


      let text = `decreaseAllowance,constructor,,${name} ${symbol} ${decimals} ${totalSupply},${owner},,false\ndecreaseAllowance,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${mintAccountIndex},,false\ndecreaseAllowance,decreaseAllowance,instance,accounts[${approveAccountIndex}] ${decreaseAllowanceAmount_1},${mintAccountIndex},,false\ndecreaseAllowance,decreaseAllowance,instance,accounts[${approveAccountIndex}] ${decreaseAllowanceAmount_2},${mintAccountIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }
  
  if(transactionName == 'addPauser') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != owner) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let pauserIndex_1 = arrayRandom[helper.random(0, arrayRandomLen)];
      arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != owner && appIndex != pauserIndex_1) {
          arrayRandom.push(appIndex);
        }
      }
      arrayRandomLen = arrayRandom.length;
      let pauserIndex_2 = arrayRandom[helper.random(0, arrayRandomLen)];
      let text = `addPauser,constructor,,${name} ${symbol} ${decimals} ${totalSupply},${owner},,false\naddPauser,addPauser,instance,accounts[${pauserIndex_1}],${owner},,false\naddPauser,addPauser,instance,accounts[${pauserIndex_2}],${owner},,true\n`;
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
      let owner = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      let text = `pause,constructor,,${name} ${symbol} ${decimals} ${totalSupply},${owner},,false\npause,pause,instance,,${owner},,false\nunpause,unpause,instance,,${owner},,false\npause,pause,instance,,${owner},,true\n`;
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
      let owner = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != owner) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let transferAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferAmount_1 = helper.random(1, (totalSupply+1)/2);
      let transferAmount_2 = helper.random(1, (totalSupply+1)/2);
      let text = `transfer,constructor,,${name} ${symbol} ${decimals} ${totalSupply},${owner},,false\ntransfer,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount_1},${owner},,false\ntransfer,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount_2},${owner},,true\n`;
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
      let owner = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != owner) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(2, totalSupply+1);
      let transferFromAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferFromAmount_1 = helper.random(1, (approveAmount+1)/2);
      let transferFromAmount_2 = helper.random(1, (approveAmount+1)/2);
      let text = `transferFrom,constructor,,${name} ${symbol} ${decimals} ${totalSupply},${owner},,false\ntransferFrom,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${owner},,false\ntransferFrom,transferFrom,instance,accounts[${owner}] accounts[${transferFromAccountIndex}] ${transferFromAmount_1},${approveAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${owner}] accounts[${transferFromAccountIndex}] ${transferFromAmount_2},${approveAccountIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }

  // if(transactionName == 'mint') {
  //   tracefileCount = transactionCount;
  //   helper.range(tracefileCount).forEach(testFileIndex => {
  //     let fileName = `${transactionName}_${testFileIndex}.txt`;
  //     let owner = helper.random(0, deployAccountCount);
  //     let mintAccountIndex = helper.random(0, deployAccountCount);
  //     let mintAmount = helper.random(lowerBound, upperBound+1);
  //     let text = `mint,constructor,,,${owner},,false\nmint,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${owner},,true\n`;
  //     fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
  //       if (err) throw err;
  //       console.log('File is created successfully.');
  //     });
  //   }) 
  // }

  if(transactionName == 'unpause') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let text = `unpause,constructor,,${name} ${symbol} ${decimals} ${totalSupply},${owner},,false\nunpause,pause,instance,,${owner},,false\nunpause,unpause,instance,,${owner},,false\nunpause,pause,instance,,${owner},,false\nunpause,unpause,instance,,${owner},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }


  // if(transactionName == 'burn') {
  //   tracefileCount = transactionCount;
  //   helper.range(tracefileCount).forEach(testFileIndex => {
  //     let fileName = `${transactionName}_${testFileIndex}.txt`;
  //     let owner = helper.random(0, deployAccountCount);
  //     let totalSupply = helper.random(lowerBound, upperBound+1);
  //     let arrayRandom = [];
  //     for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
  //       if(appIndex != owner) {
  //         arrayRandom.push(appIndex);
  //       }
  //     }
  //     let arrayRandomLen = arrayRandom.length;
  //     let transferAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
  //     let transferAmount = helper.random(0, totalSupply+1);
  //     let burnAmount = helper.random(0, transferAmount+1);
  //     let text = `burn,constructor,,${name} ${symbol} ${decimals} ${totalSupply},${owner},,false\nburn,transfer,instance,accounts[${transferAccountIndex}] ${transferAmount},${owner},,false\nburn,burn,instance,accounts[${transferAccountIndex}] ${burnAmount},${owner},,true\n`;
  //     fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
  //       if (err) throw err;
  //       console.log('File is created successfully.');
  //     });
  //   }) 
  // }


  if(transactionName == 'renouncePauser') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let owner = helper.random(0, deployAccountCount);
      let totalSupply = helper.random(lowerBound, upperBound+1);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != owner) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let pauserIndex_1 = arrayRandom[helper.random(0, arrayRandomLen)];
      arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != owner && appIndex != pauserIndex_1) {
          arrayRandom.push(appIndex);
        }
      }
      arrayRandomLen = arrayRandom.length;
      let pauserIndex_2 = arrayRandom[helper.random(0, arrayRandomLen)];
      let text = `renouncePauser,constructor,,${name} ${symbol} ${decimals} ${totalSupply},${owner},,false\nrenouncePauser,addPauser,instance,accounts[${pauserIndex_1}],${owner},,false\nrenouncePauser,renouncePauser,instance,,${pauserIndex_1},,false\nrenouncePauser,addPauser,instance,accounts[${pauserIndex_2}],${owner},,false\nrenouncePauser,renouncePauser,instance,,${pauserIndex_2},,true\n`;
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
