//! Drago Registry Interface contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.18;

contract DragoRegistryFace {

	//EVENTS

	event Registered(string name, string symbol, uint id, address indexed drago, address indexed owner, address indexed group);
	event Unregistered(string indexed symbol, uint indexed id);
	event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);
	
	// METHODS

	function register(address _drago, string _name, string _symbol, uint _dragoID, address _owner) public payable returns (bool) {}
	function registerAs(address _drago, string _name, string _symbol, uint _dragoID, address _owner, address _group) internal returns (bool) {} //amended to internal function
	function unregister(uint _id) public {}
	function setMeta(uint _id, bytes32 _key, bytes32 _value) public {}
	function setFee(uint _fee) public {}
	function upgrade(address _newAddress) public payable {} //payable as there is a transfer of value, otherwise opcode might throw an error
	function setUpgraded(uint _version) public {}
	function drain() public {}
	function kill() public {}

	function dragoCount() public constant returns (uint) {}
	function fromId(uint _id) public constant returns (address drago, string name, string symbol, uint dragoID, address owner, address group) {}
	function fromAddress(address _drago) public constant returns (uint id, string name, string symbol, uint dragoID, address owner, address group) {}
	function fromSymbol(string _symbol) public constant returns (uint id, address drago, string name, uint dragoID, address owner, address group) {}
	function fromName(string _name) public constant returns (uint id, address drago, string symbol, uint dragoID, address owner, address group) {}
	function fromNameSymbol(string _name, string _symbol) public constant returns (address) {}
	function getNameFromAddress(address _pool) external constant returns (string) {}
	function getSymbolFromAddress(address _pool) external constant returns (string) {}
	function meta(uint _id, bytes32 _key) public constant returns (bytes32) {}
	function getGroups(address _group) public constant returns (address[]) {}
	function getFee() public constant returns (uint) {}
}
