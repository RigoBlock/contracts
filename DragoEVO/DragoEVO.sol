//! Drago contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! These dragos make use of eventful contract.

pragma solidity ^0.4.11;

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

	address owner; // = msg.sender; otherwise cannot set owner at deploy
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
	event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user);
	event OrderPlaced(address indexed cfd, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
    event OrderMatched(address indexed cfd, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
	event OrderCancelled(address indexed cfd, uint32 indexed id, address indexed who, uint128 stake);
	event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user);
	event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
	event DealFinalized(address indexed cfd, address indexed stable, address indexed leveraged, uint64 price);

	// METHODS

	function deposit(address _token, uint256 _amount) payable returns (bool success) {}
	function withdraw(address _token, uint256 _amount) returns (bool success) {}
	function order(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns (uint id) {} //returns(bool success)
	function orderCFD(address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) returns (uint32 id) {} //returns(bool success)
	function trade(address _tokenGet, uint _amountGet, address _tokenGive, uint amountGive, uint expires, address user, uint amount) returns (bool success) {}
	function cancelOrder(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns (bool success) {}
	function cancel(address _cfd, uint32 _id) returns (bool success) {}
	function finalize(address _cfd, uint24 _id) returns (bool success) {}

	function balanceOf(address token, address user) constant returns (uint256) {}
	function balanceOf(address _who) constant returns (uint256) {}
	function marginOf(address _who) constant returns (uint) {}
	function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user) constant returns(uint) {}
	function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user) constant returns(uint) {}
	function getLastOrderId() constant returns (uint) {}
	function isActive(uint id) constant returns (bool) {}
	function getOwner(uint id) constant returns (address) {}
	function getOrder(uint id) constant returns (uint, ERC20, uint, ERC20) {}
}

contract Authority {

    // EVENTS

    event SetAuthority (address indexed authority);
    event SetWhitelister (address indexed whitelister);
    event SetEventful(address indexed eventful);
    event WhitelistedUser(address indexed target, bool approved);
    event WhitelistedAsset(address indexed asset, bool approved);
    event WhitelistedExchange(address indexed exchange, bool approved);
    event WhitelistedRegistry(address indexed registry, bool approved);
    event WhitelistedFactory(address indexed factory, bool approved);
    event NewEventful(address indexed eventful);

    // METHODS

    function setAuthority(address _authority, bool _isWhitelisted) {}
    function setWhitelister(address _whitelister, bool _isWhitelisted) {}
    function whitelistUser(address _target, bool _isWhitelisted) {}
    function whitelistAsset(address _asset, bool _isWhitelisted) {}
    function whitelistExchange(address _exchange, bool _isWhitelisted) {}
    function whitelistDrago(address _drago, bool _isWhitelisted) {}
    function whitelistRegistry(address _registry, bool _isWhitelisted) {}
    function whitelistFactory(address _factory, bool _isWhitelisted) {}
    function setEventful(address _eventful) {}

    function isWhitelistedUser(address _target) constant returns (bool) {}
    function isWhitelister(address _whitelister) constant returns (bool) {}
    function isAuthority(address _authority) constant returns (bool) {}
    function isWhitelistedAsset(address _asset) constant returns (bool) {}
    function isWhitelistedExchange(address _exchange) constant returns (bool) {}
    function isWhitelistedRegistry(address _registry) constant returns (bool) {}
    function isWhitelistedDrago(address _drago) constant returns (bool) {} 
    function isWhitelistedFactory(address _factory) constant returns (bool) {}
    function getEventful() constant returns (address) {}
    function getOwner() constant returns (address) {}
}

contract Eventful {

	// EVENTS

    event BuyDrago(address indexed drago, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event SellDrago(address indexed drago, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event NewNAV(address indexed drago, address indexed from, address indexed to, uint sellPrice, uint buyPrice);
	event DepositExchange(address indexed drago, address indexed exchange, address indexed token, uint value, uint256 amount);
	event WithdrawExchange(address indexed drago, address indexed exchange, address indexed token, uint value, uint256 amount);
	event OrderExchange(address indexed drago, address indexed exchange, address indexed cfd, uint value, uint revenue);
	event TradeExchange(address indexed drago, address indexed exchange, address tokenGet, address tokenGive, uint amountGet, uint amountGive, address get, address give);
	event CancelOrder(address indexed drago, address indexed exchange, address indexed cfd, uint value, uint id);
	event FinalizeDeal(address indexed drago, address indexed exchange, address indexed cfd, uint value, uint id);
	event DragoCreated(address indexed drago, address indexed group, address indexed owner, uint dragoID, string name, string symbol);

    // METHODS

    function buyDrago(address _who, address _targetDrago, uint _value, uint _amount) returns (bool success) {}
    function sellDrago(address _who, address _targetDrago, uint _amount, uint _revenue) returns(bool success) {}
    function setDragoPrice(address _who, address _targetDrago, uint _sellPrice, uint _buyPrice) returns(bool success) {}
    function changeRatio(address _who, address _targetDrago, uint256 _ratio) returns(bool success) {}
    function setTransactionFee(address _who, address _targetDrago, uint _transactionFee) returns(bool success) {}
    function changeFeeCollector(address _who, address _targetDrago, address _feeCollector) returns(bool success) {}
    function changeDragoDAO(address _who, address _targetDrago, address _dragoDAO) returns(bool success) {}
    function depositToExchange(address _who, address _targetDrago, address _exchange, address _token, uint256 _value) returns(bool success) {}
    function withdrawFromExchange(address _who, address _targetDrago, address _exchange, address _token, uint256 _value) returns(bool success) {}
    function placeOrderExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns(bool success) {}
    function placeTradeExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, address _user, uint _amount) returns(bool success) {}
    function placeOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) returns(bool success) {}
    function cancelOrderExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns(bool success) {}
    function cancelOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, uint32 _id) returns(bool success) {}
    function finalizedDealExchange(address _who, address _targetDrago, address _exchange, address _cfd, uint24 _id) returns(bool success) {}
    function createDrago(address _who, address _dragoFactory, address _newDrago, string _name, string _symbol, uint _dragoId, address _owner) returns(bool success) {}
}

contract DragoFace {

	// METHODS

	function buyDrago() payable returns (bool success) {}
	function sellDrago(uint256 _amount) returns (uint revenue, bool success) {}
	function setPrices(uint256 _newSellPrice, uint256 _newBuyPrice) {}
	function changeMinPeriod(uint32 _minPeriod) {}
	function changeRatio(uint256 _ratio) {}
	function setTransactionFee(uint _transactionFee) {}
	function changeFeeCollector(address _feeCollector) {}
	function changeDragoDAO(address _dragoDAO) {}
	function depositToExchange(address _exchange, address _token, uint256 _value) {}
	function withdrawFromExchange(address _exchange, address _token, uint256 _value) {}
	function placeOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) {}
	function placeTradeExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, address _user, uint _amount) {}
	function placeOrderCFDExchange(address _exchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) {}
	function cancelOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) {}
	function cancelOrderCFDExchange(address _exchange, address _cfd, uint32 _id) {}
	function finalizeDealCFDExchange(address _exchange, address _cfd, uint24 _id) {}
	function setOwner(address _new) {}
	function() payable {}   // only_approved_exchange(msg.sender)

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
		//mapping (address => uint) allowanceOf;
		mapping(address => address[]) approvedAccount;
	}

	struct DragoData {
		//address drago;
		string name;
		string symbol;
		uint dragoID;
		uint totalSupply;
		uint sellPrice;
		uint buyPrice;
		uint transactionFee;
		uint32 minPeriod;
	}

	struct Admin {
	    address authority;
		address dragoDAO;
		address feeCollector;
		address eventful;
		uint minOrder; // minimum stake to avoid dust clogging things up
		uint ratio; //ratio is 80%
	}

	modifier only_dragoDAO { if (msg.sender != admin.dragoDAO) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	modifier when_approved_exchange(address _exchange) { Authority auth = Authority(admin.authority); if (auth.isWhitelistedExchange(_exchange)) _; }
	modifier minimum_period_past(uint buyPrice, uint amount) { if (now < accounts[msg.sender].receipt[buyPrice].activation) return; _; }
	modifier minimum_stake(uint amount) { if (amount < admin.minOrder) throw; _; }

	event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);

 	function Drago(string _dragoName,  string _dragoSymbol, uint _dragoID, address _owner, address _authority, address _eventful) {
		data.name = _dragoName;
		data.symbol = _dragoSymbol;
		data.dragoID = _dragoID;
		data.sellPrice = 1 ether;
		data.buyPrice = 1 ether;
		owner = _owner;
		admin.authority = _authority;
		admin.dragoDAO = msg.sender;
		admin.minOrder = 100 finney;
		admin.feeCollector = _owner;
		admin.ratio = 80;
		admin.eventful = _eventful;
	}

	function buyDrago() payable minimum_stake(msg.value) returns (bool success) {
		Eventful events = Eventful(admin.eventful);
		if (!events.buyDrago(msg.sender, this, msg.value, amount)) return;
		uint gross_amount = safeDiv(msg.value, data.buyPrice) * base;
		uint fee = safeMul(gross_amount, data.transactionFee);
		uint fee_drago = safeMul(fee, admin.ratio) / 100;
 		uint fee_dragoDAO = safeSub(fee, fee_drago);
		uint amount = safeSub(gross_amount, fee);
		accounts[msg.sender].balance = safeAdd(accounts[msg.sender].balance, amount);
		accounts[admin.feeCollector].balance = safeAdd(accounts[admin.feeCollector].balance, fee_drago);
		accounts[admin.dragoDAO].balance = safeAdd(accounts[admin.dragoDAO].balance, fee_dragoDAO);
 		accounts[msg.sender].receipt[data.buyPrice].activation = uint32(now) + data.minPeriod;
		data.totalSupply = safeAdd(data.totalSupply, gross_amount);
		return (true);
	}

	function sellDrago(uint256 _amount) minimum_period_past(data.buyPrice, _amount) returns (uint net_revenue, bool success) {
		Eventful events = Eventful(admin.eventful);
		if (!events.sellDrago(msg.sender, this, _amount, net_revenue)) return;
		if (accounts[msg.sender].balance < _amount && accounts[msg.sender].balance + _amount <= accounts[msg.sender].balance) throw;
		uint fee = safeMul (_amount, data.transactionFee);
		uint fee_drago = safeMul(fee, admin.ratio) / 100;
		uint fee_dragoDAO = safeSub(fee, fee_drago);
		uint net_amount = safeSub(_amount, fee);
		net_revenue = safeMul(net_amount, data.sellPrice) / base;
		accounts[msg.sender].balance = safeSub(accounts[msg.sender].balance, _amount);
		accounts[admin.feeCollector].balance = safeAdd(accounts[admin.feeCollector].balance, fee_drago);
		accounts[admin.dragoDAO].balance = safeAdd(accounts[admin.dragoDAO].balance, fee_dragoDAO);
		data.totalSupply = safeSub(data.totalSupply, _amount);
		if (!msg.sender.call.value(net_revenue)()) throw;
		return (net_revenue, true);
	}
	
	function setPrices(uint256 _newSellPrice, uint256 _newBuyPrice) only_owner {
		Eventful events = Eventful(admin.eventful);
		if (!events.setDragoPrice(msg.sender, this, _newSellPrice, _newBuyPrice)) return;
		data.sellPrice = _newSellPrice;
		data.buyPrice = _newBuyPrice;
	}
	
	function changeMinPeriod(uint32 _minPeriod) only_dragoDAO {
		data.minPeriod = _minPeriod;
	}
	
	function changeRatio(uint256 _ratio) only_dragoDAO {
		admin.ratio = safeDiv(_ratio, 100);
	}

	function setTransactionFee(uint _transactionFee) only_owner {
	    //Eventful events = Eventful(admin.eventful);
	    //if (!events.setTransactionFee(msg.sender, this, _transactionFee)) return;
		data.transactionFee = safeDiv(_transactionFee, 10000); //fee is in basis points (1bps=0.01%)
	}

	function changeFeeCollector(address _feeCollector) only_owner {	
		admin.feeCollector = _feeCollector;
		//events.changeFeeCollector(msg.sender, this, _feeCollector);
	}

	function changeDragoDAO(address _dragoDAO) only_dragoDAO {
		admin.dragoDAO = _dragoDAO;
	}

	function depositToExchange(address _exchange, address _token, uint256 _value) only_owner when_approved_exchange(_exchange) {
		Eventful events = Eventful(admin.eventful);
		if (!events.depositToExchange(msg.sender, this, _exchange,  _token, _value)) return;
		Exchange exchange = Exchange(_exchange);
		if (!exchange.deposit.value(_value)(_token, _value)) throw;
	}

	function withdrawFromExchange(address _exchange, address _token, uint256 _value) only_owner when_approved_exchange(_exchange) {
		Eventful events = Eventful(admin.eventful);
	    if (!events.withdrawFromExchange(msg.sender, this, _exchange, _token, _value)) return;
		Exchange exchange = Exchange(_exchange);
		exchange.withdraw(_token, _value); //for ETH token: _token = 0
		//if (!exchange.withdraw(_token, _value)) return; will work only by adding return true; to the exchange
	}
	
	function placeOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) only_owner when_approved_exchange(_exchange) {
		Exchange exchange = Exchange(_exchange);
		exchange.order(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires);
		////events.placeOrderExchange(msg.sender, this, _exchange, _token, _value);
	}

	function placeOrderCFDExchange(address _exchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) only_owner when_approved_exchange(_exchange) {
		Eventful events = Eventful(admin.eventful);
		if (!events.placeOrderCFDExchange(msg.sender, this, _exchange, _cfd, _is_stable, _adjustment, _stake)) throw;
		Exchange exchange = Exchange(_exchange);
		exchange.orderCFD(_cfd, _is_stable, _adjustment, _stake); //condition is checked in eventful
	}
	
	function placeTradeExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, address _user, uint _amount) only_owner when_approved_exchange(_exchange) {
		Exchange exchange = Exchange(_exchange);
		exchange.trade(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _user, _amount);
		//Eventful events = Eventful(admin.eventful);
	    //events.placeTradeExchange(msg.sender, this, _exchange, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce, _user, _amount);
	}
	
	function cancelOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) only_owner when_approved_exchange(_exchange) {
		Exchange exchange = Exchange(_exchange);
		exchange.cancelOrder(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires);
	}

	function cancelOrderCFDExchange(address _exchange, address _cfd, uint32 _id) only_owner when_approved_exchange(_exchange) {
		Eventful events = Eventful(admin.eventful);
		if (!events.cancelOrderCFDExchange(msg.sender, this, _exchange, _cfd, _id)) throw;
		Exchange exchange = Exchange(_exchange);
		exchange.cancel(_cfd, _id);
	}

	function finalizeDealCFDExchange(address _exchange, address _cfd, uint24 _id) only_owner when_approved_exchange(_exchange) {
		Eventful events = Eventful(admin.eventful);
		if (!events.finalizedDealExchange(msg.sender, this, _exchange, _cfd, _id)) throw;
		Exchange exchange = Exchange(_exchange);
		exchange.finalize(_cfd, _id);
	}

	function balanceOf(address _who) constant returns (uint256) {
		return accounts[_who].balance;
	}
	
	function getData() constant returns (string name, string symbol, uint sellPrice, uint buyPrice, uint totalSupply) {
		name = data.name;
		symbol = data.symbol;
		sellPrice = data.sellPrice;
		buyPrice = data.buyPrice;
		totalSupply = data.totalSupply;
	}

	function getAdminData() constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {
		return (admin.feeCollector, admin.dragoDAO, admin.ratio, data.transactionFee, data.minPeriod);
	}

	function() payable when_approved_exchange(msg.sender) {}

	DragoData data;
	Admin admin;
	
	mapping (address => Account) accounts;
	
	string constant version = 'HF 0.2.3';
	uint constant base = 1000000; // tokens are divisible by 1 million
}
