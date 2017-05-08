//! CFD contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

contract CFDFace {

  	// EVENTS
	
	event Deposit(address indexed who, uint value);
	event Withdraw(address indexed who, uint value);
	event OrderPlaced(uint32 indexed id, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	event OrderMatched(uint32 indexed id, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(uint32 indexed id, address indexed who, uint128 stake);
	event DealFinalized(uint32 indexed id, address indexed stable, address indexed leveraged, uint64 price);

	// METHODS

	function orderExchange(bool is_stable, uint32 adjustment, uint128 stake, address who) returns (bool success) {}
	function cancelExchange(uint32 id, address who) returns (bool success) {}
	function finalizeExchange(uint24 id, address who) returns (bool success) {}
	function setMaxLeverage(uint maxLeverage) {}
	function setExchange (address _exchange) {}

	function bestAdjustment(bool _is_stable) constant returns (uint32) {}
	function bestAdjustmentFor(bool _is_stable, uint128 _stake) constant returns (uint32) {}
	function dealDetails(uint32 _id) constant returns (address stable, address leveraged, uint64 strike, uint128 stake, uint32 end_time, uint VAR) {}
	function orderDetails(uint32 _id) constant returns (uint128) {}
	function balanceOf(address _who) constant returns (uint) {}
	function getMaxLeverage() constant returns (uint) {}
	function getLastOrderId() constant returns (uint) {}
	function getOrderOwner(uint32 _id) constant returns (address) {}
	function getStable(uint32 _id) constant returns (address) {}
	function getLeveraged(uint32 _id) constant returns (address) {}
	function getDealStake(uint32 _id) constant returns (uint128) {}
	function getDealLev(uint32 _id) constant returns (uint) {}
}
