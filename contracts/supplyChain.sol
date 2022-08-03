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
        uint256 productId;
        uint256 ownerId;
        uint256 trxTimeStamp;
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

    function getProduct(uint256 _productId) public view returns (string memory,string memory,string memory, uint256,address,uint256) {
        return (
            products[_productId].modelNumber,
            products[_productId].partNumber,
            products[_productId].serialNumber,
            products[_productId].cost,
            products[_productId].productOwner,
            products[_productId].mfgTimeStamp
        );
    }

    function newOwner(uint256 _user1Id, uint256 _user2Id, uint256 _prodId) onlyOwner(_prodId) public returns (bool) {
        participant memory p1 = participants[_user1Id];
        participant memory p2 = participants[_user2Id];
        uint256 ownership_id = owner_id++;

        if(keccak256(abi.encodePacked(p1.participantType)) == keccak256("Manufacturer")
            && keccak256(abi.encodePacked(p2.participantType)) == keccak256("Supplier")){
            ownerships[ownership_id].productId = _prodId;
            ownerships[ownership_id].productOwner = p2.participantAddress;
            ownerships[owner_id].ownerId = _user2Id;
            ownerships[ownership_id].trxTimeStamp = uint32(block.timestamp);
            products[_prodId].productOwner = p2.participantAddress;
            productTrack[_prodId].push(owner_id);
            emit TransferOwnership(_prodId);

            return true;
        }
        else if(keccak256(abi.encodePacked(p1.participantType)) == keccak256("Supplier") && keccak256(abi.encodePacked(p2.participantType))==keccak256("Supplier")){
            ownerships[ownership_id].productId = _prodId;
            ownerships[ownership_id].productOwner = p2.participantAddress;
            ownerships[ownership_id].ownerId = _user2Id;
            ownerships[ownership_id].trxTimeStamp = uint32(block.timestamp);
            products[_prodId].productOwner = p2.participantAddress;
            productTrack[_prodId].push(ownership_id);
            emit TransferOwnership(_prodId);

            return (true);
        }
        else if(keccak256(abi.encodePacked(p1.participantType)) == keccak256("Supplier") && keccak256(abi.encodePacked(p2.participantType))==keccak256("Consumer")){
            ownerships[ownership_id].productId = _prodId;
            ownerships[ownership_id].productOwner = p2.participantAddress;
            ownerships[ownership_id].ownerId = _user2Id;
            ownerships[ownership_id].trxTimeStamp = uint32(block.timestamp);
            products[_prodId].productOwner = p2.participantAddress;
            productTrack[_prodId].push(ownership_id);
            emit TransferOwnership(_prodId);

            return (true);
        }
        return false;
    }
    // Record of Ownership
    function getProvenance(uint32 _prodId) external view returns (uint256[] memory) {

       return productTrack[_prodId];
    }
    //Owner of a product in a specific point of time
    function getOwnership(uint256 _regId)  public view returns (uint256,uint256,address,uint256) {

        ownership memory r = ownerships[_regId];

         return (r.productId,r.ownerId,r.productOwner,r.trxTimeStamp);
    }
    // Confirms participants is allowed to access certain data
    function authenticateParticipant(
        uint256 _uid,
        string memory _uname,
        string memory _pass,
        string memory _utype) public view returns (bool){
        if(keccak256(abi.encodePacked(participants[_uid].participantType)) == keccak256(abi.encodePacked(_utype))) {
            if(keccak256(abi.encodePacked(participants[_uid].userName)) == keccak256(abi.encodePacked(_uname))) {
                if(keccak256(abi.encodePacked(participants[_uid].password)) == keccak256(abi.encodePacked(_pass))) {
                    return (true);
                }
            }
        }

        return (false);
    }


    
}