const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');
const ganache = require("ganache");
const fetch = require("node-fetch");


var Link = artifacts.require("LinkToken");

contract("Link", async accounts => {
  it("test Link.transfer gas consumption", async() => {
    const instance = await Link.new();
    const result = await instance.approve(accounts[1], 100, {from: accounts[0]});
    // const result = await instance.transfer(accounts[1], 100, {from: accounts[0]});
    const gasUsed = await result.receipt.gasUsed;
    const hash = await result.tx;
    console.log(result.receipt);
    var gasUsedOp = 0;
    var gasUsedCompute = 0;
    var gasUsedMem = 0;
    var gasUsedStorage = 0;
    await fetch('http://localhost:8545', {
      body: `{"jsonrpc":"2.0", "id": 1, "method": "debug_traceTransaction", "params": [ "${hash}"] }`,
      headers: {
        "Content-Type": "application/json"
      },
      method: "POST"
    })
   .then(res => res.json())
   .then(data => {
     var structLogsCount = data.result.structLogs.length;
     var logs = data.result.structLogs;
     logs.forEach(log => {
       gasUsedOp += +log.gasCost;
       if(log.op == 'CALLDATACOPY' || log.op == 'EXTCODECOPY' || log.op == 'RETURNDATACOPY' || log.op == 'MSTORE' || log.op == 'MSTORE8' || log.op == 'CALL' || log.op == 'CALLCODE' || log.op == 'DELEGATECALL' || log.op == 'STATICCALL') {
         gasUsedMem += +log.gasCost;
       } else if (log.op == 'SSTORE') {
         gasUsedStorage += +log.gasCost;
       } else {
         gasUsedCompute += +log.gasCost;
       }
       console.log(`op: ${log.op} gas: ${log.gas} gasCost: ${log.gasCost}`);
     })
   })

   console.log("\nGas cost (from result.receipt): ", gasUsed);
   console.log("Gas cost (from opcodes): ", gasUsedOp);
   console.log("Gas cost (mem operations): ", gasUsedMem);
   console.log("Gas cost (storage operations): ", gasUsedStorage);
   console.log("Gas cost (computation operations): ", gasUsedCompute);
    // curl -H 'Content-Type: application/json'   --data '{"jsonrpc":"2.0", "id": 1, "method": "debug_traceTransaction", "params": [ "0x947e4af2f52483debffdf52f7daa60b203b146094c4e62e352b33fbb2ef4fd6a" ] }' http://localhost:8545 -o trace.json

  });
})


