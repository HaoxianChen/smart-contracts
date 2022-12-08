FROM node:12-alpine

RUN npm install -g ganache
RUN npm install -g truffle

RUN truffle init

WORKDIR /home/node/

COPY ../smart-contracts/ /home/node/smart-contracts/

WORKDIR /home/node/smart-contracts/
RUN ls 

WORKDIR /home/node/smart-contracts/solidity
RUN npm install
RUN truffle compile

WORKDIR /home/node/smart-contracts/dsc
RUN npm install
RUN truffle compile

WORKDIR /home/node/smart-contracts/dsc-instruments
RUN npm install
RUN truffle compile

COPY ./test.sh /home/node/smart-contracts/solidity
COPY ./test.sh /home/node/smart-contracts/dsc
COPY ./test.sh /home/node/smart-contracts/dsc-instruments

WORKDIR /home/node/smart-contracts/
