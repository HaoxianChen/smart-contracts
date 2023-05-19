## Folder Structure
-- tracefiles/  
	&emsp;&emsp;-- setup.txt  
	&emsp;&emsp;-- auction/  
	&emsp;&emsp;&emsp;&emsp;-- bid.txt  
	&emsp;&emsp;&emsp;&emsp;-- withdraw.txt  
	&emsp;&emsp;&emsp;&emsp;-- withdraw.txt  
	&emsp;&emsp;&emsp;&emsp;-- ...  
	&emsp;&emsp;&emsp;&emsp;-- [transaction_name].txt  
	&emsp;-- bnb/   
	&emsp;&emsp;&emsp;&emsp;-- mint.txt  
	&emsp;&emsp;&emsp;&emsp;-- burn.txt  
	&emsp;&emsp;&emsp;&emsp;-- transfer.txt  
	&emsp;&emsp;&emsp;&emsp;-- ...  
	&emsp;&emsp;&emsp;&emsp;-- [transaction_name].txt  	 
	&emsp;-- erc20/  
	&emsp;-- .../  
	&emsp;-- .../  
	&emsp;-- [contract_name]/  

## file format
### `setup.txt`
The setup.txt file is placed in the `tracefiles` directory, containing the setup information of the blockchain. The `'a'` keyword stands for the count of the accounts. The `'n'` keyword stands for the name of the contract in the solidity file. The `'na'` keyword specifies the name of the contract after being imported into the test code. For example, the following setup.txt file means the test will first deploy a blockchain of 10 nodes (10 accounts), and the contract is called _Auction_, which is imported from _SimpleAuction_.
```
a,10 
n,SimpleAuction
na,Auction
```
The above file can be first translated into
```
ganache -a 10 -p 8545
```
then
```
const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert,
  time, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

var Auction = artifacts.require("SimpleAuction");
```

### `[transaction_name].txt` 
The tracefile (in txt) of each transaction consists of two types of lines. The first line specifies the number of transactions starting with the `'nt` keyword. The rest of the lines represent the steps prior to the transaction to be tested. These lines consist of the following fields, which are separated by commas: `name of the tested transaction`, `name of the current function call`, `the caller (smart contract)`, `parameters of the current function call`, `the caller ({from: account[i])`, `value (account)`.
```
nt,10
bid,constructor,,30 accounts[0],,
bid,bid,instance,,,10
```
The example above should be translated into the following information/code, assuming it is defined in the _simpleAuction_ contract:
* The transaction should be executed 10 times
* The test is equivalent to the following javascript code:  
``` 
contract("SimpleAuction", async accounts => {
    it("test SimpleAuction.bid gas consumption", async () => {
      const instance = await Auction.new(30, accounts[0]);
      const result = await instance.bid({value:10});
      const gasUsed = await result.receipt.gasUsed;
      console.log("SimpleAuction.bid Gas Used: ", gasUsed);
    });
}
``` 









