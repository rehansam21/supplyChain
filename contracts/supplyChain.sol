// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract supplyChain {
    uint256 public product_id;
    uint256 public participant_id;
    uint256 public owner_id;

    struct product {
        string modelNumber;
        string partNumber;
        string serialNumber;
        address productOwner;
        uint256 cost;
        uint256 mfgTimeStamp;
    }

    mapping (uint256 => product) public products;

    struct participant {
        string userName;
        string password;
        string participantType;
        address participantAddress;
    }

    mapping (uint256 => participant) public participants;

    struct ownership {
        string productId;
        string ownerId;
        string trxTimeStamp;
        address productOwner;
    }
    // Ownership by Ownership Id (Owner_Id)
    mapping (uint256 => ownership) public ownerships;
    // Ownership by Product Id (product_id) / Movment track for a product
    mapping (uint256 => uint256[]) public productTrack;

    event TransferOwnership(uint256 product_id);

    function addParticipant(
        string memory _name, 
        string memory _pass, address _pAdd,
        string memory _pType) public returns (uint256) {
        uint256 userId = participant_id++;
        participants[userId].userName = _name;
        participants[userId].password = _pass;
        participants[userId].participantType = _pType;
        participants[userId].participantAddress = _pAdd;
        
        return userId;

    }

    function getParticipant(uint32 _participant_id) public view returns (string memory,address,string memory) {
        return (participants[_participant_id].userName,
                participants[_participant_id].participantAddress,
                participants[_participant_id].participantType);
    }


    function addProduct(
        uint256 _ownerId,
        string memory _modelNumber,
        string memory _partNumber,
        string memory _serialNumber,
        uint256 _productCost ) public returns (uint256){
        if(keccak256(abi.encodePacked(participants[_ownerId].participantType))==keccak256("Manufacturee")){
            uint256 productId = product_id++;

            products[productId].modelNumber = _modelNumber;
            products[productId].partNumber = _partNumber;
            products[productId].serialNumber = _serialNumber;
            products[productId].cost = _productCost;
            products[productId].productOwner = participants[_ownerId].participantAddress;
            products[productId].mfgTimeStamp = uint32(block.timestamp);

            return productId;

        }
        
        return 0;
    }

    modifier onlyOwner(uint256 _productId) {
        require(msg.sender == products[_productId].productOwner,"Not a Owner of Product");
        _;
    }

    
}