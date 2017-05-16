//! Drago Factory library.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! ALWAYS DOUBLE CHECK ADDRESS AUTHORITY WHEN DEPLOY ON NEW NETWORK
//! Only approved factories can access this library.

pragma solidity ^0.4.11;

library GabcoinFactoryLibrary {

    struct NewGabcoin {
	    string name;
	    string symbol;
	    uint256 gabcoinID;
	    address owner;
	    address newAddress;
	}

    modifier whitelisted_factory { Authority auth = Authority(0x0C9579829547c95E35535FE3C57cf42F90a98785); if (auth.isWhitelistedFactory(this)) _; }

	function createGabcoin(NewGabcoin storage self, string _name, string _symbol, address _owner, uint _gabcoinID, address _authority) whitelisted_factory returns (bool success) {
	    Gabcoin gabcoin = new Gabcoin(_name, _symbol, _gabcoinID, _owner, _authority);
	    self.name = _name;
	    self.symbol = _symbol;
	    self.gabcoinID = _gabcoinID;
	    self.newAddress = address(gabcoin);
	    self.owner = _owner;
	    return true;
	}
}
