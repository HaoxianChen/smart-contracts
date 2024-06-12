//for compability reasons, we work only with these versions
pragma solidity >=0.7.0 < 0.9.0;


import "./Verification.sol";
import "./Patron.sol";
import "./DCoin.sol";

//we have objects to work with
contract DArt {

    event allowedAccessToArtwork(bytes32 indexed artwork, address indexed user);
    event deniedAccessToArtwork(bytes32 indexed artwork, address indexed user);
    event donatedArtwork(bytes32 indexed artwork, address indexed user);

    //event ProtectionActivityStarted(Artwork indexed artwork);

    //we have a struct to store the data about artworks
    struct Artwork {
        bytes32 hashedName;
        address minter; //the address of the museum that minted the artwork
        address property;
        address possession;
        bytes32 exposedAt; // Da vedere come gestire lo storico delle esposizioni
        bytes32 status; // Da vedere come gestire lo storico delle operazioni
    }

    // A struct to collect information about exibitions
    struct Exibition {
        bytes32 hashedName;
        address organizer;
        bool isOn; 
    }

    struct Activity{
        // bytes32 artworkId;
        address author;
        uint timestamp;
        ProtectionActivities typology;
        bytes32 extraInfo;
    }
    
    // This enum indicates the type of operation applied to and update of an artwork
    enum ProtectionActivities {
        PREVENTION,
        PROTECTIOIN,
        MAINTAINANCE,
        RESTAURATION,
        DAMAGE,
        UPDATE
    }

    //this is the address of the creator MAYBE PRIVATE, namely the owner
    //of the smart contract that it can do some special actions
    address public creator;

    mapping (bytes32 => Artwork) public registeredArtworks;
    mapping (bytes32 => Exibition) public registerdExibitions;
    mapping (bytes32 => Activity) public registerdActivities;

    /*
    address public constant dcoinSmartcontract;
    address public constant verificatioSmartcontract; 
    address public constant patronSmartcontract;
    */

    //         mainSmartcontract.call(abi.encodeWithSignature("setCostOfServices(uint[3])", [1,2,3]));

    Verification public verification;
    DCoin public dcoin;
    Patron public patron;   
  


    //the first time that we call che smart contract we need to save which is the
    //creator, because it can do after some important actions
    constructor(){
        //so we save the address of the creator, one time and forever
        /*
        dcoin = dcoinSmartcontract;
        verification = verificatioSmartcontract;
        patron = patronSmartcontract;
        */
        creator = msg.sender;
        //dcoin.setContrats(address(Patron(address(patron))));
    }

    function setContracts(address dcoinad, address verificationad, address patronad) external{
        require(msg.sender == creator, "Only the creator can set the contracts");
        dcoin = DCoin(dcoinad);
        verification = Verification(verificationad);
        patron = Patron(patronad);
    }

    /**
        @notice a pure faction to hash a string and the address of the caller, used to create univoque ids
        @param hashedName the hashed string that have to be hashed with the msg.sender
     */
     // Dovrebbe essere pure ma da errore
    function hashTextAndAddress(bytes32 hashedName) public view returns(bytes32) {
        return keccak256(abi.encodePacked(hashedName, msg.sender));
    }

    function checkWallet() internal view {
        //(bool success, bytes memory data) = verification.call(abi.encodeWithSignature("isVerified(address)",msg.sender));
        require(verification.isVerified(msg.sender), "Sender's wallet is not verifed");
        //assert(verification.isVerified(msg.sender));
        /*assert(
            verificationSmartcontract.call(aby.encodingWithSignature("isVerified(address)",msg.sender)),
            "Sender's wallet is not verifed");*/
    }

    //called by a museum, to add an artwork in blockchain (MAYBE TO DO
    /**
        @notice mint an Artwork NFT. The id of the NFT is the hash of its name and the minter address.
        @param hashedName name of the artwork hashed using keccak256
     */    
    function mintArtworkNFT(bytes32 hashedName) external {
        uint role = verification.getRole(msg.sender);
        assert(role < 4);
        bytes32 kek = hashTextAndAddress(hashedName);
        require(registeredArtworks[kek].minter == address(0x0), "A collision during hashing occurred");
        dcoin.burn(0, msg.sender);   
        registeredArtworks[kek] = Artwork(hashedName, msg.sender, msg.sender, msg.sender, 0, 0);
    }

    /**
        @notice mint an Exibition NFT. The id of the NFT is the hash of its name and the minter address.
        @param hashedName the Exibition's name hashed using keccak256
        @param status indicates the status of the creare exibition, if it's on or not
     */
    function mintExibitionNFT(bytes32 hashedName, bool status) external {
        uint role = verification.getRole(msg.sender);
        assert(role < 2);
        bytes32 kek = hashTextAndAddress(hashedName);
        assert(registeredArtworks[kek].minter == address(0x0));
        dcoin.burn(1, msg.sender);
        registerdExibitions[kek] = Exibition(hashedName, msg.sender, status);
    }

    function endExibition(bytes32 exibitionID) external {
        require(registerdExibitions[exibitionID].organizer == msg.sender, "You do not have the necessary permissions to end this exibition");
        registerdExibitions[exibitionID].isOn = false;
    }

    function exposeArtwork(bytes32 artworkID, bytes32 exibitionID) external {
        require(registeredArtworks[artworkID].property == msg.sender, "You do not have the necessary permissions to expose this artwork");
        require(registerdExibitions[exibitionID].isOn, "The exibition is not on");
        require(registerdExibitions[exibitionID].organizer == msg.sender, "The exibition is not on");
        registeredArtworks[artworkID].exposedAt = exibitionID;
    }

    function removeArtworkFromExibition(bytes32 artworkID) external {
        require(registeredArtworks[artworkID].possession == msg.sender, "You do not have the necessary permissions to remove this artwork");
        registeredArtworks[artworkID].exposedAt = bytes32(0x0);
    }

    function mintActivity(bytes32 artworkID, ProtectionActivities oftype, bytes32 extrainfo) external{
        uint role = verification.getRole(msg.sender);
        assert(role == 4);
        require(registeredArtworks[artworkID].possession == msg.sender,  "You do not have the necessary permissions to create an Activity about this artwork");
        bytes32 kek = keccak256(abi.encodePacked(msg.sender, block.timestamp));
        registeredArtworks[artworkID].status =   kek;
        registerdActivities[kek] = Activity(msg.sender, block.timestamp, oftype, extrainfo);  
        dcoin.burn(2,msg.sender);
        if (oftype != ProtectionActivities.UPDATE && oftype != ProtectionActivities.DAMAGE){
            patron.moveFunds(msg.sender, artworkID);
        }
    }

    function allowAccessToArtwork(address target, bytes32 artwork) external {
        //assert(museums[target].verified);
        assert(registeredArtworks[artwork].property == msg.sender);
        registeredArtworks[artwork].possession = target;
        emit allowedAccessToArtwork(artwork, target);
    }

    function revokeAccessToArtwork(bytes32 artwork) external {
        assert(registeredArtworks[artwork].property == msg.sender);
        emit deniedAccessToArtwork(artwork, registeredArtworks[artwork].possession);
        registeredArtworks[artwork].possession = msg.sender;
    }

    function donateWorkOfArt(bytes32 artwork, address _to) external{
        require(registeredArtworks[artwork].property == msg.sender, "You are not the owner of the selected artowork");
        //require is verified
        registeredArtworks[artwork].property = _to;
        emit donatedArtwork(artwork, _to);
    }

    function getProperty(bytes32 artwork) external view returns(address){
        return registeredArtworks[artwork].property;
    }

    function terminate() public {
        require(msg.sender == creator, "You cannot terminate the contract!");
        selfdestruct(payable(creator));
    }
}
