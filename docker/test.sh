echo "Strating ganache server..."
ganache -a 10 -p 8545 > ganache.log & 
truffle test
