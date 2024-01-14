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
const mintValLowerBound = 10;
const mintValUpperBound = 1000;
const increaseAllowanceUpperBound = 1000;

const testFolder = path.join(__dirname, `../tracefiles_long/controllable`);
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
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let controller =  helper.random(0, deployAccountCount);
      let owner = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintValLowerBound, mintValUpperBound+1);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != mintAccountIndex) {
          arrayRandom.push(index);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount_1 = helper.random(1, (mintAmount+1)/2);
      let approveAmount_2 = approveAmount_1 + helper.random(0, (mintAmount+1)/2);
      let text = `approve,constructor,,accounts[${controller}],${owner},,false\napprove,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${owner},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_1},${mintAccountIndex},,false\napprove,approve,instance,accounts[${approveAccountIndex}] ${approveAmount_2},${mintAccountIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }

  if(transactionName == 'burn') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let controller =  helper.random(0, deployAccountCount);
      let owner = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintValLowerBound, mintValUpperBound+1);
      let burnAmount_1 = helper.random(1, (mintAmount+1)/2);
      let burnAmount_2 = helper.random(1, (mintAmount+1)/2);
      let text = `burn,constructor,,accounts[${controller}],${owner},,false\nburn,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${owner},,false\nburn,burn,instance,accounts[${mintAccountIndex}] ${burnAmount_1},${owner},,false\nburn,burn,instance,accounts[${mintAccountIndex}] ${burnAmount_2},${owner},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    })  
  }  

  if(transactionName == 'controllerRedeem') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let controller =  helper.random(0, deployAccountCount);
      let owner = helper.random(0, deployAccountCount);
      let controllerAccountIndex = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintValLowerBound, mintValUpperBound+1);
      let controllerRedeemAmount_1 = helper.random(1, (mintAmount+1)/2);
      let controllerRedeemAmount_2 = helper.random(1, (mintAmount+1)/2);
      let text = `controllerRedeem,constructor,,accounts[${controller}],${owner},,false\ncontrollerRedeem,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${owner},,false\ncontrollerRedeem,controllerRedeem,instance,accounts[${mintAccountIndex}] ${controllerRedeemAmount_1},${controller},,false\ncontrollerRedeem,controllerRedeem,instance,accounts[${mintAccountIndex}] ${controllerRedeemAmount_2},${controller},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }  


  if(transactionName == 'controllerTransfer') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let controller =  helper.random(0, deployAccountCount);
      let owner = helper.random(0, deployAccountCount);
      let controllerAccountIndex = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintValLowerBound, mintValUpperBound+1);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != mintAccountIndex) {
          arrayRandom.push(index);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let controllerTransferToAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let controllerTransferAmount_1 = helper.random(1, (mintAmount+1)/2);
      let controllerTransferAmount_2 = helper.random(1, (mintAmount+1)/2);
      let text = `controllerTransfer,constructor,,accounts[${controller}],${owner},,false\ncontrollerTransfer,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${owner},,false\ncontrollerTransfer,controllerTransfer,instance,accounts[${mintAccountIndex}] accounts[${controllerTransferToAccountIndex}] ${controllerTransferAmount_1},${controller},,false\ncontrollerTransfer,controllerTransfer,instance,accounts[${mintAccountIndex}] accounts[${controllerTransferToAccountIndex}] ${controllerTransferAmount_2},${controller},,true\n`;
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
      let controller =  helper.random(0, deployAccountCount);
      let owner = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintValLowerBound, mintValUpperBound+1);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != mintAccountIndex) {
          arrayRandom.push(index);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(2, mintAmount+1);
      let decreaseAllowanceAmount_1 = helper.random(1, (approveAmount+1)/2);
      let decreaseAllowanceAmount_2 = helper.random(1, (approveAmount+1)/2);
      let text = `decreaseAllowance,constructor,,accounts[${controller}],${owner},,false\ndecreaseAllowance,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},,,false\ndecreaseAllowance,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${mintAccountIndex},,false\ndecreaseAllowance,decreaseAllowance,instance,accounts[${approveAccountIndex}] ${decreaseAllowanceAmount_1},${mintAccountIndex},,false\ndecreaseAllowance,decreaseAllowance,instance,accounts[${approveAccountIndex}] ${decreaseAllowanceAmount_2},${mintAccountIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }  

  if(transactionName == 'increaseAllowance') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let controller =  helper.random(0, deployAccountCount);
      let owner = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintValLowerBound, mintValUpperBound+1);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != mintAccountIndex) {
          arrayRandom.push(index);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(0, mintAmount+1);
      let increaseAllowanceAmount_1 = helper.random(1, increaseAllowanceUpperBound+1);
      let increaseAllowanceAmount_2 = helper.random(1, increaseAllowanceUpperBound+1);
      let text = `increaseAllowance,constructor,,accounts[${controller}],${owner},,false\nincreaseAllowance,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},,,false\nincreaseAllowance,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${mintAccountIndex},,false\nincreaseAllowance,increaseAllowance,instance,accounts[${approveAccountIndex}] ${increaseAllowanceAmount_1},${mintAccountIndex},,false\nincreaseAllowance,increaseAllowance,instance,accounts[${approveAccountIndex}] ${increaseAllowanceAmount_2},${mintAccountIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }


  if(transactionName == 'mint') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let controller =  helper.random(0, deployAccountCount);
      let owner = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount_1 = helper.random(mintValLowerBound, mintValUpperBound+1);
      let mintAmount_2 = helper.random(mintValLowerBound, mintValUpperBound+1);
      let text = `mint,constructor,,accounts[${controller}],${owner},,false\nmint,mint,instance,accounts[${mintAccountIndex}] ${mintAmount_1},${owner},,false\nmint,mint,instance,accounts[${mintAccountIndex}] ${mintAmount_2},${owner},,true\n`;
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
      let controller =  helper.random(0, deployAccountCount);
      let owner = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintValLowerBound, mintValUpperBound+1);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != mintAccountIndex) {
          arrayRandom.push(index);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let transferToAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferAmount_1 = helper.random(1, (mintAmount+1)/2);
      let transferAmount_2 = helper.random(1, (mintAmount+1)/2);
      let text = `transfer,constructor,,accounts[${controller}],${owner},,false\ntransfer,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${owner},,false\ntransfer,transfer,instance,accounts[${transferToAccountIndex}] ${transferAmount_1},${mintAccountIndex},,false\ntransfer,transfer,instance,accounts[${transferToAccountIndex}] ${transferAmount_2},${mintAccountIndex},,true\n`;
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
      let controller =  helper.random(0, deployAccountCount);
      let owner = helper.random(0, deployAccountCount);
      let mintAccountIndex = helper.random(0, deployAccountCount);
      let mintAmount = helper.random(mintValLowerBound, mintValUpperBound+1);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != mintAccountIndex) {
          arrayRandom.push(index);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let approveAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let approveAmount = helper.random(2, mintAmount+1);
      let transferFromToAccountIndex = arrayRandom[helper.random(0, arrayRandomLen)];
      let transferFromAmount_1 = helper.random(1, (approveAmount+1)/2);
      let transferFromAmount_2 = helper.random(1, (approveAmount+1)/2);
      let text = `transferFrom,constructor,,accounts[${controller}],${owner},,false\ntransferFrom,mint,instance,accounts[${mintAccountIndex}] ${mintAmount},${owner},,false\ntransferFrom,approve,instance,accounts[${approveAccountIndex}] ${approveAmount},${mintAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${mintAccountIndex}] accounts[${transferFromToAccountIndex}] ${transferFromAmount_1},${approveAccountIndex},,false\ntransferFrom,transferFrom,instance,accounts[${mintAccountIndex}] accounts[${transferFromToAccountIndex}] ${transferFromAmount_2},${approveAccountIndex},,true\n`;
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
