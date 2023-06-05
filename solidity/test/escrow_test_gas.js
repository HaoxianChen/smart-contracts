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

const valueLowerBound = 10;
const valueUpperBound = 1000;

const testFolder = path.join(__dirname, `../tracefiles/escrow`);
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

  if(transactionName == 'deposit') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let beneficiaryindex = helper.random(0, deployAccountCount);
      let ownerIndex = helper.random(0, deployAccountCount);
      let depositIndex = helper.random(0, deployAccountCount);
      let depositAmount = helper.random(valueLowerBound, valueUpperBound+1);
      let text = `deposit,constructor,,accounts[${beneficiaryindex}],${ownerIndex},,false\ndeposit,deposit,instance,accounts[${depositIndex}],${ownerIndex},${depositAmount},true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }    

  if(transactionName == 'claimRefund') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let beneficiaryindex = helper.random(0, deployAccountCount);
      let ownerIndex = helper.random(0, deployAccountCount);
      let depositIndex = helper.random(0, deployAccountCount);
      let depositAmount = helper.random(valueLowerBound, valueUpperBound+1);
      let text = `claimRefund,constructor,,accounts[${beneficiaryindex}],${ownerIndex},,false\nclaimRefund,deposit,instance,accounts[${depositIndex}],${ownerIndex},${depositAmount},false\nclaimRefund,refund,instance,,${ownerIndex},,false\nclaimRefund,claimRefund,instance,accounts[${depositIndex}],,,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }    

  if(transactionName == 'close') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let beneficiaryindex = helper.random(0, deployAccountCount);
      let ownerIndex = helper.random(0, deployAccountCount);
      let text = `close,constructor,,accounts[${beneficiaryindex}],${ownerIndex},,false\nclose,close,instance,,${ownerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }    

  if(transactionName == 'refund') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let beneficiaryindex = helper.random(0, deployAccountCount);
      let ownerIndex = helper.random(0, deployAccountCount);
      let text = `refund,constructor,,accounts[${beneficiaryindex}],${ownerIndex},,false\nrefund,refund,instance,,${ownerIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }  
 

  if(transactionName == 'withdraw') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let beneficiaryindex = helper.random(0, deployAccountCount);
      let ownerIndex = helper.random(0, deployAccountCount);
      let depositIndex = helper.random(0, deployAccountCount);
      let depositAmount = helper.random(valueLowerBound, valueUpperBound+1);
      let text = `withdraw,constructor,,accounts[${beneficiaryindex}],${ownerIndex},,false\nwithdraw,deposit,instance,accounts[${depositIndex}],${ownerIndex},${depositAmount},false\nwithdraw,close,instance,,${ownerIndex},,false\nwithdraw,withdraw,instance,,,,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }  

   


    


})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName)
