//! Drago Registry Interface contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract DragoRegistryFace {

	//EVENTS

	event Registered(string indexed symbol, uint indexed id, address addr, string name);
	event Unregistered(string indexed symbol, uint indexed id);
	event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);
	
	// METHODS
        
	function register(address _drago, uint _dragoID) {}	
	function register(address _drago, string _symbol, uint _base, string _name) payable returns (bool) {}
	function unregister(uint _id) {}
	function setMeta(uint _id, bytes32 _key, bytes32 _value) {}
	function setFee(uint _fee) {}
	function drain() {}
	
	function accountOf(uint _dragoID) constant returns (address) {}   
	function dragoOf(address _drago) constant returns (uint) {}
	function dragoCount() constant returns (uint) {}
	function drago(uint _id) constant returns (address drago, string symbol, uint base, string name, address owner) {}
	function fromAddress(address _drago) constant returns (uint id, string symbol, uint base, string name, address owner) {}
	function fromSymbol(string _symbol) constant returns (uint id, address drago, uint base, string name, address owner) {}
	function fromName(string _name) constant returns (uint id, string symbol, address drago, uint base, address owner) {}
	function meta(uint _id, bytes32 _key) constant returns (bytes32) {}
}
