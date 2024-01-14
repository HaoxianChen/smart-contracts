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

const durationUpperBound = 1000;
const investAmountLowerBound = 10;
const investAmountUpperBound = 100;

const testFolder = path.join(__dirname, `../tracefiles_long/crowdsale`);
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

  if(transactionName == 'close') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let initialAmount = helper.random(10, 1000+1);
      let beneficiary = helper.random(0, deployAccountCount);
      let owner = helper.random(0, deployAccountCount);
      let duration = helper.random(31, durationUpperBound+1);
      let text = `close,constructor,,${initialAmount} accounts[${beneficiary}],${owner},,false\nclose,increase,time,time.duration.days[${duration}],,,false\nclose,close,instance,,${owner},,false\nclose,close,instance,,${owner},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }    


  if(transactionName == 'invest') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let initialAmount = helper.random(10, 1000+1);
      let beneficiary = helper.random(0, deployAccountCount);
      let owner = helper.random(0, deployAccountCount);
      let investAccountIndex = helper.random(0, deployAccountCount);
      let investAmount_1 = helper.random(investAmountLowerBound, investAmountUpperBound+1);
      let investAmount_2 = investAmount_1 + helper.random(0, investAmountUpperBound+1);
      let text = `invest,constructor,,${initialAmount} accounts[${beneficiary}],${owner},,false\ninvest,invest,instance,,${investAccountIndex},web3.utils.toWei(${investAmount_1} ether),true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }  

  if(transactionName == 'refund') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let initialAmount = helper.random(10, 1000+1);
      let beneficiary = helper.random(0, deployAccountCount);
      let owner = helper.random(0, deployAccountCount);
      let investAccountIndex = helper.random(0, deployAccountCount);
      let investAmount = helper.random(1, initialAmount);
      let text = `refund,constructor,,${initialAmount} accounts[${beneficiary}],${owner},,false\nrefund,invest,instance,,${investAccountIndex},web3.utils.toWei(${investAmount} ether),false\nrefund,close,instance,,${owner},,false\nrefund,refund,instance,,${investAccountIndex},,false\nrefund,refund,instance,,${investAccountIndex},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    }) 
  }  

  if(transactionName == 'withdraw') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let initialAmount = helper.random(10, 1000+1);
      let beneficiary = helper.random(0, deployAccountCount);
      let owner = helper.random(0, deployAccountCount);
      let investAccountIndex = helper.random(0, deployAccountCount);
      let investAmount = helper.random(investAmountLowerBound, investAmountUpperBound+1);
      let text = `withdraw,constructor,,${initialAmount} accounts[${beneficiary}],${owner},,false\nwithdraw,invest,instance,,${investAccountIndex},web3.utils.toWei(${investAmount} ether),false\nwithdraw,withdraw,instance,,${beneficiary},,false\nwithdraw,withdraw,instance,,${beneficiary},,true\n`;
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
