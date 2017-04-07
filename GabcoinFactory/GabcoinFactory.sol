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
	//event DepositCasper(uint msg.value, address indexed msg.sender, address indexed _validation, address indexed _withdrawal, address _casper);
 	//event WithdrawCasper(uint deposit, address indexed msg.sender, address _casper);

 	function Gabcoin(string _dragoName,  string _dragoSymbol) {}    
	function() payable {}		
	function buyGabcoin() payable returns (uint amount) {}	
	function sellGabcoin(uint256 amount) returns (uint revenue, bool success) {}
	//function depositCasper(address _validation, address _withdrawal, address _casper) returns (bool success) {}
	//function withdrawCasper(uint _validatorIndex, address _casper) {}
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
	function getCasper() constant returns (address _casper) {}
}

contract GabcoinFactoryFace is Owned {

	event GabcoinCreated(string _name, address _gabcoin, address _owner, uint _gabcoinID);
	//event GabcoinBought();
	//event GabcoinSold();
	//event CasperDeposit(uint msg.value, address indexed msg.sender, address indexed _validation, address indexed _withdrawal, address _casper);
 	//event CasperWithdraw(uint deposit, address indexed msg.sender, address _casper);

	function createGabcoin(string _name, string _symbol, address _owner) returns (address _gabcoin, uint _gabcoinID) {}
	function setFee(uint _fee) {}
	function setBeneficiary(address _gabcoinDAO) {}
	function drain() {}
	function() {}
	function buyGabcoin(address targetGabcoin) payable {}
	function sellGabcoin(address targetGabcoin, uint256 amount) {}
	//function depositCasper(address targetGabcoin, address _casper) {}
	//function withdrawCasper(address targetGabcoin, address _casper) {}
	function changeRatio(address targetGabcoin, uint256 _ratio) {}
	function setTransactionFee(address targetGabcoin, uint _transactionFee) {}
	function changeFeeCollector(address targetGabcoin, address _feeCollector) {}
	function changeCoinator(address targetGabcoin, address _coinator) {}

	function getVersion() constant returns (string version) {}
	function geeLastId() constant returns (uint _dragoID) {}
	function getGabcoinDao() constant returns (address gabcoinDao) {}
	//function getCasper() constant returns (address casper) {}
}

contract GabcoinFactory is Owned, GabcoinFactoryFace {
    
	modifier when_fee_paid { if (msg.value < fee) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	modifier only_gabcoin_dao { if (msg.sender != gabcoinDao) return; _; }
	//modifier only_gabcoin_dao
	//modifier casper_contract_only { if (_casper != casper) return; _; }
	
	event GabcoinCreated(string _name, address _gabcoin, address _owner, uint _gabcoinID);
	//event GabcoinBought();
	//event GabcoinSold();
	//event CasperDeposit(uint msg.value, address indexed msg.sender, address indexed _validation, address indexed _withdrawal, address _casper);
 	//event CasperWithdraw(uint deposit, address indexed msg.sender, address _casper);
    
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
		gabcoin.buyGabcoin.value(msg.value)();
	}
    
	function sellGabcoin(address targetGabcoin, uint256 amount) {
		gabcoin.sellGabcoin(amount);
	}
	
	/*
	function depositCasper(address targetGabcoin, address _casper) casper_contract_only only_owner {
		Pos pos = Pos(_casper);
		assert(pos.depositCasper(msg.value)(_casper));
	}
	
	function withdrawCasper(address targetGabcoin, address _casper) casper_contract_only only_owner {
		Pos pos = Pos(_casper);
		assert(pos.withdrawCasper(msg.value)(_casper));
	}
	*/
    
	function changeRatio(address targetGabcoin, uint256 _ratio) only_gabcoin_dao {
		gabcoin.changeRatio(_ratio);
	}
    
	function setTransactionFee(address targetGabcoin, uint _transactionFee) {    //exmple, uint public fee = 100 finney;
		gabcoin.setTransactionFee(_transactionFee);       //fee is in basis points (1 bps = 0.01%)
	}
    
	function changeFeeCollector(address targetGabcoin, address _feeCollector) {
		gabcoin.changeFeeCollector(_feeCollector);
	}
    
	function changeCoinator(address targetGabcoin, address _coinator) {
		gabcoin.changeCoinator(_coinator);
	}

	Gabcoin gabcoin = Gabcoin(targetGabcoin);
	string public version = 'GC 0.2';
	uint _gabcoinID = 0;
	uint public fee = 0;
	uint public nextGabcoinID;
	address public gabcoinDao = msg.sender;
	address public owner = msg.sender;
	address public gabcoinRegistry;
	address[] public newGabcoins;
	address _targetGabcoin;
	//address public casper;
	mapping(address => address[]) public created;
}
