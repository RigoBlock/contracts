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

	event DragoCreated(string _name, address _drago, address _owner, uint _dragoID);

	// METHODS
    
	function createDrago(string _name, string _symbol) returns (bool) {}
	function setRegistry(address _newRegistry) {}
	function setBeneficiary(address _dragoDAO) {}
	function setFee(uint _fee) {}
	function drain() {}
	function setOwner(address _new) {}
    
	function getRegistry() constant returns (address) {}
	function getStorage() constant returns (address dragoDAO, string version, uint nextDragoID) {}
    function getOwner() constant returns (address) {}
}

contract DragoFactory is Owned, DragoFactoryFace {
    
    struct Data {
	    uint fee;
	    address dragoRegistry;
	    address[] newDragos;
	    uint nextDragoID;
	    mapping(address => address[]) created;
	}

	event DragoCreated(string indexed _name, string _symbol, address indexed _drago, address indexed _owner, uint _dragoID);

	modifier when_fee_paid { if (msg.value < data.fee) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
    
	//function DragoFactory () {}

	function createDrago(string _name, string _symbol) when_fee_paid returns (bool success) {
		++data.nextDragoID;
		uint dragoID = data.nextDragoID;
		Drago newDrago = (new Drago(_name, _symbol, dragoID));
		data.newDragos.push(address(newDrago));
		data.created[msg.sender].push(address(newDrago));
		newDrago.setOwner(msg.sender);  //owner is msg.sender
		address drago = address(newDrago);
		registerDrago(drago, _name, _symbol, dragoID);
		DragoCreated(_name, _symbol, drago, msg.sender, dragoID);
		return true;
	}
	
	function registerDrago(address _drago, string _name, string _symbol, uint _dragoID) internal {
		DragoRegistry registry = DragoRegistry(data.dragoRegistry);
		assert(registry.registerAs(_drago, _name, _symbol, _dragoID, msg.sender));
	}
	
	function setRegistry(address _newRegistry) only_owner {
		data.dragoRegistry = _newRegistry;
	}
    
	function setBeneficiary(address _dragoDAO) only_owner {
		dragoDAO = _dragoDAO;
	}
	
	function setFee(uint _fee) only_owner {
		data.fee = _fee;
	}

	function drain() only_owner {
		if (!dragoDAO.send(this.balance)) throw;
	}

	function getRegistry() constant returns (address) {
	    return (data.dragoRegistry);
	}
	
	function getStorage() constant returns (address dragoDAO, string version, uint nextDragoID) {
	    return (dragoDAO, version, nextDragoID);
	}
	
	Data data;
	
	string public version = 'DF0.3';
	//uint public nextDragoID = 1;
	address public dragoDAO = msg.sender;
	address public owner = msg.sender;
}
