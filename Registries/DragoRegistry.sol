//! Drago Registry contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.
//! Inspired by https://github.com/paritytech/contracts/blob/master/TokenReg.sol

pragma solidity ^0.4.11;

contract Owned {
    
	modifier only_owner { if (msg.sender != owner) return; _; }

	event NewOwner(address indexed old, address indexed current);
   
	function setOwner(address _new) only_owner {
		owner = _new;
		NewOwner(owner, _new);
	}
	
	function getOwner() constant returns (address) {
	    return owner;
	}

	address public owner = msg.sender;
}

contract DragoRegistryFace {

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

contract DragoRegistry is DragoRegistryFace, Owned {
    
	struct Drago {
		address drago;
		string name;
		string symbol;
		uint dragoID;
		address owner;
		address group;
		mapping (bytes32 => bytes32) meta;
	}
    
	// EVENTS

	event Registered(string name, string symbol, uint id, address indexed drago, address indexed owner, address indexed group);
	event Unregistered(string indexed name, string indexed symbol, uint indexed id);
	event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);
	
	// MODIFIERS
	
	modifier when_fee_paid { if (msg.value < fee) return; _; }
	modifier when_address_free(address _drago) { if (mapFromAddress[_drago] != 0) return; _; }
	//modifier when_symbol_free(string _symbol) { if (mapFromSymbol[_symbol] != 0) return; _; }
	modifier when_is_symbol(string _symbol) { if (bytes(_symbol).length != 3) return; _; }
	modifier when_has_symbol(string _symbol) { if (mapFromSymbol[_symbol] == 0) return; _; }
	modifier only_drago_owner(uint _id) { if (dragos[_id].owner != msg.sender) return; _; }
	modifier when_name_free(string _name) { if (mapFromName[_name] != 0) return; _; }
	modifier when_has_name(string _name) { if (mapFromName[_name] == 0) return; _; }
    
	// METHODS
	
	function register(address _drago, string _name, string _symbol, uint _dragoID, address _owner) payable returns (bool) {
		return registerAs(_drago, _name, _symbol, _dragoID, _owner, msg.sender);
	}

	function registerAs(address _drago, string _name, string _symbol, uint _dragoID, address _owner, address _group) payable when_fee_paid when_address_free(_drago) when_name_free(_name) when_is_symbol(_symbol) returns (bool) {
		dragos.push(Drago(_drago, _name, _symbol, _dragoID, _owner, _group));
		mapFromAddress[_drago] = dragos.length;
		mapFromName[_name] = dragos.length;
		mapFromSymbol[_symbol] = dragos.length;
		Registered(_name, _symbol, dragos.length - 1, _drago, _owner, _group);
		return true;
	}
	
	function unregister(uint _id) only_owner {
		Unregistered(dragos[_id].name, dragos[_id].symbol, _id);
		delete mapFromAddress[dragos[_id].drago];
		delete mapFromName[dragos[_id].name];
		delete mapFromSymbol[dragos[_id].symbol];
		delete dragos[_id];
	}
	
	function setMeta(uint _id, bytes32 _key, bytes32 _value) only_drago_owner(_id) {
		dragos[_id].meta[_key] = _value;
		MetaChanged(_id, _key, _value);
	}
	
	function setFee(uint _fee) only_owner {
		fee = _fee;
	}
	
	function upgrade(address _newAddress) payable only_owner {
		DragoRegistry registry = DragoRegistry(_newAddress);
		++version;
		registry.setUpgraded(version);
	    if (!address(registry).call.value(msg.value)(msg.data)) throw;
	}

	function setUpgraded(uint _version) only_owner {
    	version = _version;
  	}
	
	function drain() only_owner {
		if (!msg.sender.send(this.balance))
			throw;
	}
	
	function kill() only_owner {
	    suicide(msg.sender);
	}
	
	// CONSTANT METHODS
	
	function dragoCount() constant returns (uint) { 
	    return dragos.length; 
	}
	
	function drago(uint _id) constant returns (address drago, string name, string symbol, uint dragoID, address owner, address group) {
		var t = dragos[_id];
		drago = t.drago;
		name = t.name;
		symbol = t.symbol;
		dragoID = t.dragoID;
		owner = t.owner;
		group = t.group;
	}

	function fromAddress(address _drago) constant returns (uint id, string name, string symbol, uint dragoID, address owner, address group) {
		id = mapFromAddress[_drago] - 1;
		var t = dragos[id];
		name = t.name;
		symbol = t.symbol;
		dragoID = t.dragoID;
		owner = t.owner;
		group = t.group;
	}

	function fromSymbol(string _symbol) constant returns (uint id, address drago, string name, uint dragoID, address owner, address group) {
		id = mapFromSymbol[_symbol] - 1;
		var t = dragos[id];
		drago = t.drago;
		name = t.name;
		dragoID = t.dragoID;
		owner = t.owner;
		group = t.group;
	}
	
	function fromName(string _name) constant returns (uint id, address drago, string symbol, uint dragoID, address owner, address group) {
		id = mapFromName[_name] - 1;
		var t = dragos[id];
		symbol = t.symbol;
		drago = t.drago;
		dragoID = t.dragoID;
		owner = t.owner;
		group = t.group;
	}
	
	function fromNameSymbol(string _name, string _symbol) constant returns (address) {
	    var id = mapFromName[_name] - 1;
	    var idCheck = mapFromSymbol[_symbol] - 1;
	    var t = dragos[id];
	    if (id != idCheck) return;
	    address drago = t.drago;
	    return drago;
	}

	function meta(uint _id, bytes32 _key) constant returns (bytes32) {
		return dragos[_id].meta[_key];
	}
	
	function getGroups(address _group) constant returns (address[]) {
	    return mapFromGroup[_group];
	}
	
	function getFee() constant returns (uint) {
	    return fee;
	}
	 
	mapping (bytes32 => address) mapFromKey;
	mapping (address => uint) mapFromAddress;
	mapping (string => uint) mapFromName;
	mapping (string => uint) mapFromSymbol;
	mapping (address=> address[]) mapFromGroup;
	uint public fee = 0;
	uint public version;
	Drago[] dragos;
}
