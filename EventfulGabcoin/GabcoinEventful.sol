//! Gabcoin Eventful contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Collects all events from all gabcoins

pragma solidity ^0.4.11;

contract Gabcoin {

	event Buy(address indexed from, address indexed to, uint256 indexed amount, uint256 revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed amount,uint256 revenue);
	event DepositCasper(uint amount, address indexed who, address indexed validation, address indexed withdrawal);
 	event WithdrawCasper(uint deposit, address indexed who, address casper);
 
	function() payable {}
	function deposit(address _token, uint _amount) payable returns (bool success) {}
	function withdraw(address _token, uint _amount) returns (bool success) {}
	function buyGabcoin() payable returns (bool success) {}
	function sellGabcoin(uint256 amount) returns (bool success) {}
	function depositCasper(address _validation, address _withdrawal, uint _amount) returns (bool success) {}
    function withdrawCasper(uint _validatorIndex) {}
	function changeRatio(uint256 _ratio) {}	
	function setTransactionFee(uint _transactionFee) {}	
	function changeFeeCollector(address _feeCollector) {}	
	function changeGabcoinDAO(address _gabcoinDAO) {}

	function balanceOf(address _from) constant returns (uint) {}
	function getVersion() constant returns (string) {}
	function getName() constant returns (string) {}
	function getSymbol() constant returns (string) {}
	function getPrice() constant returns (uint256) {}
	function getCasper() constant returns (address) {}
	function getTransactionFee() constant returns (uint) {}
	function getFeeCollector() constant returns (address) {}
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

contract GabcoinEventfulFace {

	// EVENTS

    event BuyGabcoin(address indexed gabcoin, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event SellGabcoin(address indexed gabcoin, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event NewFee(address indexed gabcoin, address indexed from, address indexed to, uint fee);
	event NewCollector(address indexed gabcoin, address indexed from, address indexed to, address collector);
	event GabcoinDAO(address indexed gabcoin, address indexed from, address indexed to, address gabcoinDAO);
	event DepositCasper(address indexed gabcoin, address indexed validator, address indexed casper, address withdrawal, uint amount);
	event WithdrawCasper(address indexed gabcoin, address indexed validator, address indexed casper, uint validatorIndex);
	event GabcoinCreated(address indexed gabcoin, address indexed group, address indexed owner, uint gabcoinID, string name, string symbol);

    // METHODS

    function buyGabcoin(address _who, address _targetGabcoin, uint _value, uint _amount) returns (bool success) {}
    function sellGabcoin(address _who, address _targetGabcoin, uint _amount, uint _revenue) returns(bool success) {}
    function changeRatio(address _who, address _targetGabcoin, uint256 _ratio) returns(bool success) {}
    function setTransactionFee(address _who, address _targetGabcoin, uint _transactionFee) returns(bool success) {}
    function changeFeeCollector(address _who, address _targetGabcoin, address _feeCollector) returns(bool success) {}
    function changeGabcoinDAO(address _who, address _targetGabcoin, address _gabcoinDAO) returns(bool success) {}
    function depositToCasper(address _who, address _targetGabcoin, address _casper, address _validation, address _withdrawal, uint _amount) returns(bool success) {}
    function withdrawFromCasper(address _who, address _targetGabcoin, address _casper, uint _validatorIndex) returns(bool success) {}
    function createGabcoin(address _who, address _gabcoinFactory, address _newGabcoin, string _name, string _symbol, uint _gabcoinId, address _owner) returns(bool success) {}
}
      
contract GabcoinEventful is GabcoinEventfulFace {

    event BuyGabcoin(address indexed gabcoin, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event SellGabcoin(address indexed gabcoin, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event NewFee(address indexed gabcoin, address indexed from, address indexed to, uint fee);
	event NewCollector(address indexed gabcoin, address indexed from, address indexed to, address collector);
	event GabcoinDAO(address indexed gabcoin, address indexed from, address indexed to, address gabcoinDAO);
	event DepositCasper(address indexed gabcoin, address indexed validator, address indexed casper, address withdrawal, uint amount);
	event WithdrawCasper(address indexed gabcoin, address indexed validator, address indexed casper, uint validatorIndex);
	event GabcoinCreated(address indexed gabcoin, address indexed group, address indexed owner, uint gabcoinID, string name, string symbol);

   	modifier approved_factory_only(address _factory) { Authority auth = Authority(authority); if (auth.isWhitelistedFactory(_factory)) _; }
   	modifier approved_gabcoin_only(address _gabcoin) { Authority auth = Authority(authority); if (auth.isWhitelistedGabcoin(_gabcoin)) _; }
    modifier is_casper(address _casper) { Authority auth = Authority(authority); if (auth.getCasper() == _casper) _; }
    modifier approved_user_only(address _user) { Authority auth = Authority(authority); if (auth.isWhitelistedUser(_user)) _; }

    function GabcoinEventful(address _authority) {
	    authority = _authority;
	}

	function buyGabcoin(address _who, address _targetGabcoin, uint _value, uint _amount) approved_gabcoin_only(_targetGabcoin) returns (bool success) {
		//if (_value < 100 finney) throw; //duplicate from before
		if (msg.sender != _targetGabcoin) return;
		BuyGabcoin(_targetGabcoin, _who, msg.sender, _value, _amount);
		return true;
	}

	function sellGabcoin(address _who, address _targetGabcoin, uint _amount, uint _revenue) approved_gabcoin_only(_targetGabcoin) returns(bool success) {
		if(_amount < 0) throw;
		//Gabcoin gabcoin = Gabcoin(_targetGabcoin);
		if (msg.sender != _targetGabcoin) return;
		//if (gabcoin.balanceOf(_who) < _amount) return; //this might be lifted as it's checked in the previous sell
		SellGabcoin(_targetGabcoin, msg.sender, _who, _amount, _revenue);
		return true;
	}
    
	function setTransactionFee(address _who, address _targetGabcoin, uint _transactionFee) approved_gabcoin_only(_targetGabcoin) approved_user_only(_who) returns(bool success) {
		//Gabcoin gabcoin = Gabcoin(_targetGabcoin);
		if (msg.sender != _targetGabcoin) return;
		//if (_who != gabcoin.getOwner()) return;
		NewFee(_targetGabcoin, msg.sender, _who, _transactionFee);
		return true;
	}

	function changeFeeCollector(address _who, address _targetGabcoin, address _feeCollector) approved_gabcoin_only(_targetGabcoin) approved_user_only(_who) returns(bool success) {
		//Gabcoin gabcoin = Gabcoin(_targetGabcoin);
		if (msg.sender != _targetGabcoin) return;
		//if (_who != gabcoin.getOwner()) return;
		NewCollector(_targetGabcoin, msg.sender, _who, _feeCollector);
		return true;
	}
	
	function changeGabcoinDAO(address _who, address _targetGabcoin, address _gabcoinDAO) approved_gabcoin_only(_targetGabcoin) approved_user_only(_who) returns(bool success) {
	    if (msg.sender != _targetGabcoin) return;
	    GabcoinDAO(_targetGabcoin, msg.sender, _who, _gabcoinDAO);
	    return true;
	}
    
    function depositToCasper(address _who, address _targetGabcoin, address _casper, address _validation, address _withdrawal, uint _amount) approved_gabcoin_only(_targetGabcoin) approved_user_only(_who) returns(bool success) {
        if (msg.sender != _targetGabcoin) return;
        DepositCasper(_targetGabcoin, _validation, _casper, _withdrawal, _amount);
	return true;
    }
    
    function withdrawFromCasper(address _who, address _targetGabcoin, address _casper, uint _validatorIndex) approved_gabcoin_only(_targetGabcoin) approved_user_only(_who) returns(bool success) {
        if (msg.sender != _targetGabcoin) return;
        WithdrawCasper(_targetGabcoin, _who, _casper, _validatorIndex);
	return true;
    }
	
	function createGabcoin(address _who, address _gabcoinFactory, address _newGabcoin, string _name, string _symbol, uint _gabcoinID, address _owner) approved_factory_only(_gabcoinFactory) returns(bool success) {
	    	if (msg.sender != _gabcoinFactory) return;
	    	GabcoinCreated(_newGabcoin, _gabcoinFactory, _owner, _gabcoinID, _name, _symbol);
	    	return true;
	}
	
	address public authority;
	string constant public version = 'DH 0.2.1';
}
