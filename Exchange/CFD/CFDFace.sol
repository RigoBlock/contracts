//! CFD Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract CFDFace {

  	// EVENTS
	
	event Deposit(address indexed who, uint value);
	event Withdraw(address indexed who, uint value);
	event OrderPlaced(uint32 indexed id, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	event OrderMatched(uint32 indexed id, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(uint32 indexed id, address indexed who, uint128 stake);
	event DealFinalized(uint32 indexed id, address indexed stable, address indexed leveraged, uint64 price);

	// METHODS
	
	function deposit(address _who) payable {}
	function withdraw(uint value) returns (bool success) {}
	function orderExchange(bool is_stable, uint32 adjustment, uint128 stake) {}
	function order(bool is_stable, uint32 adjustment, uint128 stake) payable {}
	function cancelExchange(uint32 id) {}
	function cancel(uint32 id) {}
	function finalizeExchange(uint24 id) {}
	function finalize(uint24 id) {}
	
	function bestAdjustment(bool _is_stable) constant returns (uint32) {}
	function bestAdjustmentFor(bool _is_stable, uint128 _stake) constant returns (uint32) {}
	function dealDetails(uint32 _id) constant returns (address stable, address leveraged, uint64 strike, uint128 stake, uint32 end_time) {}
	function orderDetails(uint32 _id) constant returns (uint128 stake) {}
	function balanceOf(address _who) constant returns (uint) {}
}
