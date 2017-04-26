//! DragoFactory contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

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

contract ERC20 {

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  
	function transfer(address _to, uint256 _value) returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
	function approve(address _spender, uint256 _value) returns (bool success) {}

	function totalSupply() constant returns (uint256) {}
	function balanceOf(address _who) constant returns (uint256) {}
	function allowance(address _owner, address _spender) constant returns (uint256) {}
}

contract Exchange {

	event Deposit(address token, address user, uint amount, uint balance);
    event Withdraw(address token, address user, uint amount, uint balance);
    event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
    event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
    event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);

	// METHODS

	function deposit(address token, uint256 amount) payable {}
	function withdraw(address token, uint256 amount) {}
	function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {}
	function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {}
	function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {}
	
	function balanceOf(address _who) constant returns (uint256) {}
	function balanceOf(address token, address user) constant returns (uint256) {}
	function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {}
    function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {}
	function getLastOrderId() constant returns (uint) {}
	function isActive(uint id) constant returns (bool) {}
	function getOwner(uint id) constant returns (address) {}
	function getOrder(uint id) constant returns (uint, ERC20, uint, ERC20) {}
}

contract CFDExchange {

	// EVENTS
	
	event Deposit(address token, address user, uint amount, uint balance);
  	event Withdraw(address token, address user, uint amount, uint balance);
	event OrderPlaced(address indexed cfd, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	event OrderMatched(address indexed cfd, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(address indexed cfd, uint32 indexed id, address indexed who, uint128 stake);
	event DealFinalized(address indexed cfd, address indexed stable, address indexed leveraged, uint64 price);

	// METHODS

	function deposit() payable {}
	function withdraw(uint256 amount) {}
	function orderCFD(address _cfd, bool is_stable, uint32 adjustment, uint128 stake) {}	//returns(uint id)
	function cancel(address _cfd, uint32 id) {}	//function cancel(uint id) returns (bool) {}
	function finalize(address _cfd, uint24 id) {}
	function moveOrder(address _cfd, uint24 id, bool is_stable, uint32 adjustment) returns (bool) {}

	function balanceOf(address _who) constant returns (uint) {}
	function marginOf(address _who) constant returns (uint) {}
	function balanceOf(address token, address _who) constant returns (uint) {}
	function getLastOrderId() constant returns (uint) {}
	function isActive(uint id) constant returns (bool) {}
	function getOwner(uint id) constant returns (address) {}
	function getBestAdjustment(address _cfd, bool _is_stable) constant returns (uint32) {}
	function getBestAdjustmentFor(address _cfd, bool _is_stable, uint128 _stake) constant returns (uint32) {}
}

contract DragoFace {

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
	function depositToCFDExchange(address _cfdExchange) payable returns(bool success) {}
	function withdrawFromExchange(address exchange, address token, uint256 value) returns (bool success) {}
	function withdrawFromCFDExchange(address _cfdExchange, uint amount) payable returns(bool success) {}
	function placeOrderExchange() {}
	function placeOrderCFDExchange(address _cfdExchange, address _cfd, bool is_stable, uint32 adjustment, uint128 stake) {}
	function cancelOrderExchange() {}
	function cancelOrderCFDExchange(address _cfdExchange, address _cfd, uint32 id) {}	
	function finalizeDealCFDExchange(address _cfdExchange, address _cfd, uint24 id) {}

	function balanceOf(address _from) constant returns (uint256) {}
	function getName() constant returns (string name) {}
	function getSymbol() constant returns (string symbol) {}
	function getPrice() constant returns (uint256 price) {}
	function getTransactionFee() constant returns (uint256 transactionFee) {}
	function getFeeCollector() constant returns (address feeCollector) {}
}

contract Drago is Owned, ERC20, DragoFace {
    
	struct Receipt {
		uint units;
		uint32 activation;
	}
	
	struct Account {
		uint balance;
		mapping (uint => Receipt) receipt;
		mapping (address => uint) allowanceOf;
	}
	
	modifier only_dragator { if (msg.sender != dragator) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	//modifier when_approved_exchange { if (exchange != approved) return; _; }
	modifier minimum_period_past(uint buyPrice, uint amount) { if (now < accounts[msg.sender].receipt[buyPrice].activation) return; _; }

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	
 	function Drago(string _dragoName,  string _dragoSymbol) {
        	name = _dragoName;  
        	symbol = _dragoSymbol;
	}
    
	function() payable {
		buyDrago();
	}
	
	//TODO: separate function and its specifics
	function buyDrago() payable returns (uint amount) {
	//TODO: introduce safemath
		//if (!approvedAccount[msg.sender]) throw;
		if (msg.value < min_order) throw;
        	gross_amount = msg.value / buyPrice;
        	fee = gross_amount * transactionFee / (100 ether);
        	fee_dragoo = fee * 80 / 100;
        	fee_dragator = fee - fee_dragoo;
        	amount = gross_amount - fee;
        	balances[msg.sender] += amount;
        	balances[feeCollector] += fee_dragoo;
        	balances[dragator] += fee_dragator;
        	accounts[msg.sender].receipt[buyPrice].activation = uint32(now) + refundActivationPeriod;
        	totalSupply += gross_amount;
    		Buy(msg.sender, this, msg.value, amount);
    		return amount;
	}
	
	function sellDrago(uint256 amount) minimum_period_past(buyPrice, amount) returns (uint revenue, bool success) {
		//TODO: execute redemption only 2 days after sell
		//TODO: introduce safemath
		//if (!approvedAccount[msg.sender]) throw;
		revenue = /*safeMul(*/amount * sellPrice/*)*/;
        	if (balances[msg.sender] >= amount && balances[msg.sender] + amount > balances[msg.sender] && revenue >= min_order) {
            	balances[msg.sender] -= amount;
            	totalSupply -= amount;
		if (!msg.sender.send(revenue)) {
			throw;
			} else { 
				Sell(this, msg.sender, amount, revenue);
			}
			return (revenue, true);
		} else { return (revenue, false); }
	}
	
	function changeRefundActivationPeriod(uint32 _refundActivationPeriod) only_dragator {
	//	refundActivationPeriod = _refundActivationPeriod;
	}
	
	function changeRatio(uint256 _ratio) only_dragator {
		ratio = _ratio;
	}
	
	function setTransactionFee(uint _transactionFee) only_owner {   // 1 ==> 1 bps = 0.01%
		transactionFee = _transactionFee * (10 ** 18) / (1 ether);	//fee in basis points
	}
	
	function changeFeeCollector(address _feeCollector) only_owner {	
	        feeCollector = _feeCollector; 
	}
	
	function changeDragator(address _dragator) only_dragator {
        	dragator = _dragator;
	}
    
	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) only_owner {
        	sellPrice = newSellPrice*(10**(18 - 4));
        	buyPrice = newBuyPrice*(10**(18 - 4));
	}

	function depositToExchange(address _exchange, address token, uint256 value) /*when_approved_exchange*/ only_owner payable returns(bool success) {
		//address who used to determine from which account _who is the drago contract
		//exchange.deposit.value(msg.value)(_who);
		exchange.deposit.value(msg.value)(token, value);
	}
	
	function depositToCFDExchange(address _cfdExchange) /*when_approved_exchange*/ /*only_drago_owner*/ payable returns(bool success) {
	    CFDExchange cfds = CFDExchange(_cfdExchange);
	    cfds.deposit.value(msg.value);
	}
	
	function withdrawFromExchange(address _exchange, address token, uint256 value) only_owner returns (bool success) {
		//if(!exchange.withdraw(value)) throw;
		exchange.withdraw(token, value); //for ETH token = 0
	}
	
	function withdrawFromCFDExchange(address _cfdExchange, uint amount) /*when_approved_exchange*/ /*only_drago_owner*/ payable returns(bool success) {
	    CFDExchange cfds = CFDExchange(_cfdExchange);
	    cfds.withdraw(amount);
	}
	
	function placeOrderCFDExchange(address _cfdExchange, address _cfd, bool is_stable, uint32 adjustment, uint128 stake) only_owner {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		cfds.orderCFD(_cfd, is_stable, adjustment, stake);
	}
	
	function cancelOrderCFDExchange(address _cfdExchange, address _cfd, uint32 id) only_owner {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		cfds.cancel(_cfd, id);
	}	
	
	function finalizeDealCFDExchange(address _cfdExchange, address _cfd, uint24 id) only_owner {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		cfds.finalize(_cfd, id);
	}

	function balanceOf(address _who) constant returns (uint256) {
		return balances[_who];
	}
	
	Exchange exchange = Exchange(_exchange);
	string public name;
	string public symbol;
	string public version = 'H0.2';
	uint256 public totalSupply = 0;
	uint256 public sellPrice = 1 finney;
	uint256 public buyPrice = 1 finney;
	uint256 public transactionFee = 0; //in basis points (1bps=0.01%)
	uint min_order = 100 finney; // minimum stake to avoid dust clogging things up
	address public feeCollector = msg.sender;
	address public dragator = msg.sender;
	address public owner = msg.sender;
	address _exchange;
	address[] _cfdExchange; //double check whether array or single one (array upgradeable)
	uint gross_amount;
	uint fee;
	uint fee_dragoo;
	uint fee_dragator;
	uint256 public ratio = 80;
	uint32 constant refundActivationPeriod = 2 days;
	mapping (address => uint256) public balances;
	mapping(address => address[]) public approvedAccount;
	mapping (address => Account) accounts;
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

contract DragoFactoryFace {

	event DragoCreated(string _name, address _drago, address _dragowner, uint _dragoID);

	function createDrago(string _name, string _symbol, address _dragowner) returns (address _drago, uint _dragoID) {}
	function setFee(uint _fee) {}
	function setBeneficiary(address _dragoDAO) {}
	function drain() {}
	function() {}
	function changeRatio(address targetDrago, uint256 _ratio) {}
	function setTransactionFee(address targetDrago, uint _transactionFee) {}
	function changeFeeCollector(address targetDrago, address _feeCollector) {}
	function changeDragator(address targetDrago, address _dragator) {}

	function getVersion() constant returns (string) {}
	function getLastId() constant returns (uint) {}
	function getDragoDAO() constant returns (uint) {}
}

contract DragoFactory is Owned, DragoFactoryFace {
    
	modifier when_fee_paid { if (msg.value < fee) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	//modifier only_drago_dao  if (msg.sender != dragoDao) return; _; }
	
	event DragoCreated(string _name, address _drago, address _dragowner, uint _dragoID);
    //event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	//event Sell(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);

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
	
	function registerDrago(address _drago, uint _dragoID, address _dragoRegistry) internal only_owner {
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
	}   //double check whether this is needed in DragoAdmin.sol
    
	function drain() only_owner {
		if (!dragoDAO.send(this.balance)) throw;
	}
    
	function() {
		throw;
	}
	
	string public version = 'DF0.2';
	uint _dragoID = 0;
	uint public fee = 0;
	uint public nextDragoID;
	address public dragoDAO = msg.sender;
	address[] public newDragos;
	address _dragoRegistry;
	address public owner = msg.sender;
	mapping(address => address[]) public created;
}
