//! Exchange Eventful Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Collects all events from all all assets listed on oour exchange

pragma solidity ^0.4.11;

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
	function orderCFD(address _who, address _exchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) returns (bool success) {}
	function trade(address _who, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint amountGive, uint expires, address user, uint amount) returns (bool success) {}
	function cancelOrder(address _who, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns (bool success) {}
	function cancel(address _who, address _exchange, address _cfd, uint32 _id) returns (bool success) {}
	function finalize(address _who, address _exchange, address _cfd, uint24 _id) returns (bool success) {}
	function addCredits(address _who, address _exchange, address _stable, uint _stable_gets, address _leveraged, uint _leveraged_gets, uint24 id) returns (bool success) {}
}
