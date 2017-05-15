//! Nav Estimate contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! exchange list has to be input, this estimate is performed outside of drago.

pragma solidity ^0.4.11;

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
	function cancelOrder(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) {}
	function cancel(address _cfd, uint32 _id) {}
	function finalize(address _cfd, uint24 _id) {}

	function balanceOf(address token, address user) constant returns (uint256) {}
	function balanceOf(address _who) constant returns (uint256) {}
	function marginOf(address _who) constant returns (uint) {}
	function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user) constant returns(uint) {}
	function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user) constant returns(uint) {}
	function getLastOrderId() constant returns (uint) {}
	function isActive(uint id) constant returns (bool) {}
	function getOwner(uint id) constant returns (address) {}
	//function getOrder(uint id) constant returns (uint, ERC20, uint, ERC20) {}
}

contract Drago {

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
	function placeOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) {}
	function placeTradeExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, address _user, uint _amount) {}
	function placeOrderCFDExchange(address _exchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) {}
	function cancelOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) {}
	function cancelOrderCFDExchange(address _exchange, address _cfd, uint32 _id) {}
	function finalizeDealCFDExchange(address _exchange, address _cfd, uint24 _id) {}
	function setOwner(address _new) {}
	function() payable {}   // only_approved_exchange(msg.sender)

	function balanceOf(address _who) constant returns (uint) {}
	function totalSupply() constant returns (uint) {}
	function getEventful() constant returns (address) {}
	function getData() constant returns (string name, string symbol, uint sellPrice, uint buyPrice, uint totalSupply) {}
	function getAdminData() constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {}
	function getOwner() constant returns (address) {}
}

contract NAVFace {

  function estimateNAV() constant returns (uint) {}
}

contract NAV is SafeMath, NAVFace {

    function estimateAUM(address _drago, address[] _exchanges) constant returns (uint nav) {
        Drago drago = Drago(_drago);
        for (uint i = 0; i < _exchanges.length; ++i) {
            Exchange exchange = Exchange(_exchanges[i]);
            uint deposits = exchange.balanceOf(_drago);
            uint dragoBalance = _drago.balance;
            uint aum = safeAdd(deposits, dragoBalance);
            return nav = safeDiv(aum, drago.totalSupply());
        }  
    }
}
