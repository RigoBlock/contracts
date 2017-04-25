//! CFD Exchange Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract CFDExchangeFace {

	// EVENTS
	
	event Deposit(address token, address user, uint amount, uint balance);
  	event Withdraw(address token, address user, uint amount, uint balance);
	event OrderPlaced(address indexed cfd, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	event OrderMatched(address indexed cfd, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(address indexed cfd, address indexed who, uint128 stake);
	event DealFinalized(address indexed cfd, address indexed stable, address indexed leveraged, uint64 price);

	// METHODS

	function deposit() payable {}
	function withdraw(uint256 amount) {}
	function orderCFD(address _cfd, bool is_stable, uint32 adjustment, uint128 stake) {}	//returns(uint id)
	function cancel(address _cfd, uint32 id) {}	//function cancel(uint id) returns (bool) {}
	function finalize(address _cfd, uint24 id) {}
	function moveOrder(address _cfd, uint24 id, bool is_stable, uint32 adjustment) returns (bool) {}
	
	function balanceOf(address _who) constant returns (uint256) {}
	function getLastOrderId() constant returns (uint) {}
	function isActive(uint id) constant returns (bool active) {}
	function getOwner(uint id) constant returns (address owner) {}
}
