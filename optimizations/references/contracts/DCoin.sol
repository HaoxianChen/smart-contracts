//for compability reasons, we work only with these versions
pragma solidity >=0.7.0 < 0.9.0;

//error Unauthorized(address caller);
/*
import "./Verification.sol";
import "./Patron.sol";
import "./DCoin.sol";
*/

//we have objects to work with
contract DCoin {

    event Transfer(address indexed from, address indexed to, uint amount);

    address public minter;
    mapping (address => uint) public balance;
    uint public constant PRICE = 2 * 1e15; 
    uint public burned = 0;
    uint[4] public costOfServices = [1, 1, 1, 1];
    // uint public constant PRICE = 2 finney; 
    // finney is no longer a supported denomination since Solidity v.0.7.0

    address public patronSmartcontract; 
    address public mainSmartcontract; 
    address public verificationSmartcontract;

    constructor() {
        minter = msg.sender;
    }

    function setContrats(address main, address verification, address patron) external {
        assert(minter == msg.sender);
        patronSmartcontract = patron;
        mainSmartcontract = main;
        verificationSmartcontract = verification;
    }

    function  setCostOfServices(uint[4] memory cost) external {
        assert(minter == msg.sender);
        costOfServices = cost;
    }

    function mint() public payable {
        require(msg.value >= PRICE, "Not enough value for a token!");
        balance[msg.sender] += msg.value / PRICE;
        // Guess guess, where does the remainder of the msg.value end?
    }

    function burn(uint costType, address wallet) external {
        assert(msg.sender == mainSmartcontract || msg.sender == verificationSmartcontract);
        uint amount = costOfServices[costType];
        require(balance[wallet] >= amount, "Not enough DCoins!");
        // Take the amount of HelloToken from the sender and give back the amount of ether
        balance[wallet] -= amount;
        burned += amount;
        // Send the amount of ether to the sender
    }

    function lock(uint amount, address wallet) external {
        assert(msg.sender == patronSmartcontract);
        assert(amount > 0);
        require(balance[wallet] >= amount, "Not enough DCoins!");
        balance[wallet] -= amount;
    }

    function transfer(uint amount, address to) external {
        require(balance[msg.sender] >= amount, "Not enough DCoins!");
        require(amount > 0, "Transfer amount canno be less than 1 Dcoin");
        balance[msg.sender] -= amount;
        balance[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function magicMint(address _to, uint amount) external {
        require(msg.sender == patronSmartcontract);
        balance[_to] += amount;
    }

    function withdraw(uint amount) external {
        require(balance[msg.sender] >= amount, "Not enough DCoins!");
        require(amount > 0, "Withdraw amount canno be less than 1 Dcoin");
        balance[msg.sender] -= amount;
        payable(msg.sender).transfer(amount * PRICE);  
    } 

    function terminate() public {
        require(msg.sender == minter, "You cannot terminate the contract!");
        selfdestruct(payable(minter));
    }

    function withdrawETH() external {
        require(msg.sender == minter,  "You're not the minter of the smartcontract");
        payable(minter).transfer(burned * PRICE);
        burned = 0;
    }
}
