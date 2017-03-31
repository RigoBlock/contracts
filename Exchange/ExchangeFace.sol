//! Exchange Interface.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract ExchangeFace {

	event Deposit(address indexed who, uint value);
	event Withdraw(address indexed who, uint value);
	event OrderPlaced(uint32 indexed id, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	event OrderMatched(uint32 indexed id, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(uint32 indexed id, address indexed who, uint128 stake);
	event DealFinalized(uint32 indexed id, address indexed stable, address indexed leveraged, uint64 price);

	function deposit(address _who) payable {}	
	function withdraw(uint value) returns (bool success) {}        
	function order(bool is_stable, uint32 adjustment, uint128 stake) payable {}
	function cancel(uint32 id) {}
	function finalize(uint24 id) {}
	
	function best_adjustment(bool _is_stable) constant returns (uint32) {}
	function best_adjustment_for(bool _is_stable, uint128 _stake) constant returns (uint32) {}
	function deal_details(uint32 _id) constant returns (address stable, address leveraged, uint64 strike, uint128 stake, uint32 end_time) {}
	function balance_of(address _who) constant returns (uint) {}
}
