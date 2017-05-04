//! Drago Factory contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! This contract uses one library and has more room for storage.

pragma solidity ^0.4.10;

contract DragoFactoryFace {
    
	// EVENTS

	event DragoCreated(string name, string symbol, address indexed drago, address indexed owner, uint dragoID);

	// METHODS

	function createDrago(string _name, string _symbol) returns (bool) {}
	function setDragoDAO(address _targetDrago, address _dragoDAO) {}
	function setRegistry(address _newRegistry) {}
	function setBeneficiary(address _dragoDAO) {}
	function setFee(uint _fee) {}
	function drain() {}
	function setOwner(address _new) {}
    
	function getRegistry() constant returns (address) {}
	function getStorage() constant returns (address dragoDAO, string version, uint nextDragoID) {}
	function getNextID() constant returns (uint nextDragoID) {}
	function getDragoDAO() constant returns (address dragoDAO) {}
	function getVersion() constant returns (string version) {}
	function getDragosByAddress(address _owner) constant returns (address[]) {}
	function getOwner() constant returns (address) {}
}
