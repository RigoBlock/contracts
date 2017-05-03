//! Drago Factory contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! This contract uses library and has more room for storage.

pragma solidity ^0.4.10;

import "github.com/RigoBlock/contracts/Drago/Drago.sol";

contract DragoRegistry {

	//EVENTS

	event Registered(string indexed symbol, uint indexed id, address drago, string name);
	event Unregistered(string indexed symbol, uint indexed id);
	event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);
	
	// METHODS
        
	function register(address _drago, string _name, string _symbol, uint _dragoID, address _group) payable returns (bool) {}
	function registerAs(address _drago, string _name, string _symbol, uint _dragoID, address _group, address _owner) payable returns (bool) {}
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
	function meta(uint _id, bytes32 _key) constant returns (bytes32) {}
	function getGroups(address _group) constant returns (address[]) {}
}

contract DragoFactoryFace {
    
	// EVENTS

	event DragoCreated(string name, string symbol, address indexed drago, address indexed owner, uint dragoID);

	// METHODS
    
	function createDrago(string _name, string _symbol) returns (bool) {}
	function setRegistry(address _newRegistry) {}
	function setBeneficiary(address _dragoDAO) {}
	function setFee(uint _fee) {}
	function drain() {}
	function setOwner(address _new) {}
    
	function getRegistry() constant returns (address) {}
	function getStorage() constant returns (address dragoDAO, string version, uint nextDragoID) {}
	function getNextID() constant returns (uint nextDragoID) {}
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
	    address authority;
	}
	
	function DragoFactoryLibrary(NewDrago storage newDrago, address _authority) {
	    newDrago.authority = _authority;
	}
	
	event DragoCreated(string name, string symbol, address indexed drago, address indexed owner, uint dragoID);
 	
	function createDrago(NewDrago storage newDrago, string _name, string _symbol, address _owner, uint _dragoID) returns (bool) {
	    Authority auth = Authority(newDrago.authority);
	    if (!auth.isWhitelistedFactory(msg.sender)) return;
	    createDragoInternal(newDrago, _name, _symbol, _owner, _dragoID);
	}
	
	function createDragoInternal(NewDrago storage newDrago, string _name, string _symbol, address _owner, uint _dragoID) internal returns (bool success) {
	    Drago drago = new Drago(_name, _symbol, _dragoID, _owner);
	    drago.setOwner(_owner);
	    newDrago.name = _name;
	    newDrago.symbol = _symbol;
	    newDrago.dragoID = _dragoID;
	    newDrago.newAddress = address(drago);
	    newDrago.owner = _owner;
	    DragoCreated(_name, _symbol, newDrago.newAddress, _owner, newDrago.dragoID);
		return true;
	}
}


contract DragoFactory is Owned, DragoFactoryFace {

	struct Data {
	    uint fee;
	    address dragoRegistry;
	    address dragoDAO;
	    mapping(address => address[]) dragos;
	}

	event DragoCreated(string name, string symbol, address indexed drago, address indexed owner, uint dragoID);

	modifier when_fee_paid { if (msg.value < data.fee) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
    
	function DragoFactory(address _registry, address _dragoDAO, address _authority) {
	    setRegistry(_registry);
	    data.dragoDAO = _dragoDAO;
	}

    function createDrago(string _name, string _symbol) returns (bool success) {
        uint dragoID = registry.dragoCount();
        if (!createDragoInternal(_name, _symbol, msg.sender, dragoID)) return;
        assert(registry.register(myNewDrago.newAddress, myNewDrago.name, myNewDrago.symbol, myNewDrago.dragoID, myNewDrago.owner));
        return true;
    }

	function createDragoInternal(string _name, string _symbol, address _owner, uint _dragoID) internal when_fee_paid returns (bool success) {
		require(myNewDrago.createDrago(_name, _symbol, _owner, _dragoID));
		data.dragos[msg.sender].push(myNewDrago.newAddress);
		events.createDrago(msg.sender, this, myNewDrago.newAddress, myNewDrago.name, myNewDrago.symbol, myNewDrago.dragoID, myNewDrago.owner);
		DragoCreated(myNewDrago.name, myNewDrago.symbol, myNewDrago.newAddress, myNewDrago.owner, myNewDrago.dragoID);
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
		if (!data.dragoDAO.send(this.balance)) throw;
	}

	function getRegistry() constant returns (address) {
	    return (data.dragoRegistry);
	}
	
	function getStorage() constant returns (address dragoDAO, string version, uint nextDragoID) {
	    return (data.dragoDAO, version, nextDragoID);
	}
	
	function getNextID() constant returns (uint nextDragoID) {
	    nextDragoID = registry.dragoCount();
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
	
	using DragoFactoryLibrary for DragoFactoryLibrary.NewDrago;
	DragoFactoryLibrary.NewDrago myNewDrago;

    Data data;
    DragoRegistry registry = DragoRegistry(data.dragoRegistry);
    Authority auth = Authority(0xfea837fA39b547589fB96edE3e498A299e2a9c10);
    Eventful events = Eventful(auth.getEventful());

	string public version = 'DF0.3';
	//address public authority = 0x23A013E7A236DE234437c1E1342022727823e800;
}
