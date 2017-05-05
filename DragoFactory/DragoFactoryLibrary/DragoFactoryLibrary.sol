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
	    uint256 dragoID;
	    address owner;
	    address newAddress;
	}

	event DragoCreated(string name, string symbol, address indexed drago, address indexed owner, uint dragoID);

	function createDrago(NewDrago storage newDrago, string _name, string _symbol, address _owner, uint _dragoID, address _authority, address _eventful) returns (bool success) {
	    Authority auth = Authority(0xDFF383e12A7939779359bf6A7f8766E123a18452);
	    if (!auth.isWhitelistedFactory(this)) return;
	    Drago drago = new Drago(_name, _symbol, _dragoID, _owner, _authority, _eventful);
	    newDrago.name = _name;
	    newDrago.symbol = _symbol;
	    newDrago.dragoID = _dragoID;
	    newDrago.newAddress = address(drago);
	    newDrago.owner = _owner;
	    DragoCreated(_name, _symbol, newDrago.newAddress, _owner, newDrago.dragoID);
	    //Authority auth = Authority(newDrago.authority);
	    //Authority auth = Authority(0xDFF383e12A7939779359bf6A7f8766E123a18452);
	    //createDragoInternal(newDrago, _name, _symbol, _owner, _dragoID, _authority, _eventful);
	}
}
