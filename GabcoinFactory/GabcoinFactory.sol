//! Gabcoin Factory contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract GabcoinRegistryFace {

	function register(address _gabcoin, uint _gabcoinID) {}
    
	function accountOf(uint _gabcoinID) constant returns (address) {}
	function gabcoinOf(address _gabcoin) constant returns (uint) {}
}

library Gabcoin Factory is Owned, GabcoinFactoryFace {
    
	modifier when_fee_paid { if (msg.value < fee) return; _; }
	//modifier only_rigoblock
	
	event GabcoinCreated(string _name, address _gabcoin, address _owner, uint _gabcoinID);
    
	function GabcoinFactory () {}
    
	function createGabcoin(string _name, string _symbol, address _owner) when_fee_paid returns (address _gabcoin, uint _gabcoinID) {
		Gabcoin newGabcoin = (new Gabcoin(_name, _symbol, _owner));
		newGabcoins.push(address(newGabcoin));
		created[msg.sender].push(address(newGabcoin));
		newGabcoin.transferOwnership(msg.sender);  //library or new.tranfer(_from)
		_dragoID = nextDragoID;     //decided at last to add sequential ID numbers
		++nextDragoID;              //decided at last to add sequential ID numbers
		if (!registerGabcoin(_gabcoin, _gabcoinID)) throw; ;
		GabcoinCreated(_name, address(newGabcoin), msg.sender, uint(newGabcoin));
		return (address(newGabcoin), uint(newGabcoin));
	}
	
	function registerGabcoin(address _gabcoin, uint _gabcoinID) onlyOwner {
		GabcoinRegistry registry = GabcoinRegistry(gabcoinRegistry);
		if (!registry.register(_gabcoin, _gabcoinID)) throw; ; //register @ registry
		//event GabcoinRegistered
	}
    
	function setFee(uint _fee) onlyOwner {    //exmple, uint public fee = 100 finney;
		fee = _fee;
	}
    
	function setBeneficiary(address _rigoblock) onlyOwner {
		rigoblock = _rigoblock;
	}
  
	function drain() onlyOwner {
		if (!rigoblock.send(this.balance)); throw ;
	}
  
	function() {
		throw;
	}
        
	function buyGabcoin(address targetGabcoin) payable {
		Gabcoin m = Gabcoin(targetGabcoin);
		if (!m.buy.value(msg.value)(); throw ;
	}
    
	function sellGabcoin(address targetGabcoin, uint256 amount) {
		Gabcoin m = Gabcoin(targetGabcoin);
		if (!m.sell(amount); throw ;
	}
    
	function changeRatio(address targetGabcoin, uint256 _ratio) only_rigoblock {
		Gabcoin m = Gabcoin(targetGabcoin);
		if (!m.changeRatio(_ratio); throw ;
	}
    
	function setTransactionFee(address targetGabcoin, uint _transactionFee) {    //exmple, uint public fee = 100 finney;
		Gabcoin m = Gabcoin(targetGabcoin);
		if (!m.setTransactionFee(_transactionFee); throw ;       //fee is in basis points (1 bps = 0.01%)
	}
    
	function changeFeeCollector(address targetGabcoin, address _feeCollector) {
		Gabcoin m = Gabcoin(targetGabcoin);
		if (!m.changeFeeCollector(_feeCollector); throw ;
	}
    
	function changeCoinator(address targetGabcoin, address _coinator) {
		Gabcoin m = Gabcoin(targetGabcoin);
		if (!m.changeDragator(_dragator); throw ;
	}

	string public version = 'GC 0.2';
	//uint[] _gabcoinID; //amended below to have first fund ID = 1
	uint _gabcoinID = 0;
	uint public fee = 0;
	address public rigoblock = msg.sender;
	address[] public newGabcoins;
	address _targetGabcoin;
}
