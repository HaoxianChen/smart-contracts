Install require packages: 
```
npm install
```

Launch ganache blockchain with 10 accounts on port 8545:
```
ganache -a 10 -p 8545
```
You should see a blockchain server listening on ``127.0.0.1:8545``.

Next, open another terminal, run all tests (requries blockchain running on port 8545):
```
truffle test
```
You should see the gas cost for each transaction, and all 21 tests passing.
