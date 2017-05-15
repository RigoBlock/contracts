//! Exchange Eventful contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Collects all events from all all assets listed on oour exchange

pragma solidity ^0.4.11;

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
    function getListsByGroups(string _group) constant returns (address[]) {}
}

contract ExchangeEventfulFace {
    
	// EVENTS

	event Deposit(address exchange, address token, address user, uint amount, uint balance);
	event Withdraw(address exchange, address token, address user, uint amount, uint balance);
	event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user);
	event OrderPlaced(address exchange, address indexed cfd, uint32 id, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
    event OrderMatched(address exchange, address indexed cfd, address indexed stable, address indexed leveraged, bool is_stable, uint32 id, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(address exchange, address indexed cfd, uint32 indexed id, address indexed who, uint128 stake);
	event Cancel(address exchange, address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user);
	event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
	event DealFinalized(address exchange, address indexed cfd, address indexed stable, address indexed leveraged, uint64 price);

	// METHODS

	function deposit(address _who, address _exchange, address _token, uint _amount, uint _balance) payable returns (bool success) {}
	function withdraw(address _who, address _exchange, address _token, uint _amount, uint _balance) returns (bool success) {}
	function order(address _who, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns (bool success) {}
	function orderCFD(address _who, address _exchange, address _cfd, uint32 id, bool _is_stable, uint32 _adjustment, uint128 _stake) returns (bool success) {}
	function dealCFD(address _who, address _exchange, address _cfd, uint32 order, address stable, address leveraged, bool _is_stable, uint32 id, uint64 strike, uint128 _stake) returns (bool success) {}
	function trade(address _who, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint amountGive, uint expires, address user, uint amount) returns (bool success) {}
	function cancelOrder(address _who, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns (bool success) {}
	function cancel(address _who, address _exchange, address _cfd, uint32 _id, uint128 _stake) returns (bool success) {}
	function finalize(address _who, address _exchange, address _cfd, uint24 _id, address _stable, address _leveraged) returns (bool success) {}
	function addCredits(address _who, address _exchange, address _stable, uint _stable_gets, address _leveraged, uint _leveraged_gets, uint24 id) returns (bool success) {}
}

contract ExchangeEventful is ExchangeEventfulFace {
    
    event Deposit(address exchange, address token, address user, uint amount, uint balance);
	event Withdraw(address exchange, address token, address user, uint amount, uint balance);
	event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user);
	event OrderPlaced(address exchange, address indexed cfd, uint32 id, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
    event OrderMatched(address exchange, address indexed cfd, address indexed stable, address indexed leveraged, bool is_stable, uint32 id, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(address exchange, address indexed cfd, uint32 indexed id, address indexed who, uint128 stake);
	event Cancel(address exchange, address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user);
	event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
	event DealFinalized(address exchange, address indexed cfd, address indexed stable, address indexed leveraged, uint64 price);

    modifier approved_asset_only(address _asset) { Authority auth = Authority(authority); if (auth.isWhitelistedAsset(_asset)) _; }
   	modifier approved_exchange_only(address _exchange) { Authority auth = Authority(authority); if (auth.isWhitelistedExchange(_exchange)) _; }
    modifier approved_user_only(address _user) { Authority auth = Authority(authority); if (auth.isWhitelistedUser(_user)) _; }
    modifier approved_exchange_or_asset(address _target) { Authority auth = Authority(authority); if (auth.isWhitelistedAsset(_target) || auth.isWhitelistedExchange(_target)) _; }

    function Eventful(address _authority) {
	    authority = _authority;
	}

    function deposit(address _who, address _exchange, address _token, uint _amount, uint _balance) payable approved_exchange_only(_exchange) returns (bool success) {
        if (msg.sender != _exchange) return;
        Deposit(_exchange, _token, _who, _amount, 0);
    }
    
	function withdraw(address _who, address _exchange, address _token, uint _amount, uint _balance) approved_exchange_only(_exchange) returns (bool success) {
	    if (msg.sender != _exchange) return;
	    Withdraw(_exchange, _token, _who, _amount, 0);
	}
	
	function order(address _who, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) approved_exchange_only(_exchange) returns (bool success) {
	    if (msg.sender != _exchange) return;
	    Order(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _who);
	}
	
	function orderCFD(address _who, address _exchange, address _cfd, uint32 _id, bool _is_stable, uint32 _adjustment, uint128 _stake) approved_exchange_only(_exchange) approved_asset_only(_cfd) returns (bool success) {
	    if (msg.sender != _cfd) return;
	    OrderPlaced(_exchange, _cfd, _id, _who, _is_stable, _adjustment, _stake);
	}
	
	function dealCFD(address _who, address _exchange, address _cfd, uint32 _order, address _stable, address _leveraged, bool _is_stable, uint32 _id, uint64 _strike, uint128 _stake) approved_exchange_only(_exchange) returns (bool success) {
	    if (msg.sender != _cfd) return;
	    OrderMatched(_exchange, _cfd, _stable, _leveraged, _is_stable, _order, _id, _strike, _stake);
	}
	
	function trade(address _who, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, address _user) approved_exchange_only(_exchange) returns (bool success) {
	    if (msg.sender != _exchange) return;
	    Trade(_tokenGet, _amountGet, _tokenGive, _amountGive, _who, _user);
	}
	
	function cancelOrder(address _who, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) approved_exchange_only(_exchange) returns (bool success) {
	    if (msg.sender != _exchange) return;
	    Cancel(_exchange, _tokenGet, _amountGet, _tokenGive, _amountGive, _who);
	}
	
	function cancel(address _who, address _exchange, address _cfd, uint32 _id, uint128 _stake) approved_exchange_only(_exchange) approved_asset_only(_cfd) returns (bool success) {
	    if (msg.sender != _exchange) return;
	    OrderCancelled(_exchange, _cfd, _id, _who, _stake);
	}
	
	function finalize(address _who, address _exchange, address _cfd, uint24 _id, address _stable, address _leveraged, uint64 _price) approved_exchange_only(_exchange) approved_asset_only(_cfd) returns (bool success) {
	    if (msg.sender != _exchange) return;
	    DealFinalized(_exchange, _cfd, _stable, _leveraged, _price);
	}
	
	function addCredits(address _who, address _exchange, address _stable, uint _stable_gets, address _leveraged, uint _leveraged_gets, uint24 id) approved_exchange_only(_exchange) returns (bool success) {
	    if (msg.sender != _exchange) return;
	}

    address public authority;
}
