//! DragoFactory contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

import "github.com/RigoBlock/contracts/Drago/Drago.sol";

contract DragoRegistry {

	//EVENTS

	event Registered(string indexed symbol, uint indexed id, address drago, string name);
	event Unregistered(string indexed symbol, uint indexed id);
	event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);
	
	// METHODS
        
	function register(address _drago, string _name, string _symbol, uint _dragoID) payable returns (bool) {}
	function registerAs(address _drago, string _name, string _symbol, uint _dragoID, address _owner) payable returns (bool) {}
	function unregister(uint _id) {}
	function setMeta(uint _id, bytes32 _key, bytes32 _value) {}
	function setFee(uint _fee) {}
	function drain() {}
	
	function dragoCount() constant returns (uint) {}
	function drago(uint _id) constant returns (address drago, string name, string symbol, uint dragoID, address owner) {}
	function fromAddress(address _drago) constant returns (uint id, string name, string symbol, uint dragoID, address owner) {}
	function fromSymbol(string _symbol) constant returns (uint id, address drago, string name, uint dragoID, address owner) {}
	function fromName(string _name) constant returns (uint id, address drago, string symbol, uint dragoID, address owner) {}
	function meta(uint _id, bytes32 _key) constant returns (bytes32) {}
}

contract DragoFactoryFace {
    
	// EVENTS

	event DragoCreated(string _name, address _drago, address _dragowner, uint _dragoID);
	event DragoRegistered(address indexed _drago, string _name, string _symbol, uint _dragoID, address indexed owner);

	// METHODS
    
	function createDrago(string _name, string _symbol) returns (address _drago, uint _dragoID) {}
	function setRegistry(address _newRegistry) {}
	function setBeneficiary(address _dragoDAO) {}
	function setFee(uint _fee) {}
	function drain() {}
    
	function getRegistry() constant returns (address) {}
	function getBeneficiary() constant returns (address) {}
	function getVersion() constant returns (string) {}
	function getLastId() constant returns (uint) {}
}

contract DragoFactory is Owned, DragoFactoryFace {
    
	// EVENTS
	
	event DragoCreated(string _name, string _symbol, address _drago, address _dragowner, uint _dragoID);
	event DragoRegistered(address indexed _drago, string _name, string _symbol, uint _dragoID, address indexed owner);
    
	// MODIFIERS
    
	modifier when_fee_paid { if (msg.value < fee) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	//modifier only_drago_dao { if (msg.sender != dragoDao) return; _; }
	
	// METHODS
    
	function DragoFactory () {}

	function createDrago(string _name, string _symbol) when_fee_paid returns (address _drago, uint _dragoID) {
		var dragoID = nextDragoID;
		++nextDragoID;
		Drago newDrago = (new Drago(_name, _symbol, dragoID));
		newDragos.push(address(newDrago));
		created[msg.sender].push(address(newDrago));
		newDrago.setOwner(msg.sender);  //owner is msg.sender
		registerDrago(_drago, _name, _symbol, _dragoID);
		DragoCreated(_name, _symbol, address(newDrago), msg.sender, uint(newDrago));
		return (address(newDrago), uint(newDrago));
	}
	
	function registerDrago(address _drago, string _name, string _symbol, uint _dragoID) internal {
		DragoRegistry registry = DragoRegistry(dragoRegistry);
		assert(registry.registerAs(_drago, _name, _symbol, _dragoID, msg.sender));
	}
	
	function setRegistry(address _newRegistry) only_owner {
		dragoRegistry = _newRegistry;
	}
    
	function setBeneficiary(address _dragoDAO) only_owner {
		dragoDAO = _dragoDAO;
	}
	
	function setFee(uint _fee) only_owner {
		fee = _fee;
	}

	function drain() only_owner {
		if (!dragoDAO.send(this.balance)) throw;
	}
    
	function() {
		throw;
	}
	
	// CONSTANT METHODS
	
	function getRegistry() constant returns (address) {
	    return dragoRegistry;
	}
	
	function getBeneficiary() constant returns (address) {
	    return dragoDAO;
	}
	
	function getVersion() constant returns (string) {
	    return version;
	}
	
	function getLastId() constant returns (uint) {
	    return nextDragoID;
	}
	
	string public version = 'DF0.2';
	uint public fee = 0;
	uint public nextDragoID = 1;
	address public dragoDAO = msg.sender;
	address public dragoRegistry;
	address public owner = msg.sender;
	address[] public newDragos;
	mapping(address => address[]) public created;
}
