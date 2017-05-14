//! Eventful contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Eventful is used to collect all events from all dragos automatically.

pragma solidity ^0.4.11;

contract Drago {

	// METHODS

	function buyDrago() payable returns (bool success) {}
	function sellDrago(uint256 _amount) returns (uint revenue, bool success) {}
	function setPrices(uint256 _newSellPrice, uint256 _newBuyPrice) {}
	function changeMinPeriod(uint32 _minPeriod) {}
	function changeRatio(uint256 _ratio) {}
	function setTransactionFee(uint _transactionFee) {}
	function changeFeeCollector(address _feeCollector) {}
	function changeDragoDAO(address _dragoDAO) {}
	function depositToExchange(address _exchange, address _token, uint256 _value) returns(bool success) {}
	function withdrawFromExchange(address _exchange, address _token, uint256 _value) returns (bool success) {}
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
    event WhitelistedGabcoin(address indexed gabcoin, bool approved);
    event WhitelistedDrago(address indexed drago, bool approved);
    event NewEventful(address indexed eventful);

    // METHODS

    function setAuthority(address _authority, bool _isWhitelisted) {}
    function setWhitelister(address _whitelister, bool _isWhitelisted) {}
    function whitelistUser(address _target, bool _isWhitelisted) {}
    function whitelistAsset(address _asset, bool _isWhitelisted) {}
    function whitelistExchange(address _exchange, bool _isWhitelisted) {}
    function whitelistDrago(address _drago, bool _isWhitelisted) {}
    function whitelistGabcoin(address _gabcoin, bool _isWhitelisted) {}
    function whitelistRegistry(address _registry, bool _isWhitelisted) {}
    function whitelistFactory(address _factory, bool _isWhitelisted) {}
    function setEventful(address _eventful) {}
    function setGabcoinEventful(address _gabcoinEventful) {}
    function setExchangeEventful(address _exchangeEventful) {}
    function setCasper(address _casper) {}

    function isWhitelistedUser(address _target) constant returns (bool) {}
    function isWhitelister(address _whitelister) constant returns (bool) {}
    function isAuthority(address _authority) constant returns (bool) {}
    function isWhitelistedAsset(address _asset) constant returns (bool) {}
    function isWhitelistedExchange(address _exchange) constant returns (bool) {}
    function isWhitelistedRegistry(address _registry) constant returns (bool) {}
    function isWhitelistedDrago(address _drago) constant returns (bool) {}
    function isWhitelistedGabcoin(address _gabcoin) constant returns (bool) {} 
    function isWhitelistedFactory(address _factory) constant returns (bool) {}
    function getEventful() constant returns (address) {}
    function getGabcoinEventful() constant returns (address) {}
    function getExchangeEventful() constant returns (address) {}
    function getCasper() constant returns (address) {}
    function getOwner() constant returns (address) {}
}

contract EventfulFace {

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
      
contract Eventful is EventfulFace {

    	event BuyDrago(address indexed drago, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event SellDrago(address indexed drago, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event NewNAV(address indexed drago, address indexed from, address indexed to, uint sellPrice, uint buyPrice);
	event DepositExchange(address indexed drago, address indexed exchange, address indexed token, uint value, uint256 amount);
	event WithdrawExchange(address indexed drago, address indexed exchange, address indexed token, uint value, uint256 amount);
	event OrderExchange(address indexed drago, address indexed exchange, address indexed cfd, uint value, uint revenue);
	event TradeExchange(address indexed drago, address indexed exchange, address tokenGet, address tokenGive, uint amountGet, uint amountGive, address get);
	event CancelOrder(address indexed drago, address indexed exchange, address indexed cfd, uint value, uint id);
	event DealFinalized(address indexed drago, address indexed exchange, address indexed cfd, uint value, uint id);
	event DragoCreated(address indexed drago, address indexed group, address indexed owner, uint dragoID, string name, string symbol);
    	event NewFee(address indexed targetDrago, address indexed group, address indexed who, uint transactionFee);
    	event NewCollector(address indexed targetDrago, address indexed group, address indexed who, address feeCollector);

   	modifier approved_factory_only(address _factory) { Authority auth = Authority(authority); if (auth.isWhitelistedFactory(_factory)) _; }
   	modifier approved_drago_only(address _drago) { Authority auth = Authority(authority); if (auth.isWhitelistedDrago(_drago)) _; }
    	modifier approved_exchange_only(address _exchange) { Authority auth = Authority(authority); if (auth.isWhitelistedExchange(_exchange)) _; }
    	modifier approved_user_only(address _user) { Authority auth = Authority(authority); if (auth.isWhitelistedUser(_user)) _; }
    	modifier approved_asset(address _asset) { Authority auth = Authority(authority); if (auth.isWhitelistedAsset(_asset)) _; }

    	function Eventful(address _authority) {
	    authority = _authority;
	}

	function buyDrago(address _who, address _targetDrago, uint _value, uint _amount) approved_drago_only(_targetDrago) returns (bool success) {
		//if (_value < 100 finney) throw; //duplicate from before
		if (msg.sender != _targetDrago) return;
		BuyDrago(_targetDrago, _who, msg.sender, _value, _amount);
		return true;
	}

	function sellDrago(address _who, address _targetDrago, uint _amount, uint _revenue) approved_drago_only(_targetDrago) returns(bool success) {
		if(_amount < 0) throw;
		//Drago drago = Drago(_targetDrago);
		if (msg.sender != _targetDrago) return;
		//if (drago.balanceOf(_who) < _amount) return; //this might be lifted as it's checked in the previous sell
		SellDrago(_targetDrago, msg.sender, _who, _amount, _revenue);
		return true;
	}
	
	function setDragoPrice(address _who, address _targetDrago, uint _sellPrice, uint _buyPrice) approved_drago_only(_targetDrago) returns(bool success) {
	    if(_sellPrice <= 10 finney || _buyPrice <= 10 finney) return;
	    //Drago drago = Drago(_targetDrago);
		if (msg.sender != _targetDrago) return;
	    //if( _who != drago.getOwner()) return; //this might be lifted as msg.sender has to be drago
	    NewNAV(_targetDrago, msg.sender, _who, _sellPrice, _buyPrice);
	    return true;
	}
    
	function depositToExchange(address _who, address _targetDrago, address _exchange, address _token, uint256 _value) approved_drago_only(_targetDrago) approved_exchange_only(_exchange) returns(bool success) {
		//Drago drago = Drago(_targetDrago);
		if (msg.sender != _targetDrago) return;
		//if (_who != drago.getOwner()) return; //this might be useless
		DepositExchange(_targetDrago, _exchange, _token, _value, 0);
		return true;
	}
	
	function withdrawFromExchange(address _who, address _targetDrago, address _exchange, address _token, uint256 _value) approved_drago_only(_targetDrago) approved_exchange_only(_exchange) returns(bool success) {
		if(_targetDrago == 0) throw;
		//Drago drago = Drago(_targetDrago);
		if (msg.sender != _targetDrago) return;
		//if (_who != drago.getOwner()) return; //this might be useless
		WithdrawExchange(_targetDrago, _exchange, _token, _value, 0);
		return true;
	}

	function placeOrderExchange(address _who, address _exchange, address _targetDrago, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) approved_drago_only(_targetDrago) approved_exchange_only(_exchange) returns(bool success) {
		if(_targetDrago == 0) throw;
		//Drago drago = Drago(_targetDrago);
		if (msg.sender != _targetDrago) return;
		//if (_who != drago.getOwner()) return; //this might be useless
		OrderExchange(_targetDrago, _exchange, _tokenGet, _amountGet, 0);
		return true;
	}

	function placeOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) approved_drago_only(_targetDrago) approved_exchange_only(_cfdExchange) approved_asset(_cfd) returns(bool success) {
		//Drago drago = Drago(_targetDrago);
		if (msg.sender != _targetDrago) return;
		//if (_who != drago.getOwner()) return;
		OrderExchange(_targetDrago, _cfdExchange, _cfd, _stake, _adjustment);
		return true;
	}
	
	function placeTradeExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, address _user, uint _amount) approved_drago_only(_targetDrago) approved_exchange_only(_exchange) returns(bool success) {
        	if(_targetDrago == 0) throw;
        	//Drago drago = Drago(_targetDrago);
		if (msg.sender != _targetDrago) return;
        	//if (_who != drago.getOwner()) return;
        	//TradeExchange(_targetDrago, _exchange, _tokenGet, _tokenGive, _amountGet, _amountGive, _user);
        	return true;
	}

	function cancelOrderExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) approved_drago_only(_targetDrago) approved_exchange_only(_exchange) returns(bool success) {
		if(_targetDrago == 0) throw;
		//Drago drago = Drago(_targetDrago);
		if (msg.sender != _targetDrago) return;
		//if (_who != drago.getOwner()) return;
		CancelOrder(_targetDrago, _exchange, _tokenGet, _amountGet, 0);
		return true;
	}

	function cancelOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, uint32 _id) approved_drago_only(_targetDrago) approved_exchange_only(_cfdExchange) approved_asset(_cfd) returns(bool success) {
		//Drago drago = Drago(_targetDrago);
		if (msg.sender != _targetDrago) return;
		//if (_who != drago.getOwner()) return;
		CancelOrder(_targetDrago, _cfdExchange, _cfd, 0,_id);
		return true;
	}
	
	function finalizeDealCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, uint24 _id) approved_drago_only(_targetDrago) approved_exchange_only(_cfdExchange) approved_asset(_cfd) returns(bool success) {
		//Drago drago = Drago(_targetDrago);
		if (msg.sender != _targetDrago) return;
		//if (_who != drago.getOwner()) return;
		DealFinalized(_targetDrago, _cfdExchange, _cfd, 0, _id);
		return true;
	}
    
	function setTransactionFee(address _who, address _targetDrago, uint _transactionFee) approved_drago_only(_targetDrago) approved_user_only(_who) returns(bool success) {
		//Drago drago = Drago(_targetDrago);
		if (msg.sender != _targetDrago) return;
		//if (_who != drago.getOwner()) return;
		NewFee(_targetDrago, msg.sender, _who, _transactionFee);
		return true;
	}
    
	function changeFeeCollector(address _who, address _targetDrago, address _feeCollector) approved_drago_only(_targetDrago) approved_user_only(_who) returns(bool success) {
		//Drago drago = Drago(_targetDrago);
		if (msg.sender != _targetDrago) return;
		//if (_who != drago.getOwner()) return;
		NewCollector(_targetDrago, msg.sender, _who, _feeCollector);
		return true;
	}
	
	function createDrago(address _who, address _dragoFactory, address _newDrago, string _name, string _symbol, uint _dragoID, address _owner) approved_factory_only(_dragoFactory) returns(bool success) {
	    	if (msg.sender != _dragoFactory) return;
	    	DragoCreated(_newDrago, _dragoFactory, _owner, _dragoID, _name, _symbol);
	    	return true;
	}
	
	address public authority;
	string constant public version = 'DH0.2';
}
