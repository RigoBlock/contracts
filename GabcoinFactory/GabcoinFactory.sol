//! Gabcoin Factory contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract GabcoinRegistry {

	event Registered(string indexed tla, uint indexed id, address addr, string name);
	event Unregistered(string indexed tla, uint indexed id);
	event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);

	function register(address _drago, uint _dragoID) {}	
	function register(address _addr, string _tla, uint _base, string _name) payable returns (bool) {}
	function unregister(uint _id) {}

	function accountOf(uint _dragoID) constant returns (address) {}   
	function dragoOf(address _drago) constant returns (uint) {}
	function tokenCount() constant returns (uint) {}
	function token(uint _id) constant returns (address addr, string tla, uint base, string name, address owner) {}
	function fromAddress(address _addr) constant returns (uint id, string tla, uint base, string name, address owner) {}
	function fromTLA(string _tla) constant returns (uint id, address addr, uint base, string name, address owner) {}
	function meta(uint _id, bytes32 _key) constant returns (bytes32) {}
	function setMeta(uint _id, bytes32 _key, bytes32 _value) {}
}

contract Gabcoin is Owned, ERC20Face {

	event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount,uint256 _revenue);
	//event DepositPOS(uint msg.value, address indexed msg.sender, address indexed _validation, address indexed _withdrawal, address _pos);
 	//event WithdrawPOS(uint deposit, address indexed msg.sender, address _pos);
 
 	function Gabcoin(string _dragoName,  string _dragoSymbol) {}    
	function() payable {}		
	function buyGabcoin() payable returns (uint amount) {}	
	function sellGabcoin(uint256 amount) returns (uint revenue, bool success) {}	
	function changeRatio(uint256 _ratio) {}	
	function setTransactionFee(uint _transactionFee) {}	
	function changeFeeCollector(address _feeCollector) {}	
	function changeCoinator(address _coinator) {}
	
	
	function balanceOf(address _from) constant returns (uint256 balance) {}
	function getVersion() constant returns (string version) {}
	function getName() constant returns (string name) {}
	function getSymbol() constant returns (string symbol) {}
	function getPrice() constant returns (uint256 price) {}
	function getTransactionFee() constant returns (uint256 transactionFee) {}
	function getFeeCollector() constant returns (address feeCollector) {}
}

contract GabcoinFactoryFace is Owned {

	event GabcoinCreated(string _name, address _gabcoin, address _owner, uint _gabcoinID);

	function createGabcoin(string _name, string _symbol, address _owner) returns (address _gabcoin, uint _gabcoinID) {}
	function setFee(uint _fee) {}
	function setBeneficiary(address _gabcoinDAO) {}
	function drain() {}
	function() {}
	function buyGabcoin(address targetGabcoin) payable {}
	function sellGabcoin(address targetGabcoin, uint256 amount) {}
	function changeRatio(address targetGabcoin, uint256 _ratio) {}
	function setTransactionFee(address targetGabcoin, uint _transactionFee) {}
	function changeFeeCollector(address targetGabcoin, address _feeCollector) {}
	function changeCoinator(address targetGabcoin, address _coinator) {}

	function getVersion() constant returns (string version) {}
	function geeLastId() constant returns (uint _dragoID) {}
	function getGabcoinDao() constant returns (uint gabcoinDao) {}
}

contract GabcoinFactory is Owned, GabcoinFactoryFace {
    
	modifier when_fee_paid { if (msg.value < fee) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	modifier only_gabcoin_dao { if (msg.sender != gabcoinDao) return; _; }
	//modifier only_gabcoin_dao
	
	event GabcoinCreated(string _name, address _gabcoin, address _owner, uint _gabcoinID);
    
	function GabcoinFactory () {}
    
	function createGabcoin(string _name, string _symbol, address _owner) when_fee_paid returns (address _gabcoin, uint _gabcoinID) {
		Gabcoin newGabcoin = (new Gabcoin(_name, _symbol));
		newGabcoins.push(address(newGabcoin));
		created[msg.sender].push(address(newGabcoin));
		newGabcoin.setOwner(msg.sender);  //library or new.tranfer(_from)
		_gabcoinID = nextGabcoinID;     //decided at last to add sequential ID numbers
		++nextGabcoinID;              //decided at last to add sequential ID numbers
		registerGabcoin(_gabcoin, _gabcoinID);
		GabcoinCreated(_name, address(newGabcoin), msg.sender, uint(newGabcoin));
		return (address(newGabcoin), uint(newGabcoin));
	}
	
	function registerGabcoin(address _gabcoin, uint _gabcoinID) only_owner {
		GabcoinRegistry registry = GabcoinRegistry(gabcoinRegistry);
		registry.register(_gabcoin, _gabcoinID); //register @ registry
		//event GabcoinRegistered
	}
    
	function setFee(uint _fee) only_owner {    //exmple, uint public fee = 100 finney;
		fee = _fee;
	}
    
	function setBeneficiary(address _gabcoinDao) only_owner {
		gabcoinDao = _gabcoinDao;
	}
  
	function drain() only_owner {
		if (!gabcoinDao.send(this.balance)) throw;
	}
  
	function() {
		throw;
	}
        
	function buyGabcoin(address targetGabcoin) payable {
		Gabcoin m = Gabcoin(targetGabcoin);
		m.buyGabcoin.value(msg.value)();
	}
    
	function sellGabcoin(address targetGabcoin, uint256 amount) {
		Gabcoin m = Gabcoin(targetGabcoin);
		m.sellGabcoin(amount);
	}
    
	function changeRatio(address targetGabcoin, uint256 _ratio) only_gabcoin_dao {
		Gabcoin m = Gabcoin(targetGabcoin);
		m.changeRatio(_ratio);
	}
    
	function setTransactionFee(address targetGabcoin, uint _transactionFee) {    //exmple, uint public fee = 100 finney;
		Gabcoin m = Gabcoin(targetGabcoin);
		m.setTransactionFee(_transactionFee);       //fee is in basis points (1 bps = 0.01%)
	}
    
	function changeFeeCollector(address targetGabcoin, address _feeCollector) {
		Gabcoin m = Gabcoin(targetGabcoin);
		m.changeFeeCollector(_feeCollector);
	}
    
	function changeCoinator(address targetGabcoin, address _coinator) {
		Gabcoin m = Gabcoin(targetGabcoin);
		m.changeCoinator(_coinator);
	}

	string public version = 'GC 0.2';
	uint _gabcoinID = 0;
	uint public fee = 0;
	uint public nextGabcoinID;
	address public gabcoinDao = msg.sender;
	address public owner = msg.sender;
	address public gabcoinRegistry;
	address[] public newGabcoins;
	address _targetGabcoin;
	mapping(address => address[]) public created;
}
