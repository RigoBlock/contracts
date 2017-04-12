//! DragoFactory contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Owned {
	event NewOwner(address indexed old, address indexed current);
	function setOwner(address _new) {}
	function getOwner() constant returns (address owner) {}
}

contract DragoRegistry {

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
	function depositToExchange(address exchange, address token, uint256 value) payable returns(bool success) {}
	function withdrawFromExchange(address exchange, address token, uint256 value) returns (bool success) {}
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
	function depositToExchange(address targetDrago, address exchange, address token, uint256 value) payable returns(bool success) {}
	function withdrawFromExchange(address targetDrago, address exchange, address token, uint256 value) returns (bool success) {}
	function placeOrderExchange(address targetDrago, address exchange, bool is_stable, uint32 adjustment, uint128 stake) {}
	function cancelOrderExchange(address targetDrago, address exchange, uint32 id) {}  
	function finalizedDealExchange(address targetDrago, address exchange, uint24 id) {}

	function getVersion() constant returns (string version) {}
	function geeLastId() constant returns (uint _dragoID) {}
	function getDragoDAO() constant returns (uint dragoDAO) {}
}

contract DragoFactory is Owned, DragoFactoryFace {
    
	modifier when_fee_paid { if (msg.value < fee) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	//modifier only_drago_dao
	
	event DragoCreated(string _name, address _drago, address _dragowner, uint _dragoID);
    
	function DragoFactory () {}
    
	function createDrago(string _name, string _symbol, address _owner) when_fee_paid returns (address _drago, uint _dragoID) {
		//can be amended to set owner as per input
		Drago newDrago = (new Drago(_name, _symbol)); //Drago newDrago = (new Drago(_name, _symbol, _dragowner));
		newDragos.push(address(newDrago));
		created[msg.sender].push(address(newDrago));
		newDrago.setOwner(msg.sender);  //library or new.tranfer(_from)
		_dragoID = nextDragoID;     //decided at last to add sequential ID numbers
		++nextDragoID;              //decided at last to add sequential ID numbers
		registerDrago(_drago, _dragoID, _dragoRegistry);
		DragoCreated(_name, address(newDrago), msg.sender, uint(newDrago));
		return (address(newDrago), uint(newDrago));
	}
	
	function registerDrago(address _drago, uint _dragoID, address _dragoRegistry) only_owner {
		DragoRegistry registry = DragoRegistry(_dragoRegistry); //define address
		registry.register(_drago, _dragoID);
	}
    
	function setFee(uint _fee) only_owner {    //exmple, uint public fee = 100 finney;
		fee = _fee;
	}
	
	function changeRegistry(address _newRegistry) only_owner {
        _dragoRegistry = _newRegistry;
        //NewRegistry(_dragoRegistry, _newRegistry);
	}
    
	function setBeneficiary(address _dragoDAO) only_owner {
		dragoDAO = _dragoDAO;
	}
    
	function drain() only_owner {
		if (!dragoDAO.send(this.balance)) throw;
	}
    
	function() {
		throw;
	}
        
	function buyDrago(address _targetDrago) payable {
		drago.buy.value(msg.value)();
	}
    
	function sellDrago(address _targetDrago, uint256 amount) {
		drago.sell(amount);
	}
    
	function changeRatio(address _targetDrago, uint256 _ratio) /*only_drago_dao*/ {
		drago.changeRatio(_ratio);
	}
    
	function setTransactionFee(address _targetDrago, uint _transactionFee) {    //exmple, uint public fee = 100 finney;
		drago.setTransactionFee(_transactionFee);       //fee is in basis points (1 bps = 0.01%)
	}
    
	function changeFeeCollector(address _targetDrago, address _feeCollector) {
		drago.changeFeeCollector(_feeCollector);
	}
    
	function changeDragator(address _targetDrago, address _dragator) {
		drago.changeDragator(_dragator);
	}
    
	function depositToExchange(address _targetDrago, address exchange, address token, uint256 value) /*when_approved_exchange*/ payable returns(bool success) {
		//address who used to determine from which account
		assert(drago.depositToExchange.value(msg.value)(exchange, token, value));
	}
	
	function withdrawFromExchange(address _targetDrago, address exchange, address token, uint256 value) returns (bool success) {
		//remember to reinsert address _who
		if (!drago.withdrawFromExchange(exchange, token, value)) throw;
	}
	
	function placeOrderExchange(address _targetDrago, address exchange, bool is_stable, uint32 adjustment, uint128 stake) {
		drago.placeOrderExchange(exchange, is_stable, adjustment, stake);
	}
    
	function cancelOrderExchange(address _targetDrago, address exchange, uint32 id) {
		drago.cancelOrderExchange(exchange, id);
	}
    
	function finalizedDealExchange(address _targetDrago, address exchange, uint24 id) {
		drago.finalizeDealExchange(exchange, id);
	}
	
	function setOwner(address _new) only_owner {
		owner = _new;
		NewOwner(owner, _new);
	}
	
	Drago drago = Drago(_targetDrago);
	string public version = 'DF0.2';
	uint _dragoID = 0;
	uint public fee = 0;
	uint public nextDragoID;
	address public dragoDAO = msg.sender;
	address[] public newDragos;
	address _targetDrago;
	address _dragoRegistry;
	address public owner = msg.sender;
	mapping(address => address[]) public created;
}
