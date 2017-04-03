//! Drago Registry Interface contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract DragoRegistryFace {

	event Registered(string indexed tla, uint indexed id, address addr, string name);
	event Unregistered(string indexed tla, uint indexed id);
	event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);
        
	function register(address _drago, uint _dragoID) {}	
	function register(address _addr, string _tla, uint _base, string _name) payable returns (bool) {}
	function unregister(uint _id) only_owner {}
	
	function accountOf(uint _dragoID) constant returns (address) {}   
	function dragoOf(address _drago) constant returns (uint) {}
	function tokenCount() constant returns (uint) {}
	function token(uint _id) constant returns (address addr, string tla, uint base, string name, address owner) {}
	function fromAddress(address _addr) constant returns (uint id, string tla, uint base, string name, address owner) {}
	function fromTLA(string _tla) constant returns (uint id, address addr, uint base, string name, address owner) {}
	function meta(uint _id, bytes32 _key) constant returns (bytes32) {}
	function setMeta(uint _id, bytes32 _key, bytes32 _value) only_token_owner(_id) {}
}
