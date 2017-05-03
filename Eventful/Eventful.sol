//! Eventful contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Eventful is used to collect all events from all dragos automatically.

pragma solidity ^0.4.10;

contract Drago {

	// METHODS

 	function Drago(string _dragoName,  string _dragoSymbol, uint _dragoID) {}
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
	function placeOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {}
	function placeTradeExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce, address _user, uint _amount) {}
	function placeOrderCFDExchange(address _exchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) {}
	function cancelOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint nonce) {}
	function cancelOrderCFDExchange(address _exchange, address _cfd, uint32 _id) {}
	function finalizeDealCFDExchange(address _exchange, address _cfd, uint24 _id) {}
	function setOwner(address _new) {}

	function balanceOf(address _who) constant returns (uint256) {}
	function getData() constant returns (string name, string symbol, uint sellPrice, uint buyPrice, uint totalSupply) {}
	function getAdminData() constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {}
	function getOwner() constant returns (address) {}
}

contract Authority {

    // EVENTS
  
    event SetAuthority (address indexed authority);
    event SetWhitelister (address indexed whitelister);
    event WhitelistedUser(address indexed target, bool approved);
    event WhitelistedAsset(address indexed asset, bool approved);
    event WhitelistedExchange(address indexed exchange, bool approved);
    event WhitelistedRegistry(address indexed registry, bool approved);
    event WhitelistedFactory(address indexed factory, bool approved);
    
    // METHODS
  
    function setAuthority(address _authority, bool _isWhitelisted) {}
    function setWhitelister(address _whitelister, bool _isWhitelisted) {}
    function whitelistUser(address _target, bool _isWhitelisted) {}
    function whitelistAsset(address _asset, bool _isWhitelisted) {}
    function whitelistExchange(address _exchange, bool _isWhitelisted) {}
    function whitelistDrago(address _drago, bool _isWhitelisted) {}
    function whitelistRegistry(address _registry, bool _isWhitelisted) {}
    function whitelistFactory(address _registry, bool _isWhitelisted) {}
  
    function isWhitelistedUser(address _target) constant returns (bool) {}
    function isWhitelister(address _whitelister) constant returns (bool) {}
    function isAuthority(address _authority) constant returns (bool) {}
    function isWhitelistedAsset(address _asset) constant returns (bool) {}
    function isWhitelistedExchange(address _exchange) constant returns (bool) {}
    function isWhitelistedRegistry(address _registry) constant returns (bool) {}
    function isWhitelistedDrago(address _drago) constant returns (bool) {}
    function isWhitelistedFactory(address _factory) constant returns (bool) {}
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
    function buyDrago(address _who, address _targetDrago, uint _value, uint _amount) payable returns (bool success) {}
    function sellDrago(address _who, address _targetDrago, uint _amount, uint _revenue) returns (bool success) {}
    function setDragoPrice(address _who, address _targetDrago, uint _sellPrice, uint _buyPrice) returns (bool success) {}
    function changeRatio(address _who, address _targetDrago, uint256 _ratio) {}
    function setTransactionFee(address _who, address _targetDrago, uint _transactionFee) {}
    function changeFeeCollector(address _who, address _targetDrago, address _feeCollector) {}
    function changeDragoDAO(address _who, address _targetDrago, address _dragoDAO) {}
    function depositToExchange(address _who, address _targetDrago, address _exchange, address _token, uint256 _value) returns(bool) {}
    function withdrawFromExchange(address _who, address _targetDrago, address _exchange, address _token, uint256 _value) returns (bool) {}
    function placeOrderExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {}
    function placeTradeExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce, address _user, uint _amount) {}
    function placeOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) {}
    function cancelOrderExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {}
    function cancelOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, uint32 _id) {}
    function finalizedDealExchange(address _who, address _targetDrago, address _exchange, address _cfd, uint24 _id) {}
    function createDrago(address _who, address _dragoFactory, address _newDrago, string _name, string _symbol, uint _dragoId, address _owner) returns (bool success) {}
} 
      
contract Eventful is EventfulFace {
    
    struct User {
        address from;
        //mapping (address => uint) allowed;
    }
    
    struct Data {
        mapping (address => uint256) balances;
        mapping (address => mapping (address => uint256)) allowed;
        //mapping (address => User) user;
        uint256 totalTokens;
    }

    event BuyDrago(address indexed drago, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event SellDrago(address indexed drago, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event NewNAV(address indexed drago, address indexed from, address indexed to, uint sellPrice, uint buyPrice);
	event DepositExchange(address indexed drago, address indexed exchange, address indexed token, uint value, uint256 amount);
	event WithdrawExchange(address indexed drago, address indexed exchange, address indexed token, uint value, uint256 amount);
	event OrderExchange(address indexed drago, address indexed exchange, address indexed cfd, uint value, uint revenue);
	event TradeExchange(address indexed drago, address indexed exchange, address tokenGet, address tokenGive, uint amountGet, uint amountGive, address get, address give);
	event CancelOrder(address indexed drago, address indexed exchange, address indexed cfd, uint value, uint id);
	event DealFinalized(address indexed drago, address indexed exchange, address indexed cfd, uint value, uint id);
	event DragoCreated(address indexed drago, address indexed group, address indexed owner, uint dragoID, string name, string symbol);

    modifier approved_factory_only { if (!auth.isWhitelistedFactory(msg.sender)) return; _; }


	function buyDrago(address _who, address _targetDrago, uint _value, uint _amount) payable approved_factory_only returns (bool success) {
		if(msg.value <= 100 finney) throw;
	    //if (!auth.isWhitelistedUser(_who)) return;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
		Drago drago = Drago(_targetDrago);
		BuyDrago(_targetDrago, _who, msg.sender, msg.value, _amount);
	}
    
	function sellDrago(address _who, address _targetDrago, uint _amount, uint _revenue) approved_factory_only returns (bool success) {
		if(_amount <= 0) throw;
	    //if (!auth.isWhitelistedUser(_who)) return;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
		Drago drago = Drago(_targetDrago);
		if (drago.balanceOf(_who) < _amount) return;
		SellDrago(_targetDrago, msg.sender, this, _amount, _revenue);
	}
	
	function setDragoPrice(address _who, address _targetDrago, uint _sellPrice, uint _buyPrice) approved_factory_only returns (bool success) {
	    if(_sellPrice <= 10 finney || _buyPrice <= 10 finney) return;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    Drago drago = Drago(_targetDrago);
	    if( _who != drago.getOwner()) return;
	    NewNAV(_targetDrago, msg.sender, this, _sellPrice, _buyPrice);
	}
    
	function depositToExchange(address _who, address _targetDrago, address _exchange, address _token, uint256 _value) approved_factory_only returns(bool) {
	    //if (!auth.isWhitelistedUser(_who)) throw;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    if (!auth.isWhitelistedExchange(_exchange)) return;
		Drago drago = Drago(_targetDrago);
		if( _who != drago.getOwner()) return;
		DepositExchange(_targetDrago, _exchange, _token, _value, 0);
	}
	
	function withdrawFromExchange(address _who, address _targetDrago, address _exchange, address _token, uint256 _value) approved_factory_only returns (bool) {
		if(_targetDrago == 0) throw;
	    //if (!auth.isWhitelistedUser(_who)) throw;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    if (!auth.isWhitelistedExchange(_exchange)) return;
		Drago drago = Drago(_targetDrago);
		if( _who != drago.getOwner()) return;
		WithdrawExchange(_targetDrago, _exchange, _token, _value, 0);
	}

	function placeOrderExchange(address _who, address _exchange, address _targetDrago, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) approved_factory_only {
		if(_targetDrago == 0) throw;
	    //if (!auth.isWhitelistedUser(_who)) throw;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    if (!auth.isWhitelistedExchange(_exchange)) return;
		Drago drago = Drago(_targetDrago);
		if( _who != drago.getOwner()) return;
		OrderExchange(_targetDrago, _exchange, _tokenGet, _amountGet, _nonce);
	}

	function placeOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) approved_factory_only {
	    //if (!auth.isWhitelistedUser(_who)) throw;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    if (!auth.isWhitelistedExchange(_cfdExchange)) return;
		Drago drago = Drago(_targetDrago);
		if( _who != drago.getOwner()) return;
		OrderExchange(_targetDrago, _cfdExchange, _cfd, _stake, _adjustment);
	}
	
	function placeTradeExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce, address _user, uint _amount) approved_factory_only {
        if(_targetDrago == 0) throw;
        //if (!auth.isWhitelistedUser(_who)) return;
        if (!auth.isWhitelistedDrago(_targetDrago)) return;
        if (!auth.isWhitelistedExchange(_exchange)) return;
        Drago drago = Drago(_targetDrago);
        if( _who != drago.getOwner()) return;
        TradeExchange(_targetDrago, _exchange, _tokenGet, _tokenGive, _amountGet, _amountGive, _user, msg.sender);
	}

	function cancelOrderExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) approved_factory_only {
		if(_targetDrago == 0) throw;
	    //if (!auth.isWhitelistedUser(msg.sender)) return;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    if (!auth.isWhitelistedExchange(_exchange)) return;
		Drago drago = Drago(_targetDrago);
		if( _who != drago.getOwner()) return;
		CancelOrder(_targetDrago, _exchange, _tokenGet, _amountGet, _nonce);
	}

	function cancelOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, uint32 _id) approved_factory_only {
	    //if (!auth.isWhitelistedUser(msg.sender)) return;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    if (!auth.isWhitelistedExchange(_cfdExchange)) return;
		Drago drago = Drago(_targetDrago);
		if( _who != drago.getOwner()) return;
		CancelOrder(_targetDrago, _cfdExchange, _cfd, 0,_id);
	}
	
	function finalizeDealCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, uint24 _id) approved_factory_only {
	    //if (!auth.isWhitelistedUser(msg.sender)) return;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    if (!auth.isWhitelistedExchange(_cfdExchange)) return;
		Drago drago = Drago(_targetDrago);
		if( _who != drago.getOwner()) return;
		DealFinalized(_targetDrago, _cfdExchange, _cfd, 0, _id);
	}
    
	function setTransactionFee(address _who, address _targetDrago, uint _transactionFee) approved_factory_only {
	    if (!auth.isWhitelistedUser(_who)) return;
		Drago drago = Drago(_targetDrago);
		if( _who != drago.getOwner()) return;
	}
    
	function changeFeeCollector(address _who, address _targetDrago, address _feeCollector) approved_factory_only {
	    if (!auth.isWhitelistedUser(msg.sender)) return;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
		Drago drago = Drago(_targetDrago);
		if (_who != drago.getOwner()) return;
	}
	
	function createDrago(address _who, address _dragoFactory, address _newDrago, string _name, string _symbol, uint _dragoID, address _owner) approved_factory_only returns (bool success) {
	    DragoCreated(_newDrago, _dragoFactory, _owner, _dragoID, _name, _symbol);
	}

	Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	
	string constant public version = 'DH0.2';
}
