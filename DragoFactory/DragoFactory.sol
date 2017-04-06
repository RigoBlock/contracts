//! DragoFactory contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Owned {
	event NewOwner(address indexed old, address indexed current);
	function setOwner(address _new) {}
	function getOwner() constant returns (address owner) {}
}

contract DragoRegistryFace {

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

contract Drago is Owned {

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	
 	function Drago(string _dragoName,  string _dragoSymbol) {}
	function() payable {}
	function buy() payable returns (uint amount) {}
	function sell(uint256 amount) returns (uint revenue, bool success) {}
	function changeRefundActivationPeriod(uint32 _refundActivationPeriod) {}
	function changeRatio(uint256 _ratio) {}
	function setTransactionFee(uint _transactionFee) {}
	function changeFeeCollector(address _feeCollector) {}
	function changeDragator(address _dragator) {}
	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) {}
	function DragoAdmin(string _dragoName,  string _dragoSymbol, address _dragowner) {}
	function depositToExchange(address exchange, address _who) /*when_approved_exchange*/ payable returns(bool success) {}
	function withdrawFromExchange(address exchange, uint value) returns (bool success) {}
	function placeOrderExchange(address exchange, bool is_stable, uint32 adjustment, uint128 stake) {}
	function cancelOrderExchange(address exchange, uint32 id) {}
	function finalizeDealExchange(address exchange, uint24 id) {}
	
	function balanceOf(address _from) constant returns (uint256 balance) {}
	function getName() constant returns (string name) {}
	function getSymbol() constant returns (string symbol) {}
	function getPrice() constant returns (uint256 price) {}
	function getTransactionFee() constant returns (uint256 transactionFee) {}
	function getFeeCollector() constant returns (address feeCollector) {}
}

contract DragoFactoryFace {

	event DragoCreated(string _name, address _drago, address _dragowner, uint _dragoID);

	function createDrago(string _name, string _symbol, address _dragowner) returns (address _drago, uint _dragoID) {}
	function setFee(uint _fee) {}
	function setBeneficiary(address _dragoDAO) {}
	function drain() {}
	function() {}
	function buyDrago(address targetDrago) payable {}
	function sellDrago(address targetDrago, uint256 amount) {}
	function changeRatio(address targetDrago, uint256 _ratio) {}
	function setTransactionFee(address targetDrago, uint _transactionFee) {}
	function changeFeeCollector(address targetDrago, address _feeCollector) {}
	function changeDragator(address targetDrago, address _dragator) {}
	function depositToExchange(address targetDrago, address exchange, address _who) payable returns(bool success) {}
	function withdrawFromExchange(address targetDrago, address exchange, uint value) returns (bool success) {}
	function placeOrderExchange(address targetDrago, address exchange, bool is_stable, uint32 adjustment, uint128 stake) {}
	function cancelOrderExchange(address targetDrago, address exchange, uint32 id) {}  
	function finalizedDealExchange(address targetDrago, address exchange, uint24 id) {}
    
	function getVersion() constant returns (string version) {}
	function geeLastId() constant returns (uint _dragoID) {}
	function getDragoDAO() constant returns (uint dragoDAO) {}
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
		gabcoin.buyGabcoin.value(msg.value)();
	}
    
	function sellGabcoin(address targetGabcoin, uint256 amount) {
		gabcoin.sellGabcoin(amount);
	}
    
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
	address public targetGabcoin;
	address public gabcoinRegistry;
	address[] public newGabcoins;
	address _targetGabcoin;
	mapping(address => address[]) public created;
}
