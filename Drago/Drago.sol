//! Drago contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Owned {
	event NewOwner(address indexed old, address indexed current);
	function setOwner(address _new) {}
	function getOwner() constant returns (address owner) {}
}

contract ERC20Face is Owned {

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  
	function transfer(address _to, uint256 _value) returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
	function approve(address _spender, uint256 _value) returns (bool success) {}

	function totalSupply() constant returns (uint256 total) {}
	function balanceOf(address _who) constant returns (uint256 balance) {}
	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
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
	function orderCFD(bool is_stable, uint32 adjustment, uint128 stake) payable {}	//returns(uint id)
	function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {}
	function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {}
	function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {}
	function cancel(uint32 id) {}	//function cancel(uint id) returns (bool) {}
	function finalize(uint24 id) {}
	function moveOrder(uint id, uint quantity) returns (bool) {}
	
	function balanceOf(address _who) constant returns (uint256) {}
	function balanceOf(address token, address user) constant returns (uint256) {}
	function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {}
    	function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {}
    	
	function getLastOrderId() constant returns (uint) {}
	function isActive(uint id) constant returns (bool active) {}
	function getOwner(uint id) constant returns (address owner) {}
	//function getOrder(uint id) constant returns (uint, ERC20, uint, ERC20) {}
    	//mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
    	//mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
    	//mapping (address => mapping (bytes32 => uint)) public orderFills;
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

contract Drago is Owned, ERC20Face, DragoFace {
    
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
	
	function withdrawFromExchange(address _exchange, address token, uint256 value) only_owner returns (bool success) {
		//if(!exchange.withdraw(value)) throw;
		exchange.withdraw(token, value); //for ETH token = 0
	}
	
	function placeOrderExchange(address _exchange, bool is_stable, uint32 adjustment, uint128 stake) only_owner {
		exchange.orderCFD(is_stable, adjustment, stake);
	}	
	
	function cancelOrderExchange(address _exchange, uint32 id) only_owner {
		exchange.cancel(id);
	}	
	
	function finalizeDealExchange(address _exchange, uint24 id) only_owner {
		exchange.finalize(id);
	}

	function balanceOf(address _from) constant returns (uint256 balance) {
		return balances[_from];
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
