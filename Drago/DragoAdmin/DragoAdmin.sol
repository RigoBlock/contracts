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

contract DragoFactory {
    
	// EVENTS

	event DragoCreated(string _name, string _symbol, address indexed _drago, address indexed _owner, uint _dragoID);

	// METHODS
    
	function createDrago(string _name, string _symbol) returns (bool) {}
	function setRegistry(address _newRegistry) {}
	function setBeneficiary(address _dragoDAO) {}
	function setFee(uint _fee) {}
	function drain() {}
	function setOwner(address _new) {}
    
	function getRegistry() constant returns (address) {}
	function getStorage() constant returns (address dragoDAO, string version, uint nextDragoID) {}
	function getDragosByAddress(address _owner) constant returns (address[]) {}
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
	
    function buyDrago(address _targetDrago) returns (uint amount) {}
    function sellDrago(address _targetDrago, uint256 _amount) returns (uint revenue) {}
    function setDragoPrice(address _targetDrago, uint _sellPrice, uint _buyPrice) {}
    function changeRatio(address _targetDrago, uint256 _ratio) {}
    function setTransactionFee(address _targetDrago, uint _transactionFee) {}
    function changeFeeCollector(address _targetDrago, address _feeCollector) {}
    function changeDragoDAO(address _targetDrago, address _dragoDAO) {}
    function depositToExchange(address _targetDrago, address _exchange, address _token, uint256 _value) returns(bool) {}
    function withdrawFromExchange(address _targetDrago, address _exchange, address _token, uint256 _value) returns (bool) {}
    function placeOrderExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {}
    function placeTradeExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce, address _user, uint _amount) {}
    function placeOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) {}
    function cancelOrderExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {}
    function cancelOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, uint32 _id) {}
    function finalizedDealExchange(address _targetDrago, address _exchange, uint24 _id) {}
    function createDrago(address _dragoFactory, string _name, string _symbol) returns (address _drago, uint _dragoID) {}
} 
      
library DragoAdmin {
    
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

	function buyDrago(address _targetDrago) returns (uint amount) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    if (!auth.isWhitelistedUser(msg.sender)) return;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
		Drago drago = Drago(_targetDrago);
		drago.buyDrago.value(msg.value)(); //assert
		return amount;
		BuyDrago(_targetDrago, msg.sender, this, msg.value, amount);
	}
    
	function sellDrago(address _targetDrago, uint256 _amount) returns (uint revenue) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    if (!auth.isWhitelistedUser(msg.sender)) return;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
		Drago drago = Drago(_targetDrago);
		drago.sellDrago(_amount);    //assert()
		SellDrago(_targetDrago, msg.sender, this, _amount, revenue);
	}
	
	function setDragoPrice(address _targetDrago, uint _sellPrice, uint _buyPrice) {
	    Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    if (!auth.isWhitelistedUser(msg.sender)) return;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    Drago drago = Drago(_targetDrago);
	    drago.setPrices(_sellPrice, _buyPrice);
	    NewNAV(_targetDrago, msg.sender, this, _sellPrice, _buyPrice);
	}
    
	function depositToExchange(address _targetDrago, address _exchange, address _token, uint256 _value) returns(bool) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    if (!auth.isWhitelistedUser(msg.sender)) return;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    if (!auth.isWhitelistedExchange(_exchange)) return;
		Drago drago = Drago(_targetDrago);
		assert(drago.depositToExchange(_exchange, _token, _value));
		DepositExchange(_targetDrago, _exchange, msg.sender, _value, msg.value);
	}
	
	function withdrawFromExchange(address _targetDrago, address _exchange, address _token, uint256 _value) returns (bool) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    if (!auth.isWhitelistedUser(msg.sender)) return;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    if (!auth.isWhitelistedExchange(_exchange)) return;
		Drago drago = Drago(_targetDrago);
		assert(drago.withdrawFromExchange(_exchange, _token, _value)); //for ETH token = 0
		WithdrawExchange(_targetDrago, _exchange, msg.sender, _value, 0);
	}

	function placeOrderExchange(address _exchange, address _targetDrago, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    if (!auth.isWhitelistedUser(msg.sender)) return;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    if (!auth.isWhitelistedExchange(_exchange)) return;
		Drago drago = Drago(_targetDrago);
		drago.placeOrderExchange(_exchange, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce);
		OrderExchange(_targetDrago, _exchange, _tokenGet, _amountGet, _nonce);
	}

	function placeOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    if (!auth.isWhitelistedUser(msg.sender)) return;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    if (!auth.isWhitelistedExchange(_cfdExchange)) return;
		Drago drago = Drago(_targetDrago);
		drago.placeOrderCFDExchange(_cfdExchange, _cfd, _is_stable, _adjustment, _stake);
		OrderExchange(_targetDrago, _cfdExchange, _cfd, _stake, _adjustment);
	}
	
	function placeTradeExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce, address _user, uint _amount) {
        Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
        if (!auth.isWhitelistedUser(msg.sender)) return;
        //if (!auth.isWhitelistedDrago(_targetDrago)) return;
        if (!auth.isWhitelistedExchange(_exchange)) return;
        Drago drago = Drago(_targetDrago);
        drago.placeTradeExchange(_exchange, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce, _user, _amount);
        TradeExchange(_targetDrago, _exchange, _tokenGet, _tokenGive, _amountGet, _amountGive, _user, msg.sender);
	}
	
	function cancelOrderExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    	if (!auth.isWhitelistedExchange(_exchange)) return;
		Drago drago = Drago(_targetDrago);
		drago.cancelOrderExchange(_exchange, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _nonce);
		CancelOrder(_targetDrago, _exchange, _tokenGet, _amountGet, _nonce);
	}
	
	function cancelOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, uint32 _id) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    	if (!auth.isWhitelistedUser(msg.sender)) return;
	    	if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    	if (!auth.isWhitelistedExchange(_cfdExchange)) return;
		Drago drago = Drago(_targetDrago);
		drago.cancelOrderCFDExchange(_cfdExchange, _cfd, _id);
		CancelOrder(_targetDrago, _cfdExchange, _cfd, 0,_id);
	}
	
	function finalizeDealCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, uint24 _id) {
		Authority auth = Authority(0x23A013E7A236DE234437c1E1342022727823e800);
	    if (!auth.isWhitelistedUser(msg.sender)) return;
	    if (!auth.isWhitelistedDrago(_targetDrago)) return;
	    if (!auth.isWhitelistedExchange(_cfdExchange)) return;
		Drago drago = Drago(_targetDrago);
		drago.finalizeDealCFDExchange(_cfdExchange, _cfd, _id);
		DealFinalized(_targetDrago, _cfdExchange, _cfd, 0, _id);
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
	
	function createDrago(address _dragoFactory, string _name, string _symbol) returns (address drago, uint dragoID) {
	    DragoFactory factory = DragoFactory(_dragoFactory);
	    assert(factory.createDrago(_name, _symbol));
	    dragoID;
	    drago;
	    DragoCreated(drago, _dragoFactory, msg.sender, dragoID, _name, _symbol);
	}
	
	string constant public version = 'DH0.2';
}
