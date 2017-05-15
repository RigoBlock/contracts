//! CFD Exchange contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.11;

contract Owned {
    
	modifier only_owner { if (msg.sender != owner) return; _; }

	event NewOwner(address indexed old, address indexed current);
   
	function setOwner(address _new) only_owner {
		owner = _new;
		NewOwner(owner, _new);
	}

	address public owner = msg.sender;
}

contract SafeMath {

	function safeMul(uint a, uint b) internal returns (uint) {
		uint c = a * b;
		assert(a == 0 || c / a == b);
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
	
	function safeDiv(uint a, uint b) internal returns (uint) {
        assert(b > 0);
        uint c = a / b;
        assert(a == b * c + a % b);
        return c;
    }
}

contract AccountLevels {
	function accountLevel(address user) constant returns(uint) {}
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
    function getListsByGroups(string _group) constant returns (address[]) {}
}

contract CFD {
	
	event Deposit(address indexed who, uint value);
	event Withdraw(address indexed who, uint value);
	event OrderPlaced(uint32 indexed id, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	event OrderMatched(uint32 indexed id, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(uint32 indexed id, address indexed who, uint128 stake);
	event DealFinalized(uint32 indexed id, address indexed stable, address indexed leveraged, uint64 price);

	function deposit(address _who) payable {}
	function withdraw(uint value) returns (bool success) {}
	function orderExchange(bool is_stable, uint32 adjustment, uint128 stake, address _who) returns (bool success) {}
	function cancelExchange(uint32 id, address _who) returns (bool success) {}
	function finalizeExchange(uint24 id, address _who) returns (bool success) {}
	function setMaxLeverage(uint _maxLeverage) {}
	function setExchange (address _exchange) {} //this is used in order to update exchange in cfd in case of deployment of new exchange

	function bestAdjustment(bool _is_stable) constant returns (uint32) {}
	function bestAdjustmentFor(bool _is_stable, uint128 _stake) constant returns (uint32) {}
	function dealDetails(uint32 _id) constant returns (address stable, address leveraged, uint64 strike, uint128 stake, uint32 end_time, uint VAR) {}
	function orderDetails(uint32 _id) constant returns (uint128) {}
	function balanceOf(address _who) constant returns (uint) {}
	function getLastOrderId() constant returns (uint) {}
	function getOrderOwner(uint32 _id) constant returns (address) {}
	function getStable(uint32 _id) constant returns (address) {}
	function getLeveraged(uint32 _id) constant returns (address) {}
	function getMaxLeverage() constant returns (uint) {}
	function getDealStake(uint32 _id) constant returns (uint128) {}
	function getDealLev(uint32 _id) constant returns (uint) {}
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

contract ExchangeEventful {
    
	// EVENTS

	event Deposit(address exchange, address token, address user, uint amount, uint balance);
	event Withdraw(address exchange, address token, address user, uint amount, uint balance);
	event Order(address exchange, address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user);
	event OrderPlaced(address exchange, address indexed cfd, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
    event OrderMatched(address exchange, address indexed cfd, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event Cancel(address exchange, address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user);
	event OrderCancelled(address exchange, address indexed cfd, uint32 indexed id, address indexed who, uint128 stake);
	event Cancel(address exchange, address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user);
	event Trade(address exchange, address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
	event DealFinalized(address exchange, address indexed cfd, address indexed stable, address indexed leveraged, uint64 price);

	// METHODS

	function deposit(address _who, address _exchange, address _token, uint _amount) payable returns (bool success) {}
	function withdraw(address _who, address _exchange, address _token, uint _amount) returns (bool success) {}
	function order(address _who, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns (bool success) {}
	function orderCFD(address _who, address _exchange, address _cfd, uint32 id, bool _is_stable, uint32 _adjustment, uint128 _stake) returns (bool success) {}
	function dealCFD(address _who, address _exchange, address _cfd, uint32 order, address stable, address leveraged, bool _is_stable, uint32 id, uint64 strike, uint128 _stake) returns (bool success) {}
	function trade(address _who, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint amountGive, uint expires, address user, uint amount) returns (bool success) {}
	function cancelOrder(address _who, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns (bool success) {}
	function cancel(address _who, address _exchange, address _cfd, uint32 _id) returns (bool success) {}
	function finalize(address _who, address _exchange, address _cfd, uint24 _id) returns (bool success) {}
	function addCredits(address _who, address _exchange, address _stable, uint _stable_gets, address _leveraged, uint _leveraged_gets, uint24 id) returns (bool success) {}
}

contract ExchangeFace {
    
	// EVENTS

	event Deposit(address token, address user, uint amount, uint balance);
	event Withdraw(address token, address user, uint amount, uint balance);
	event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user);
	event OrderPlaced(address indexed cfd, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
    event OrderMatched(address indexed cfd, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user);
	event OrderCancelled(address indexed cfd, uint32 indexed id, address indexed who, uint128 stake);
	event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user);
	event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
	event DealFinalized(address indexed cfd, address indexed stable, address indexed leveraged, uint64 price);

	// METHODS

	function deposit(address _token, uint _amount) payable returns (bool success) {}
	function withdraw(address _token, uint _amount) returns (bool success) {}
	function order(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns (uint id) {}
	function orderCFD(address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) returns (uint32 id) {}
	function trade(address _tokenGet, uint _amountGet, address _tokenGive, uint amountGive, uint expires, address user, uint amount) {}
	function cancelOrder(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) {}
	function cancel(address _cfd, uint32 _id) {}
	function finalize(address _cfd, uint24 _id) {}
	function addCredits(address _stable, uint _stable_gets, address _leveraged, uint _leveraged_gets, uint24 id) returns (bool success) {}
	function setExchange (address _cfd) {}
	
	function balanceOf(address token, address user) constant returns (uint) {}
	function balanceOf(address _who) constant returns (uint) {}
	function marginOf(address _who) constant returns (uint) {}
	function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user) constant returns(uint) {}
	function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user) constant returns(uint) {}
	function getLastOrderId() constant returns (uint) {}
	function isActive(uint id) constant returns (bool) {}
	function getOwner(uint id) constant returns (address) {}
	function getOrder(uint id) constant returns (uint, ERC20, uint, ERC20) {}
	function getExchangeEventful() constant returns (address) {}
}

contract CFDExchange is ExchangeFace, SafeMath, Owned {

	struct Receipt {
		uint units;
		uint32 activation;
		uint margin;
	}

	struct Account {
		uint256 balance;
		mapping (uint => Receipt) receipt;
		mapping (address => uint) allowanceOf;
	}

	// EVENTS

	event Deposit(address token, address user, uint amount, uint balance);
  	event Withdraw(address token, address user, uint amount, uint balance);
	//event OrderPlaced(address indexed cfd, uint32 id, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	//event OrderMatched(address indexed cfd, uint32 id, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(address indexed cfd, uint32 id, address indexed who, uint128 stake);
	event DealFinalized(address indexed cfd, uint32 id, address indexed stable, address indexed leveraged);

	// MODIFIERS
 
	modifier only_owner { if (msg.sender != owner) return; _; } 
	modifier margin_ok(address _cfd, uint _margin) { CFD cfd = CFD(_cfd); if (tokens[address(0)][msg.sender] / cfd.getMaxLeverage() < _margin) return; _; }
	modifier ether_only(address _token) { if (_token != address(0)) throw; _; }
	modifier minimum_stake(uint _amount) { if (_amount < min_order) throw; _; }
    modifier approved_who_only(address _who) { Authority auth = Authority(authority); if (auth.isWhitelistedUser(_who) || auth.isWhitelistedDrago(_who)) _; }
    modifier approved_asset(address _asset) { Authority auth = Authority(authority); if (auth.isWhitelistedAsset(_asset)) _; }
    //modifier is_cfd { if (!cfds[msg.sender].approved) throw; _; } //for now we use the approved_asset modifier
    
    // METHODS
    	
    function CFDExchange(address _authority) {
        authority = _authority;
    }

	function deposit(address _token, uint256 _amount) payable ether_only(_token) minimum_stake(msg.value) returns (bool success) {
		tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value);
		ExchangeEventful eventful = ExchangeEventful(getExchangeEventful());
		require(eventful.deposit(msg.sender, this, _token, _amount));
		Deposit(0, msg.sender, msg.value, tokens[address(0)][msg.sender]);
		return true;
	}

	function withdraw(address _token, uint256 _amount) ether_only(_token) minimum_stake(_amount) returns (bool success) {
		if (tokens[address(0)][msg.sender] < _amount) throw;
		tokens[address(0)][msg.sender] = safeSub(tokens[address(0)][msg.sender], _amount);
		if (!msg.sender.call.value(_amount)()) throw;
		ExchangeEventful eventful = ExchangeEventful(getExchangeEventful());
		require(eventful.withdraw(msg.sender, this, _token, _amount));
		Withdraw(0, msg.sender, _amount, tokens[address(0)][msg.sender]);
		return true;
	}

	function orderCFD(address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) margin_ok(_cfd, _stake) minimum_stake(_stake) approved_asset(_cfd) approved_who_only(msg.sender) returns (uint32 id) {
		CFD cfd = CFD(_cfd);
		if (!cfd.orderExchange(_is_stable, _adjustment, _stake, msg.sender)) return;
		tokens[address(0)][msg.sender] = safeSub(tokens[address(0)][msg.sender], uint(_stake)) / cfd.getMaxLeverage();
		accounts[msg.sender].balance = safeAdd(accounts[msg.sender].balance, uint(_stake)) / cfd.getMaxLeverage();
		return uint32(cfd.getLastOrderId());
	}

	function cancel(address _cfd, uint32 _id) approved_asset(_cfd) {
		CFD cfd = CFD(_cfd);
		var stake = cfd.orderDetails(_id);
		if (msg.sender != cfd.getOrderOwner(_id)) throw;
		if (!cfd.cancelExchange(_id, msg.sender)) return;
		tokens[address(0)][msg.sender] += stake / cfd.getMaxLeverage();
		accounts[msg.sender].balance -= stake / cfd.getMaxLeverage();
		ExchangeEventful eventful = ExchangeEventful(getExchangeEventful());
		require(eventful.cancel(msg.sender, this, _cfd, _id));
		OrderCancelled(_cfd, _id, msg.sender, stake);
	}

	function finalize(address _cfd, uint24 _id) approved_asset(_cfd) {
		CFD cfd = CFD(_cfd);
		if (msg.sender != cfd.getStable(_id) || msg.sender != cfd.getLeveraged(_id)) throw;
		if (!cfd.finalizeExchange(_id, msg.sender)) return;
		//cfd has callback to addCredits of P&L
		ExchangeEventful eventful = ExchangeEventful(getExchangeEventful());
		require(eventful.finalize(msg.sender, this, _cfd, _id));
		DealFinalized(_cfd, _id, cfd.getStable(_id), cfd.getLeveraged(_id));
	}
	
	function addCredits(address stable, uint stable_gets, address leveraged, uint leveraged_gets, uint24 id) approved_asset(msg.sender) returns (bool success) {
	    tokens[address(0)][stable] += stable_gets;
	    tokens[address(0)][leveraged] += leveraged_gets;
	    CFD cfd = CFD(msg.sender);
	    var depositClaim = cfd.getDealStake(id) / cfd. getDealLev(id); //accounts are decreased by the margin
	    accounts[stable].balance -= depositClaim;
	    accounts[leveraged].balance -= depositClaim;
	    return true;
	}

	function setCfdMaxLeverage(address _cfd, uint _maxLeverage) only_owner {
	    CFD cfd = CFD(_cfd);
	    cfd.setMaxLeverage(_maxLeverage);
	}
	
	function setExchange (address _cfd) {
	    CFD cfd = CFD(_cfd);
	    cfd.setExchange(this);
	}

	function balanceOf(address _who) constant returns (uint) {
	    uint totalBalance = tokens[address(0)][_who] + accounts[_who].balance;
		return totalBalance;
	}
	
	function marginOf(address _who) constant returns (uint) {
	    return tokens[address(0)][_who]; //free margin
	}
	
	function balanceOf(address _token, address _who) constant returns (uint) {
    		return tokens[_token][_who];
  	}
  	
  	function getBestAdjustment(address _cfd, bool _is_stable) constant returns (uint32) {
  		CFD cfd = CFD(_cfd);
		uint32 bestAdjustment = cfd.bestAdjustment(_is_stable);
		return bestAdjustment;
  	}

	function getBestAdjustmentFor(address _cfd, bool _is_stable, uint128 _stake) constant returns (uint32) {
		CFD cfd = CFD(_cfd);
		uint32 bestAdjustmentFor = cfd.bestAdjustmentFor(_is_stable, _stake);
		return bestAdjustmentFor;
	}
	
	function getExchangeEventful() constant returns (address) {
	    Authority auth = Authority(authority);
	    return auth.getExchangeEventful();
	}
	
	mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
  	//mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
  	//mapping (address => mapping (bytes32 => uint)) public orderFills; //can group in Struct
  	mapping (address => Account) accounts;
  	//mapping (uint => ExchangeId) exchangeOrders;
  	//uint public feeMake; //percentage times (1 ether)
  	//uint public feeTake; //percentage times (1 ether)
  	//uint public feeRebate;
	uint min_order = 100 finney;
	//uint public next_id;
  	//address public feeAccount; //the account that will receive fees
  	//address public accountLevelsAddr;
  	address public authority;
	//address public signer = msg.sender;
}
