//for compability reasons, we work only with these versions
pragma solidity >=0.7.0 < 0.9.0;

import "./DArt.sol";
import "./DCoin.sol";

contract Patron {

    event Donation(address sender, address indexed receiver, bytes32 artwork);
    event UnlockedFunds(address indexed receiver, bytes32 artwork);

    mapping (bytes32 => uint) public patronCredit;
    mapping (bytes32 => uint) public funds;

    
    address public minter;
    //address public constant verificatioSmartcontract; 
    
    DCoin public dcoinSmartcontract;
    //address public dcoinSmartcontract; 
    DArt public mainSmartcontract; 
    

    constructor(){
        minter = msg.sender;
    }


    function setContrats(address main, address dcoin) external {
        assert(msg.sender == minter);
        mainSmartcontract = DArt(main);
        dcoinSmartcontract = DCoin(dcoin);
    }

    function crowfunding(bytes32 artwork, uint amount) external {
        address museum  = mainSmartcontract.getProperty(artwork);
        require(museum != address(0x0), "Artwork does not exist");
        dcoinSmartcontract.lock(amount, msg.sender);
        funds[artwork] += amount;
        patronCredit[hashAddressAndAddress(msg.sender, museum)] += amount;
        emit Donation(msg.sender, museum, artwork);
    }

    function hashAddressAndAddress(address first, address second) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(first, second));
    }

    function viewFunds(bytes32 artwork) external view returns(uint){
        return funds[artwork];
    }

    function viewPatronCredit(address patron, address museum) external view returns(uint){
        return patronCredit[keccak256(abi.encodePacked(patron,museum))];
    }

    function moveFunds(address _to, bytes32 artwork) external {
        assert(msg.sender == address(mainSmartcontract));
        uint fund = funds[artwork];
        if (fund != 0) {
            dcoinSmartcontract.magicMint(_to, fund);
            funds[artwork] = 0;
            emit UnlockedFunds(_to, artwork);
        }
    }
    
    function terminate() public {
        require(msg.sender == minter, "You cannot terminate the contract!");
        selfdestruct(payable(minter));
    }
}