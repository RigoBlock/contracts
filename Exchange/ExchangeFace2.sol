//! CFD Exchange Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.11;

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
