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
const autionTimeLowerBound = 10;
const autionTimeUpperBound = 100;
const BiddingValLowerBound = 10;
const BiddingValUpperBound = 1000;

const testFolder = path.join(__dirname, `../tracefiles/auction`);
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

  if(transactionName == 'bid') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let biddingTime = helper.random(autionTimeLowerBound, autionTimeUpperBound+1);
      let beneficiary = helper.random(0, deployAccountCount);
      let bidFromAccountIndex = helper.random(0, deployAccountCount);
      let biddingVal = helper.random(BiddingValLowerBound, BiddingValUpperBound+1);    
      let text = `bid,constructor,,accounts[${beneficiary}] ${biddingTime},,,false\nbid,bid,instance,,${bidFromAccountIndex},${biddingVal},true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }

  if(transactionName == 'withdraw') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let biddingTime = helper.random(autionTimeLowerBound, autionTimeUpperBound+1);
      let beneficiary = helper.random(0, deployAccountCount);
      let bidFromAccountIndex = helper.random(0, deployAccountCount);
      let biddingVal = helper.random(BiddingValLowerBound, BiddingValUpperBound+1);   
      let text = `withdraw,constructor,,accounts[${beneficiary}] ${biddingTime},0,,false\nwithdraw,bid,instance,,${bidFromAccountIndex},${biddingVal},false\nwithdraw,withdraw,instance,,${beneficiary},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    })  
  }  

  if(transactionName == 'endAuction') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`
      let biddingTime = helper.random(autionTimeLowerBound, autionTimeUpperBound+1);
      let beneficiary = helper.random(0, deployAccountCount);
      let text = `endAuction,constructor,,accounts[${beneficiary}] ${biddingTime},,,false\nendAuction,increase,time,time.duration.seconds[${biddingTime+1}],,,false\nendAuction,endAuction,instance,,,,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }
})


helper.runTests(transactionCounts, transactionFolders, testFolder, contractName);






