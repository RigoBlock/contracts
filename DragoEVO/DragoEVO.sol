//! Drago contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! These dragos make use of eventful contract.

pragma solidity ^0.4.16;

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

	// METHODS

	function deposit(address _token, uint _amount) payable returns (bool success) {}
	function withdraw(address _token, uint _amount) returns (bool success) {}
	function order(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns (uint id) {}
	function orderCFD(address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) returns (uint32 id) {}
	function trade(address _tokenGet, uint _amountGet, address _tokenGive, uint amountGive, uint expires, address user, uint amount) {}
	function cancelOrder(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) {}
	function cancel(address _cfd, uint32 _id) {}
	function finalize(address _cfd, uint24 _id) {}

	function balanceOf(address token, address user) constant returns (uint) {}
	function balanceOf(address _who) constant returns (uint) {}
	function marginOf(address _who) constant returns (uint) {}
	function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user) constant returns(uint) {}
	function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user) constant returns(uint) {}
	function getLastOrderId() constant returns (uint) {}
	function isActive(uint id) constant returns (bool) {}
	function getOwner(uint id) constant returns (address) {}
	function getOrder(uint id) constant returns (uint, ERC20, uint, ERC20) {}
	
    //this is the 0x interface
    //now checking that it fits
    
    // EVENTS

    event LogFill(address indexed maker, address taker, address indexed feeRecipient, address makerToken, address takerToken, uint filledMakerTokenAmount, uint filledTakerTokenAmount, uint paidMakerFee, uint paidTakerFee, bytes32 indexed tokens, bytes32 orderHash );
    event LogCancel(address indexed maker, address indexed feeRecipient, address makerToken, address takerToken, uint cancelledMakerTokenAmount, uint cancelledTakerTokenAmount, bytes32 indexed tokens, bytes32 orderHash );
    event LogError(uint8 indexed errorId, bytes32 indexed orderHash);

    // NON-CONSTANT METHODS

    function fillOrder(address[5] orderAddresses, uint[6] orderValues, uint fillTakerTokenAmount, bool shouldThrowOnInsufficientBalanceOrAllowance, uint8 v, bytes32 r, bytes32 s) returns (uint filledTakerTokenAmount) {}
    function cancelOrder(address[5] orderAddresses, uint[6] orderValues, uint cancelTakerTokenAmount) returns (uint) {}
    function fillOrKillOrder(address[5] orderAddresses, uint[6] orderValues, uint fillTakerTokenAmount, uint8 v, bytes32 r, bytes32 s) {}
    function batchFillOrders(address[5][] orderAddresses, uint[6][] orderValues, uint[] fillTakerTokenAmounts, bool shouldThrowOnInsufficientBalanceOrAllowance, uint8[] v, bytes32[] r, bytes32[] s) {}
    function batchFillOrKillOrders(address[5][] orderAddresses, uint[6][] orderValues, uint[] fillTakerTokenAmounts, uint8[] v, bytes32[] r, bytes32[] s) {}
    function fillOrdersUpTo(address[5][] orderAddresses, uint[6][] orderValues, uint fillTakerTokenAmount, bool shouldThrowOnInsufficientBalanceOrAllowance, uint8[] v, bytes32[] r, bytes32[] s) returns (uint) {}
    function batchCancelOrders(address[5][] orderAddresses, uint[6][] orderValues, uint[] cancelTakerTokenAmounts) {}

    // CONSTANT METHODS

    function getOrderHash(address[5] orderAddresses, uint[6] orderValues) constant returns (bytes32) {}
    function isValidSignature( address signer, bytes32 hash, uint8 v, bytes32 r, bytes32 s) constant returns (bool) {}
    function isRoundingError(uint numerator, uint denominator, uint target) constant returns (bool) {}
    function getPartialAmount(uint numerator, uint denominator, uint target) constant returns (uint) {}
    function getUnavailableTakerTokenAmount(bytes32 orderHash) constant returns (uint) {}
}

contract Authority {

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

    // METHODS

    function buyDrago(address _who, address _targetDrago, uint _value, uint _amount) returns (bool success) {}
    function sellDrago(address _who, address _targetDrago, uint _amount, uint _revenue) returns(bool success) {}
    function setDragoPrice(address _who, address _targetDrago, uint _sellPrice, uint _buyPrice) returns(bool success) {}
    function changeRatio(address _who, address _targetDrago, uint256 _ratio) returns(bool success) {}
    function setTransactionFee(address _who, address _targetDrago, uint _transactionFee) returns(bool success) {}
    function changeFeeCollector(address _who, address _targetDrago, address _feeCollector) returns(bool success) {}
    function changeDragoDAO(address _who, address _targetDrago, address _dragoDAO) returns(bool success) {}
    function depositToExchange(address _who, address _targetDrago, address _exchange, address _token, uint _value) returns(bool success) {}
    function withdrawFromExchange(address _who, address _targetDrago, address _exchange, address _token, uint _value) returns(bool success) {}
    //function placeOrderExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns(bool success) {}
    function placeOrderExchange(address _exchange, address[5] orderAddresses, uint[6] orderValues, uint fillTakerTokenAmount) returns(bool success) {}
    function placeOrderExchange(address _exchange, address[5][] orderAddresses, uint[6][] orderValues, uint[] fillTakerTokenAmount) returns(bool success) {}
    function placeOrderExchange(address _exchange, address[5][] orderAddresses, uint[6][] orderValues, uint fillTakerTokenAmount) returns(bool success) {}
    //function placeTradeExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, address _user, uint _amount) returns(bool success) {}
    function placeOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) returns(bool success) {}
    function cancelOrderExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns(bool success) {}
    function cancelOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, uint32 _id) returns(bool success) {}
    function finalizedDealExchange(address _who, address _targetDrago, address _exchange, address _cfd, uint24 _id) returns(bool success) {}
    function createDrago(address _who, address _dragoFactory, address _newDrago, string _name, string _symbol, uint _dragoId, address _owner) returns(bool success) {}
}

contract DragoFace {

	// METHODS

	function buyDrago() payable returns (bool success) {}
	function sellDrago(uint _amount) returns (uint revenue, bool success) {}
	function setPrices(uint _newSellPrice, uint _newBuyPrice) {}
	function changeMinPeriod(uint32 _minPeriod) {}
	function changeRatio(uint _ratio) {}
	function setTransactionFee(uint _transactionFee) {}
	function changeFeeCollector(address _feeCollector) {}
	function changeDragoDAO(address _dragoDAO) {}
	function depositToExchange(address _exchange, address _token, uint _value) {}
	function withdrawFromExchange(address _exchange, address _token, uint _value) {}
	//function placeOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) {}
	//function placeTradeExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, address _user, uint _amount) {}
	function placeOrderCFDExchange(address _exchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) {}
	//function cancelOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) {}
	function cancelOrderCFDExchange(address _exchange, address _cfd, uint32 _id) {}
	function finalizeDealCFDExchange(address _exchange, address _cfd, uint24 _id) {}
	function setOwner(address _new) {}
	function() payable {}   // only_approved_exchange(msg.sender)

	function balanceOf(address _who) constant returns (uint) {}
	function getEventful() constant returns (address) {}
	function getData() constant returns (string name, string symbol, uint sellPrice, uint buyPrice) {}
	function getAdminData() constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {}
	function getOwner() constant returns (address) {}
	function totalSupply() constant returns (uint256) {}
}

contract Drago is Owned, ERC20, SafeMath, DragoFace {
    
	struct Receipt {
		uint units;
		uint32 activation;
	}
	
	struct Account {
		uint balance;
		//mapping (uint => Receipt) receipt;
		Receipt receipt;
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
		uint minOrder; // minimum stake to avoid dust clogging things up
		uint ratio; //ratio is 80%
	}

	modifier only_dragoDAO { if (msg.sender != admin.dragoDAO) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	modifier when_approved_exchange(address _exchange) { Authority auth = Authority(admin.authority); if (auth.isWhitelistedExchange(_exchange)) _; }
	modifier minimum_stake(uint amount) { if (amount < admin.minOrder) throw; _; }
    modifier minimum_period_past { if (now < accounts[msg.sender].receipt.activation) return; _; }
    //modifier minimum_period_past(uint buyPrice, uint amount) { if (now < accounts[msg.sender].receipt[buyPrice].activation) return; _; }

	event Buy(address indexed from, address indexed to, uint indexed _amount, uint _revenue);
	event Sell(address indexed from, address indexed to, uint indexed _amount, uint _revenue);

 	function Drago(string _dragoName,  string _dragoSymbol, uint _dragoID, address _owner, address _authority) {
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
	}

	function buyDrago() payable minimum_stake(msg.value) returns (bool success) {
		uint gross_amount = safeDiv(msg.value * base, data.buyPrice);
		uint fee = safeMul(gross_amount, data.transactionFee);
		uint fee_drago = safeMul(fee, admin.ratio) / 100;
 		uint fee_dragoDAO = safeSub(fee, fee_drago);
		uint amount = safeSub(gross_amount, fee);
		Eventful events = Eventful(getEventful());
		require(events.buyDrago(msg.sender, this, msg.value, amount));
		accounts[msg.sender].balance = safeAdd(accounts[msg.sender].balance, amount);
		accounts[admin.feeCollector].balance = safeAdd(accounts[admin.feeCollector].balance, fee_drago);
		accounts[admin.dragoDAO].balance = safeAdd(accounts[admin.dragoDAO].balance, fee_dragoDAO);
 		accounts[msg.sender].receipt.activation = uint32(now) + data.minPeriod;
		data.totalSupply = safeAdd(data.totalSupply, gross_amount);
		return (true);
	}

	function sellDrago(uint _amount) minimum_period_past returns (uint net_revenue, bool success) {
		if (accounts[msg.sender].balance < _amount || accounts[msg.sender].balance + _amount <= accounts[msg.sender].balance) throw;
		uint fee = safeMul (_amount, data.transactionFee);
		uint fee_drago = safeMul(fee, admin.ratio) / 100;
		uint fee_dragoDAO = safeSub(fee, fee_drago);
		uint net_amount = safeSub(_amount, fee);
		Eventful events = Eventful(getEventful());
		net_revenue = safeMul(net_amount, data.sellPrice) / base;
		if (!events.sellDrago(msg.sender, this, _amount, net_revenue)) return;
		accounts[msg.sender].balance = safeSub(accounts[msg.sender].balance, _amount);
		accounts[admin.feeCollector].balance = safeAdd(accounts[admin.feeCollector].balance, fee_drago);
		accounts[admin.dragoDAO].balance = safeAdd(accounts[admin.dragoDAO].balance, fee_dragoDAO);
		data.totalSupply = safeSub(data.totalSupply, net_amount);
		require(msg.sender.call.value(net_revenue)());
		return (net_revenue, true);
	}
	
	function setPrices(uint _newSellPrice, uint _newBuyPrice) only_owner {
		Eventful events = Eventful(getEventful());
		if (!events.setDragoPrice(msg.sender, this, _newSellPrice, _newBuyPrice)) return;
		data.sellPrice = _newSellPrice;
		data.buyPrice = _newBuyPrice;
	}
	
	function changeMinPeriod(uint32 _minPeriod) only_dragoDAO {
		data.minPeriod = _minPeriod;
	}
	
	function changeRatio(uint _ratio) only_dragoDAO {
		admin.ratio = safeDiv(_ratio, 100);
	}

	function setTransactionFee(uint _transactionFee) only_owner {
	    //Eventful events = Eventful(getEventful());
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

	function depositToExchange(address _exchange, address _token, uint _value) only_owner when_approved_exchange(_exchange) {
		Eventful events = Eventful(getEventful());
		require(events.depositToExchange(msg.sender, this, _exchange,  _token, _value));
		Exchange exchange = Exchange(_exchange);
		require(exchange.deposit.value(_value)(_token, _value));
	}

	function withdrawFromExchange(address _exchange, address _token, uint _value) only_owner when_approved_exchange(_exchange) {
		Eventful events = Eventful(getEventful());
	    require(events.withdrawFromExchange(msg.sender, this, _exchange, _token, _value)); //this was a return
		Exchange exchange = Exchange(_exchange);
		require(exchange.withdraw(_token, _value)); //for ETH token: _token = 0
		//if (!exchange.withdraw(_token, _value)) return; will work only by adding return true; to the exchange
	}

	//function placeOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) only_owner when_approved_exchange(_exchange) {
	function placeOrderExchange(address _exchange, address[5] orderAddresses, uint[6] orderValues, uint fillTakerTokenAmount, bool shouldThrowOnInsufficientBalanceOrAllowance, uint8 v, bytes32 r, bytes32 s) only_owner when_approved_exchange(_exchange) { 
		Eventful events = Eventful(getEventful());
		//require(events.placeOrderExchange(msg.sender, this, _exchange, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires)); //this was a return
		require(events.placeOrderExchange(_exchange, orderAddresses, orderValues, fillTakerTokenAmount));
		Exchange exchange = Exchange(_exchange);
		//exchange.order(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires);
        //exchange.order(orderAddresses[1], orderValues[1], orderAddresses[2], orderValues[2], 0);
		exchange.fillOrder(orderAddresses, orderValues, fillTakerTokenAmount, shouldThrowOnInsufficientBalanceOrAllowance, v, r, s);
		////events.placeOrderExchange(msg.sender, this, _exchange, _token, _value);
	}

	function placeOrderExchange(address _exchange, address[5] orderAddresses, uint[6] orderValues, uint fillTakerTokenAmount, uint8 v, bytes32 r, bytes32 s) only_owner when_approved_exchange(_exchange) { 
		Eventful events = Eventful(getEventful());
		require(events.placeOrderExchange(_exchange, orderAddresses, orderValues, fillTakerTokenAmount)); //this was a return
		Exchange exchange = Exchange(_exchange);
		exchange.fillOrKillOrder(orderAddresses, orderValues, fillTakerTokenAmount, v, r, s);
	}

	function placeOrderExchange(address _exchange, address[5][] orderAddresses, uint[6][] orderValues, uint[] fillTakerTokenAmounts, bool shouldThrowOnInsufficientBalanceOrAllowance, uint8[] v, bytes32[] r, bytes32[] s) only_owner when_approved_exchange(_exchange) { 
		Eventful events = Eventful(getEventful());
		require(events.placeOrderExchange(_exchange, orderAddresses, orderValues, fillTakerTokenAmounts)); //this was a return
		Exchange exchange = Exchange(_exchange);
		exchange.batchFillOrders(orderAddresses, orderValues, fillTakerTokenAmounts, shouldThrowOnInsufficientBalanceOrAllowance, v, r, s);
	}
	
	function placeOrderExchange(address _exchange, address[5][] orderAddresses, uint[6][] orderValues, uint[] fillTakerTokenAmounts, uint8[] v, bytes32[] r, bytes32[] s) only_owner when_approved_exchange(_exchange) { 
		Eventful events = Eventful(getEventful());
		require(events.placeOrderExchange(_exchange, orderAddresses, orderValues, fillTakerTokenAmounts)); //this was a return
		Exchange exchange = Exchange(_exchange);
		exchange.batchFillOrKillOrders(orderAddresses, orderValues, fillTakerTokenAmounts, v, r, s);
	}
	
	function placeOrderExchange(address _exchange, address[5][] orderAddresses, uint[6][] orderValues, uint fillTakerTokenAmount, bool shouldThrowOnInsufficientBalanceOrAllowance, uint8[] v, bytes32[] r, bytes32[] s) only_owner when_approved_exchange(_exchange) { 
		Eventful events = Eventful(getEventful());
		require(events.placeOrderExchange(_exchange, orderAddresses, orderValues, fillTakerTokenAmount)); //this was a return
		Exchange exchange = Exchange(_exchange);
		exchange.fillOrdersUpTo(orderAddresses, orderValues, fillTakerTokenAmount, shouldThrowOnInsufficientBalanceOrAllowance, v, r, s);
	}

	function placeOrderCFDExchange(address _exchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) only_owner when_approved_exchange(_exchange) {
		Eventful events = Eventful(getEventful());
		require(events.placeOrderCFDExchange(msg.sender, this, _exchange, _cfd, _is_stable, _adjustment, _stake));
		Exchange exchange = Exchange(_exchange);
		exchange.orderCFD(_cfd, _is_stable, _adjustment, _stake); //condition is checked in eventful
	}

/*
	function placeTradeExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, address _user, uint _amount) only_owner when_approved_exchange(_exchange) {
		Eventful events = Eventful(getEventful());
	    events.placeTradeExchange(msg.sender, this, _exchange, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _user, _amount);
		Exchange exchange = Exchange(_exchange);
		exchange.trade(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _user, _amount);
	}
*/

	//function cancelOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) only_owner when_approved_exchange(_exchange) {
	function cancelOrderExchange(address _exchange, address[5] orderAddresses, uint[6] orderValues, uint cancelTakerTokenAmount) only_owner when_approved_exchange(_exchange) {
		Exchange exchange = Exchange(_exchange);
		//exchange.cancelOrder(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires);
	    exchange.cancelOrder(orderAddresses, orderValues, cancelTakerTokenAmount);
	}
	
	//probably won't fit in contract size
	function cancelOrderExchange(address _exchange, address[5][] orderAddresses, uint[6][] orderValues, uint[] cancelTakerTokenAmounts) only_owner when_approved_exchange(_exchange) {
		Exchange exchange = Exchange(_exchange);
		//exchange.cancelOrder(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires);
	    exchange.batchCancelOrders(orderAddresses, orderValues, cancelTakerTokenAmounts);
	}

	function cancelOrderCFDExchange(address _exchange, address _cfd, uint32 _id) only_owner when_approved_exchange(_exchange) {
		Eventful events = Eventful(getEventful());
		require(events.cancelOrderCFDExchange(msg.sender, this, _exchange, _cfd, _id));
		Exchange exchange = Exchange(_exchange);
		exchange.cancel(_cfd, _id);
	}
	

	function finalizeDealCFDExchange(address _exchange, address _cfd, uint24 _id) only_owner when_approved_exchange(_exchange) {
		Eventful events = Eventful(getEventful());
		require(events.finalizedDealExchange(msg.sender, this, _exchange, _cfd, _id));
		Exchange exchange = Exchange(_exchange);
		exchange.finalize(_cfd, _id);
	}

	function balanceOf(address _who) constant returns (uint256) {
		return accounts[_who].balance;
	}

	function getEventful() constant returns (address) {
	    Authority auth = Authority(admin.authority);
	    return auth.getEventful();
	}
	
	function getData() constant returns (string name, string symbol, uint sellPrice, uint buyPrice) {
		name = data.name;
		symbol = data.symbol;
		sellPrice = data.sellPrice;
		buyPrice = data.buyPrice;
	}

	function getAdminData() constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {
		return (admin.feeCollector, admin.dragoDAO, admin.ratio, data.transactionFee, data.minPeriod);
	}

	function totalSupply() constant returns (uint256) {
	    return data.totalSupply;
	}

	function() payable when_approved_exchange(msg.sender) {}

	DragoData data;
	Admin admin;
	
	mapping (address => Account) accounts;
	
	string constant version = 'HF 0.3.1';
	uint constant base = 1000000; // tokens are divisible by 1 million
}
