//! DragoFactory contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.11;

import "github.com/RigoBlock/contracts/Drago/DragoEVO.sol";

contract DragoRegistry {

	//EVENTS

	event Registered(string name, string symbol, uint id, address indexed drago, address indexed owner, address indexed group);
	event Unregistered(string indexed symbol, uint indexed id);
	event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);
	
	// METHODS
        
	function register(address _drago, string _name, string _symbol, uint _dragoID, address _owner) payable returns (bool) {}
	function registerAs(address _drago, string _name, string _symbol, uint _dragoID, address _owner, address _group) payable returns (bool) {}
	function unregister(uint _id) {}
	function setMeta(uint _id, bytes32 _key, bytes32 _value) {}
	function setFee(uint _fee) {}
	function upgrade(address _newAddress) payable {}
	function setUpgraded(uint _version) {}
	function drain() {}
	function kill() {}
	
	function dragoCount() constant returns (uint) {}
	function drago(uint _id) constant returns (address drago, string name, string symbol, uint dragoID, address owner, address group) {}
	function fromAddress(address _drago) constant returns (uint id, string name, string symbol, uint dragoID, address owner, address group) {}
	function fromSymbol(string _symbol) constant returns (uint id, address drago, string name, uint dragoID, address owner, address group) {}
	function fromName(string _name) constant returns (uint id, address drago, string symbol, uint dragoID, address owner, address group) {}
	function fromNameSymbol(string _name, string _symbol) constant returns (address) {}
	function meta(uint _id, bytes32 _key) constant returns (bytes32) {}
	function getGroups(address _group) constant returns (address[]) {}
	function getFee() constant returns (uint) {}
}

contract DragoFactoryFace {
    
	// EVENTS

	event DragoCreated(string name, string symbol, address indexed drago, address indexed owner, uint dragoID);

	// METHODS

	function createDrago(string _name, string _symbol) returns (bool) {}
	function setTargetDragoDAO(address _targetDrago, address _dragoDAO) {}
	function changeDragoDAO(address _newDragoDAO) {}
	function setRegistry(address _newRegistry) {}
	function setBeneficiary(address _dragoDAO) {}
	function setFee(uint _fee) {}
	function drain() {}
	function setOwner(address _new) {}
    
	function getRegistry() constant returns (address) {}
	function getStorage() constant returns (address dragoDAO, string version, uint nextDragoID) {}
	function getNextID() constant returns (uint nextDragoID) {}
	function getEventful() constant returns (address) {}
	function getDragoDAO() constant returns (address dragoDAO) {}
	function getVersion() constant returns (string version) {}
	function getDragosByAddress(address _owner) constant returns (address[]) {}
	function getOwner() constant returns (address) {}
}

library DragoFactoryLibrary {

    struct NewDrago {
	    string name;
	    string symbol;
	    uint256 dragoID;
	    address owner;
	    address newAddress;
	}

    modifier whitelisted_factory { Authority auth = Authority(0x0C9579829547c95E35535FE3C57cf42F90a98785); if (auth.isWhitelistedFactory(this)) _; }

	function createDrago(NewDrago storage self, string _name, string _symbol, address _owner, uint _dragoID, address _authority) whitelisted_factory returns (bool success) {
	    Drago drago = new Drago(_name, _symbol, _dragoID, _owner, _authority/*, _eventful*/);
	    self.name = _name;
	    self.symbol = _symbol;
	    self.dragoID = _dragoID;
	    self.newAddress = address(drago);
	    self.owner = _owner;
	    return true;
	}
}

contract DragoFactory is Owned, DragoFactoryFace {

	struct Data {
	    uint fee;
	    address dragoRegistry;
	    address dragoDAO;
	    address authority;
	    mapping(address => address[]) dragos;
	}

	event DragoCreated(string name, string symbol, address indexed drago, address indexed owner, uint dragoID);

	modifier when_fee_paid { if (msg.value < data.fee) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	modifier only_drago_dao { if (msg.sender != data.dragoDAO) return; _; }

	function DragoFactory(address _registry, address _dragoDAO, address _authority) {
	    data.dragoRegistry = _registry;
	    data.dragoDAO = _dragoDAO;
	    data.authority = _authority;
	    owner = msg.sender; //has to be set since there was not enough space in drago to use standard Owned
	    //REMEMBER TO SET FACTORY AS WHITELISTER WHEN CREATE A NEW ONE
	    //SO THAT IT CAN WHITELIST MSG.SENDER AND DRAGO IMMEDIATELY
	}

	function createDrago(string _name, string _symbol) returns (bool success) {
        	DragoRegistry registry = DragoRegistry(data.dragoRegistry);
        	uint regFee = registry.getFee();
        	uint dragoID = registry.dragoCount();
        	if (!createDragoInternal(_name, _symbol, msg.sender, dragoID)) return;
        	assert(registry.register.value(regFee)(libraryData.newAddress, _name, _symbol, dragoID, msg.sender));
        	return true;
    	}

	function createDragoInternal(string _name, string _symbol, address _owner, uint _dragoID) internal when_fee_paid returns (bool success) {
	    	Authority auth = Authority(data.authority);
	    	require(DragoFactoryLibrary.createDrago(libraryData, _name, _symbol, _owner, _dragoID, data.authority));
		data.dragos[msg.sender].push(libraryData.newAddress);
		Eventful events = Eventful(getEventful());
		if (!events.createDrago(msg.sender, this, libraryData.newAddress, _name, _symbol, _dragoID, _owner)) return;
		auth.whitelistDrago(libraryData.newAddress, true);
		auth.whitelistUser(msg.sender, true);
		DragoCreated(_name, _symbol, libraryData.newAddress, _owner, _dragoID); //already mapping global events in library
		return true;
	}

	function setTargetDragoDAO(address _targetDrago, address _dragoDAO) only_owner {
		Drago drago = Drago(_targetDrago);
		drago.changeDragoDAO(_dragoDAO);
	}
	
	function changeDragoDAO(address _newDragoDAO) only_drago_dao {
	    data.dragoDAO = _newDragoDAO;
	}
	
	function setRegistry(address _newRegistry) only_owner {
		data.dragoRegistry = _newRegistry;
	}
    
	function setBeneficiary(address _dragoDAO) only_owner {
		data.dragoDAO = _dragoDAO;
	}
	
	function setFee(uint _fee) only_owner {
		data.fee = _fee;
	}

	function drain() only_owner {
		if (!data.dragoDAO.call.value(this.balance)()) throw;
	}

	function getRegistry() constant returns (address) {
	    return (data.dragoRegistry);
	}
	
	function getStorage() constant returns (address dragoDAO, string version, uint nextDragoID) {
	    return (data.dragoDAO, version, nextDragoID);
	}
	
	function getNextID() constant returns (uint nextDragoID) {
	    DragoRegistry registry = DragoRegistry(data.dragoRegistry);
	    nextDragoID = registry.dragoCount();
	}
	
	function getEventful() constant returns (address) {
	    Authority auth = Authority(data.authority);
	    return auth.getEventful();
	}
	
	function getDragoDAO() constant returns (address dragoDAO) {
	    return data.dragoDAO;
	}
	
	function getVersion() constant returns (string version) {
	    return version;
	}
	
	function getDragosByAddress(address _owner) constant returns (address[]) {
	    return data.dragos[msg.sender];
	}
	
	DragoFactoryLibrary.NewDrago libraryData;

	Data data;

	string public version = 'DF0.3.2';
}
