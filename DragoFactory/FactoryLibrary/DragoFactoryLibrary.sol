//! Drago Factory library.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Library performs computation, Factory is split and library is 20% smaller,
//! allowing for more information stored in Factory.
//! Only approved factories can access this library.

pragma solidity ^0.4.11;

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
