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

const testFolder = path.join(__dirname, `../tracefiles/voting`);
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

  if(transactionName == 'vote') {
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let ownerIndex = helper.random(0, deployAccountCount);
      let index_1 = helper.random(0, deployAccountCount);
      let arrayRandom = [];
      for (let appIndex = 0; appIndex < deployAccountCount; appIndex++) {
        if(appIndex != index_1) {
          arrayRandom.push(appIndex);
        }
      }
      let arrayRandomLen = arrayRandom.length;
      let index_2 = arrayRandom[helper.random(0, arrayRandomLen)];
      let indexSmall;
      let indexLarge;
      if(index_1 > index_2) {
        indexSmall = index_2;
        indexLarge = index_1;
      } else {
        indexSmall = index_1;
        indexLarge = index_2;
      }
      let len = indexLarge - indexSmall + 1;
      let quorum = helper.random(Math.floor(len/2),len+1);
      let proposal = helper.random(lowerBound, upperBound+1);
      let voterIndex = indexSmall + helper.random(0, len);
      let text = `vote,constructor,,arrOfAccounts(${indexSmall};${indexLarge}) ${quorum},${ownerIndex},,false\nvote,vote,instance,${proposal},${voterIndex},,false\nvote,vote,instance,${proposal+1},${voterIndex},,false\nvote,vote,instance,${proposal+2},${voterIndex},,false\nvote,vote,instance,${proposal+3},${voterIndex},,false\nvote,vote,instance,${proposal+2},${voterIndex},,true\n`;
      fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
        if (err) throw err;
        console.log('File is created successfully.');
      });
    }) 
  }
 




    


})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName)
