//! Drago Factory library.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Library performs computation, Factory is split and library is 20% smaller,
//! allowing for more information stored in Factory.
//! Only approved factories can access this library.

pragma solidity ^0.4.10;

library DragoFactoryLibrary {
    
    struct NewDrago {
	    string name;
	    string symbol;
	    uint dragoID;
	    address newAddress;
	    address owner;
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
