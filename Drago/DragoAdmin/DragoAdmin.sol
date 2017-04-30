//! Drago Admin contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Used to interact with Drago.

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
	function depositToExchange(address _exchange, address _token, uint256 _value) payable returns(bool success) {}
	function depositToCFDExchange(address _cfdExchange, uint256 _value) payable returns(bool success) {}
	function withdrawFromExchange(address _exchange, address _token, uint256 _value) returns (bool success) {}
	function withdrawFromCFDExchange(address _cfdExchange, uint _amount) returns(bool success) {}
	function placeOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {}
	function placeTradeExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce, address _user, uint8 _v, bytes32 _r, bytes32 _s, uint _amount) {}
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

contract DragoFactory {
    
	// EVENTS

	event DragoCreated(string _name, address _drago, address _owner, uint _dragoID);

	// METHODS
    
	function createDrago(string _name, string _symbol) returns (bool) {}
	function setRegistry(address _newRegistry) {}
	function setBeneficiary(address _dragoDAO) {}
	function setFee(uint _fee) {}
	function drain() {}
	function setOwner(address _new) {}
    
	function getRegistry() constant returns (address) {}
	function getStorage() constant returns (address dragoDAO, string version, uint nextDragoID) {}
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

    	// METHODS
  
    	function setAuthority(address _authority, bool _isWhitelisted) {}
    	function setWhitelister(address _whitelister, bool _isWhitelisted) {}
    	function whitelistUser(address _target, bool _isWhitelisted) {}
    	function whitelistAsset(address _asset, bool _isWhitelisted) {}
    	function whitelistExchange(address _exchange, bool _isWhitelisted) {}
    	function whitelistDrago(address _drago, bool _isWhitelisted) {}
    	function whitelistRegistry(address _registry, bool _isWhitelisted) {}
  
    	function isWhitelistedUser(address _target) constant returns (bool) {}
    	function isWhitelister(address _whitelister) constant returns (bool) {}
    	function isAuthority(address _authority) constant returns (bool) {}
    	function isWhitelistedAsset(address _asset) constant returns (bool) {}
    	function isWhitelistedExchange(address _exchange) constant returns (bool) {}
    	function isWhitelistedRegistry(address _registry) constant returns (bool) {}
    	function isWhitelistedDrago(address _drago) constant returns (bool) {}
    	function getOwner() constant returns (address) {}
}

contract DragoRegistry {

	//EVENTS

	event Registered(string indexed symbol, uint indexed id, address drago, string name);
	event Unregistered(string indexed symbol, uint indexed id);
	event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);
	
	// METHODS
        
	function register(address _drago, string _name, string _symbol, uint _dragoID, address _owner) payable returns (bool) {}
	function registerAs(address _drago, string _name, string _symbol, uint _dragoID, address _owner, address _group) payable returns (bool) {}
	function unregister(uint _id) {}
	function setMeta(uint _id, bytes32 _key, bytes32 _value) {}
	function setFee(uint _fee) {}
	function upgrade(address _newAddress) payable {}
	function setUpgraded(uint _version) {}
	function drain() {}
	function kill() {}
	
	function dragoCount() constant returns (uint) {}
	function drago(uint _id) constant returns (address drago, string name, string symbol, uint dragoID, address owner, address group) {}
	function fromAddress(address _drago) constant returns (uint id, string name, string symbol, uint dragoID, address owner, address group) {}
	function fromSymbol(string _symbol) constant returns (uint id, address drago, string name, uint dragoID, address owner, address group) {}
	function fromName(string _name) constant returns (uint id, address drago, string symbol, uint dragoID, address owner, address group) {}
	function meta(uint _id, bytes32 _key) constant returns (bytes32) {}
	function getGroups(address _group) constant returns (address[]) {}
}
      
library DragoAdminFace {

	// EVENTS

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
	event DragoCreated(string _name, string _symbol, address _drago, address _dragowner, uint _dragoID);
	
	// METHODS
	
	function buyDrago(address targetDrago) returns (uint amount) {}
	function sellDrago(address targetDrago, uint256 amount) returns (uint revenue) {}
	function setDragoPrice(address _targetDrago, uint _sellPrice, uint _buyPrice) {}
	function changeRatio(address _targetDrago, uint256 _ratio) {}
	function setTransactionFee(address _targetDrago, uint _transactionFee) {}
	function changeFeeCollector(address _targetDrago, address _feeCollector) {}
	function changeDragoDAO(address _targetDrago, address _dragoDAO) {}
	function depositToExchange(address targetDrago, address exchange, address token, uint256 value) returns(bool) {}
	function depositToCFDExchange(address _targetDrago, address _cfdExchange) returns(bool) {}
	function withdrawFromExchange(address targetDrago, address exchange, address token, uint256 value) returns (bool) {}
	function withdrawFromCFDExchange(address _targetDrago, address _cfdExchange, uint amount) returns(bool) {}
	function placeOrderExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {}
	function placeTradeExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce, address _user, uint8 _v, bytes32 _r, bytes32 _s, uint _amount) {}
	function placeOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, bool is_stable, uint32 adjustment, uint128 stake) {}
	function cancelOrderExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {}
	function cancelOrderCFDExchange(address targetDrago, address _cfdExchange, address _cfd, uint32 id) {}
	function finalizedDealExchange(address targetDrago, address exchange, uint24 id) {}
	function createDrago(address _dragoFactory, string _name, string _symbol) returns (address _drago, uint _dragoID) {}
} 
      
library DragoAdmin {

	event Buy(address _targetDrago, address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event Sell(address _targetDrago, address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event NAV(address _targetDrago, uint sellPrice, uint buyPrice);
	event DepositExchange(address _targetDrago, uint value, uint256 indexed _amount, address indexed who, address token , address indexed _exchange);
	event DepositCFDExchange(address _targetDrago, uint , uint256 indexed _amount, address indexed who, address , address indexed _cfdExchange);
	event WithdrawExchange(address _targetDrago, uint , uint256 indexed _amount, address indexed who, address , address indexed _cfdExchange);
	event WithdrawCFDExchange(address _targetDrago, uint , uint256 indexed _amount, address indexed who, address , address indexed _cfdExchange);
	event OrderExchange(address _targetDrago, address indexed _exchange, address indexed _token);
	event OrderCFD(address _targetDrago, address indexed _cfdExchange, address indexed _cfd);
	event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
	event CancelExchange(address indexed _targetDrago, address indexed _exchange, address indexed token, uint id);
	event CancelCFD(address indexed _targetDrago, address indexed _cfdExchange, address indexed _cfd, uint32 id);
	event FinalizeCFD(address indexed _targetDrago, address indexed _cfdExchange, address indexed _cfd, uint32 id);
	event DragoCreated(string _name, string _symbol, address _drago, address _dragowner, uint _dragoID);

	function buyDrago(address _targetDrago) returns (uint amount) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedDrago(_targetDrago)) return;
		Drago drago = Drago(_targetDrago);
		drago.buyDrago.value(msg.value)(); //assert
		return amount;
		Buy(_targetDrago, msg.sender, this, msg.value, amount);
		//return true;
	}
    
	function sellDrago(address _targetDrago, uint256 amount) returns (uint revenue) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedDrago(_targetDrago)) return;
		Drago drago = Drago(_targetDrago);
		drago.sellDrago(amount);    //assert()
		Sell(_targetDrago, this, msg.sender, amount, revenue);
	}
	
	function setDragoPrice(address _targetDrago, uint _sellPrice, uint _buyPrice) {
	    	Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    	Drago drago = Drago(_targetDrago);
	    	drago.setPrices(_sellPrice, _buyPrice);
	    	NAV(_targetDrago, _sellPrice, _buyPrice);
	}
    
	function depositToExchange(address _targetDrago, address _exchange, address _token, uint256 _value) returns(bool) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedExchange(_exchange)) return;
		Drago drago = Drago(_targetDrago);
		assert(drago.depositToExchange(_exchange, _token, _value));
		DepositExchange(_targetDrago, _value, msg.value, msg.sender, _token, _exchange);
	}
	
	function depositToCFDExchange(address _targetDrago, address _cfdExchange, uint _value) returns(bool) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedExchange(_cfdExchange)) return;
	    	Drago drago = Drago(_targetDrago);
	    	drago.depositToCFDExchange(_cfdExchange, _value);
	    	DepositCFDExchange(_targetDrago, 0, msg.value, msg.sender, 0, _cfdExchange);
	}
	
	function withdrawFromExchange(address _targetDrago, address _exchange, address token, uint256 value) returns (bool) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedExchange(_exchange)) return;
		Drago drago = Drago(_targetDrago);
		assert(drago.withdrawFromExchange(_exchange, token, value)); //for ETH token = 0
		WithdrawExchange(_targetDrago, value, value, msg.sender, token, _exchange);
	}
	
	function withdrawFromCFDExchange(address _targetDrago, address _cfdExchange, uint amount) /*when_approved_exchange*/ /*only_drago_owner*/ returns(bool) {
	    	Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedExchange(_cfdExchange)) return;
	    	Drago drago = Drago(_targetDrago);
	    	assert(drago.withdrawFromCFDExchange(_cfdExchange, amount));
	    	WithdrawCFDExchange(_targetDrago, amount, amount, msg.sender, 0, _cfdExchange);
	}
	
	function placeOrderExchange(address _exchange, address _targetDrago, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedExchange(_exchange)) return;
		Drago drago = Drago(_targetDrago);
		drago.placeOrderExchange(_exchange, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce);
		OrderExchange(_targetDrago, _exchange, _tokenGet);
	}
	
	function placeOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, bool is_stable, uint32 adjustment, uint128 stake) /*only_owner*/ {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedExchange(_cfdExchange)) return;
		Drago drago = Drago(_targetDrago);
		drago.placeOrderCFDExchange(_cfdExchange, _cfd, is_stable, adjustment, stake);
		OrderCFD(_targetDrago, _cfdExchange, _cfd);
	}
	
	function placeTradeExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce, address _user, uint8 _v, bytes32 _r, bytes32 _s, uint _amount) {
	    	Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedExchange(_exchange)) return;
	    	Drago drago = Drago(_targetDrago);
	    	drago.placeTradeExchange(_exchange, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce, _user, _v, _r, _s, _amount);
	    	Trade(_tokenGet, _amountGet, _tokenGive, _amountGive, _user, msg.sender);
	}
	
	function cancelOrderExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedExchange(_exchange)) return;
		Drago drago = Drago(_targetDrago);
		drago.cancelOrderExchange(_exchange, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, nonce, v, r, s);
		CancelExchange(_targetDrago, _exchange, _tokenGet, nonce);
	}
	
	function cancelOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, uint32 id) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedExchange(_cfdExchange)) return;
		Drago drago = Drago(_targetDrago);
		drago.cancelOrderCFDExchange(_cfdExchange, _cfd, id);
		CancelCFD(_targetDrago, _cfdExchange, _cfd, id);
	}	
	
	function finalizeDealCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, uint24 id) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedExchange(_cfdExchange)) return;
		Drago drago = Drago(_targetDrago);
		drago.finalizeDealCFDExchange(_cfdExchange, _cfd, id);
		FinalizeCFD(_targetDrago, _cfdExchange, _cfd, id);
	}
	
	function changeRatio(address _targetDrago, uint256 _ratio) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedDrago(_targetDrago)) return;
		Drago drago = Drago(_targetDrago);
		drago.changeRatio(_ratio);
	}
    
	function setTransactionFee(address _targetDrago, uint _transactionFee) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
		Drago drago = Drago(_targetDrago);
		drago.setTransactionFee(_transactionFee); //fee is in basis points (1 bps = 0.01%)
	}
    
	function changeFeeCollector(address _targetDrago, address _feeCollector) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedDrago(_targetDrago)) return;
		Drago drago = Drago(_targetDrago);
		drago.changeFeeCollector(_feeCollector);
	}
    
	function changeDragoDAO(address _targetDrago, address _dragoDAO) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedDrago(_targetDrago)) return;
		Drago drago = Drago(_targetDrago);
		drago.changeDragoDAO(_dragoDAO);
	}
	
	function createDrago(address _dragoFactory, string _name, string _symbol) returns (address _drago, uint _dragoID) {
	    DragoFactory factory = DragoFactory(_dragoFactory);
	    assert(factory.createDrago(_name, _symbol));
	    DragoCreated(_name, _symbol, _drago, msg.sender, _dragoID);
	}
	
	string constant public version = 'DA0.2';
}
