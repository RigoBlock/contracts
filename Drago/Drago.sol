//! Drago contract.
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

contract SafeMath {

	function safeMul(uint a, uint b) internal returns (uint) {
		uint c = a * b;
		assert(a == 0 || c / a == b);
		return c;
	}
    
	function safeDiv(uint a, uint b) internal returns (uint) {
		assert(b > 0);
		uint c = a / b;
		assert(a == b * c + a % b);
		return c;
	}

	function safeSub(uint a, uint b) internal returns (uint) {
		assert(b <= a);
		return a - b;
	}

	function safeAdd(uint a, uint b) internal returns (uint) {
		uint c = a + b;
		assert(c>=a && c>=b);
		return c;
	}
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
    
	// EVENTS

	event Deposit(address token, address user, uint amount, uint balance);
	event Withdraw(address token, address user, uint amount, uint balance);
	event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
	event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
	event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);

	// METHODS

	function deposit(address token, uint256 amount) payable returns (bool success) {}
	function withdraw(address token, uint256 amount) returns (bool success) {}
	function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {}
	function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {}
	function cancelOrder(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {}
	
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

	function deposit() payable returns (bool success) {}
	function withdraw(uint256 amount) returns (bool success) {}
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
    
	// METHODS

 	function Drago(string _dragoName,  string _dragoSymbol, uint _dragoID) {}
	function buyDrago() payable returns (bool success) {}
	function sellDrago(uint256 _amount) returns (uint revenue, bool success) {}
	function setPrices(uint256 _newSellPrice, uint256 _newBuyPrice) {}
	function changeMinPeriod(uint32 _minPeriod) {}
	function changeRatio(uint256 _ratio) {}
	function setTransactionFee(uint _transactionFee) {}
	function changeFeeCollector(address _feeCollector) {}
	function changeDragator(address _dragoDAO) {}
	function depositToExchange(address _exchange, address _token, uint256 _value) payable returns(bool success) {}
	function depositToCFDExchange(address _cfdExchange, uint256 _value) payable returns(bool success) {}
	function withdrawFromExchange(address _exchange, address _token, uint256 _value) returns (bool success) {}
	function withdrawFromCFDExchange(address _cfdExchange, uint _amount) returns(bool success) {}
	function placeOrderExchange(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {}
	function placeTradeExchange(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce, address _user, uint8 _v, bytes32 _r, bytes32 _s, uint _amount) {}
	function placeOrderCFDExchange(address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) {}
	function cancelOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {}
	function cancelOrderCFDExchange(address _cfdExchange, address _cfd, uint32 _id) {}	
	function finalizeDealCFDExchange(address _cfdExchange, address _cfd, uint24 _id) {}
	function setOwner(address _new) {}

	function balanceOf(address _who) constant returns (uint256) {}
	function getData() constant returns (string name, string symbol, uint sellPrice, uint buyPrice, uint totalSupply) {}
	function getAdminData() constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {}
	function getOwner() constant returns (address) {}
}

contract Drago is Owned, ERC20, SafeMath, DragoFace {
    
	struct Receipt {
		uint units;
		uint32 activation;
	}
	
	struct Account {
		uint balance;
		mapping (uint => Receipt) receipt;
		mapping (address => uint) allowanceOf;
		mapping(address => address[]) approvedAccount;
		//mapping (address => uint256) balances;
		//address[] cfdExchange; //array of exchanges
	}
	
	struct DragoData {
		address drago;
		address owner;
		string name;
		string symbol;
		uint dragoID;
		uint totalSupply;
		uint sellPrice;
		uint buyPrice;
		uint transactionFee;
		uint32 minPeriod;
		address dragoDAO;
		mapping (address => uint256) balances;
	}
	
	modifier only_dragoDAO { if (msg.sender != data.dragoDAO) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	//modifier when_approved_exchange { if (exchange != approved) return; _; }
	modifier minimum_period_past(uint buyPrice, uint amount) { if (now < accounts[msg.sender].receipt[buyPrice].activation) return; _; }
	modifier minimum_stake(uint amount) { if (amount < min_order) throw; _; }

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event NAV(uint sellPrice, uint buyPrice);
	event DepositExchange(uint value, uint256 indexed _amount, address indexed who, address token , address indexed _exchange);
	event DepositCFDExchange(uint , uint256 indexed _amount, address indexed who, address , address indexed _cfdExchange);
	event WithdrawExchange(uint , uint256 indexed _amount, address indexed who, address , address indexed _cfdExchange);
	event WithdrawCFDExchange(uint , uint256 indexed _amount, address indexed who, address , address indexed _cfdExchange);
	event OrderCFD(address indexed _cfdExchange, address indexed _cfd);
	event CancelCFD(address indexed _cfdExchange, address indexed _cfd);
	event FinalizeCFD(address indexed _cfdExchange, address indexed _cfd);

 	function Drago(string _dragoName,  string _dragoSymbol, uint _dragoID) {
		data.name = _dragoName;
		data.symbol = _dragoSymbol;
		data.dragoID = _dragoID;
		data.sellPrice = 1 ether;
		data.buyPrice = 1 ether;
	}

	function buyDrago() payable minimum_stake(msg.value) returns (bool success) {
		//if (!approvedAccount[msg.sender]) throw; //or separate whitelisted
		uint gross_amount = safeDiv(msg.value, data.buyPrice) * base;
        	uint fee = safeMul(gross_amount, data.transactionFee);
        	uint fee_drago = safeMul(fee, ratio);
        	uint fee_dragoDAO = safeSub(fee, fee_drago);
        	uint amount = safeSub(gross_amount, fee);
        	data.balances[msg.sender] = safeAdd(data.balances[msg.sender], amount);
        	data.balances[feeCollector] = safeAdd(data.balances[feeCollector], fee_drago);
        	data.balances[data.dragoDAO] = safeAdd(data.balances[data.dragoDAO], fee_dragoDAO);
        	accounts[msg.sender].receipt[data.buyPrice].activation = uint32(now) + data.minPeriod;
        	data.totalSupply = safeAdd(data.totalSupply, gross_amount);
        	Buy(msg.sender, this, msg.value, amount);
    		return (true);
	}

	function sellDrago(uint256 _amount) minimum_period_past(data.buyPrice, _amount) minimum_stake(net_revenue) returns (uint net_revenue, bool success) {
		//if (!approvedAccount[msg.sender]) throw;
		if (data.balances[msg.sender] < _amount && data.balances[msg.sender] + _amount <= data.balances[msg.sender]) throw;
		uint gross_amount = _amount;
		uint fee = safeMul (gross_amount, data.transactionFee);
		uint fee_drago = safeMul(fee, ratio);
        	uint fee_dragoDAO = safeSub(fee, fee_drago);
		uint net_amount = safeSub(gross_amount, fee);
		net_revenue = safeMul(net_amount, data.sellPrice) / base;
        	data.balances[msg.sender] = safeSub(data.balances[msg.sender], _amount);
        	data.balances[feeCollector] = safeAdd(data.balances[feeCollector], fee_drago);
        	data.balances[data.dragoDAO] = safeAdd(data.balances[data.dragoDAO], fee_dragoDAO);
        	data.totalSupply = safeSub(data.totalSupply, _amount);
		if (!msg.sender.send(net_revenue)) throw;
		Sell(this, msg.sender, _amount, net_revenue);
		return (net_revenue, true);
	}
	
	function setPrices(uint256 _newSellPrice, uint256 _newBuyPrice) only_owner {
        	data.sellPrice = _newSellPrice;
            	data.buyPrice = _newBuyPrice;
	}
	
	function changeMinPeriod(uint32 _minPeriod) only_dragoDAO {
		data.minPeriod = _minPeriod;
	}
	
	function changeRatio(uint256 _ratio) only_dragoDAO {
		ratio = safeDiv(_ratio, 100);
	}
	
	function setTransactionFee(uint _transactionFee) only_owner {
		data.transactionFee = safeDiv(_transactionFee, 10000); //fee is in basis points (1bps=0.01%)
	}
	
	function changeFeeCollector(address _feeCollector) only_owner {	
		feeCollector = _feeCollector; 
	}
	
	function changeDragoDAO(address _dragoDAO) only_dragoDAO {
    		data.dragoDAO = _dragoDAO;
	}

	function depositToExchange(address _exchange, address _token, uint256 _value) /*when_approved_exchange*/ only_owner payable returns(bool success) {
		Exchange exchange = Exchange(_exchange);
		assert(exchange.deposit.value(_value)(_token, _value));
	}

	function depositToCFDExchange(address _cfdExchange, uint256 _value) /*when_approved_exchange*/ only_owner payable returns(bool success) {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		assert(cfds.deposit.value(_value)());
		return true;
	}

	function withdrawFromExchange(address _exchange, address _token, uint256 _value) only_owner returns (bool success) {
		Exchange exchange = Exchange(_exchange);
		assert(exchange.withdraw(_token, _value)); //for ETH token = 0
	}

	function withdrawFromCFDExchange(address _cfdExchange, uint _amount) /*when_approved_exchange*/ only_owner returns(bool success) {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		assert(cfds.withdraw(_amount));
	}
	
	function placeOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {
	    	Exchange exchange = Exchange(_exchange);
	    	exchange.order(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce);
	}

	function placeOrderCFDExchange(address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) only_owner {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		cfds.orderCFD(_cfd, _is_stable, _adjustment, _stake);
	}
	
	function placeTradeExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce, address _user, uint8 _v, bytes32 _r, bytes32 _s, uint _amount) {
	    	Exchange exchange = Exchange(_exchange);
	    	exchange.trade(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce, _user, _v, _r, _s, _amount);
	}
	
	function cancelOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
	    	Exchange exchange = Exchange(_exchange);
	    	exchange.cancelOrder(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, nonce, v, r, s);
	}

	function cancelOrderCFDExchange(address _cfdExchange, address _cfd, uint32 _id) only_owner {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		cfds.cancel(_cfd, _id);
	}

	function finalizeDealCFDExchange(address _cfdExchange, address _cfd, uint24 _id) only_owner {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		cfds.finalize(_cfd, _id);
	}

	function balanceOf(address _who) constant returns (uint256) {
		return data.balances[_who];
	}
	
	function getData() constant returns (string name, string symbol, uint sellPrice, uint buyPrice, uint totalSupply) {
		name = data.name;
		symbol = data.symbol;
		sellPrice = sellPrice;
		buyPrice = buyPrice;
		totalSupply = totalSupply;
	}
	
	function getAdminData() constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {
	    	return (feeCollector, data.dragoDAO, ratio, transactionFee, minPeriod);
	}

	DragoData data;
	
	string public version = 'H0.3';
	uint public base = 1000000;    // tokens are divisible by 1 million
	uint min_order = 100 finney; // minimum stake to avoid dust clogging things up
	uint256 public ratio = safeDiv(80, 100) ; //ratio is 80%
	address public feeCollector = msg.sender;
	mapping (address => Account) accounts;
}
