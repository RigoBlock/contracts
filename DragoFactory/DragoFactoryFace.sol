//! DragoFactory Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract DragoFactoryFace {
    
	// EVENTS

	event DragoCreated(string _name, address _drago, address _dragowner, uint _dragoID);
	event DragoRegistered(address indexed _drago, string _name, string _symbol, uint _dragoID, address indexed owner);
	event NewRegistry(address indexed dragoRegistry, address indexed _newRegistry);
	event SetBeneficiary(address indexed dragoDAO, address indexed _dragoDAO);
	event SetFee(uint fee, uint _fee);
    
	// METHODS
    
	function createDrago(string _name, string _symbol) returns (address _drago, uint _dragoID) {}
	function setRegistry(address _newRegistry) {}
	function setBeneficiary(address _dragoDAO) {}
	function setFee(uint _fee) {}
	function drain() {}
    
	function getRegistry() constant returns (address) {}
	function getBeneficiary() constant returns (address) {}
	function getVersion() constant returns (string) {}
	function getLastId() constant returns (uint) {}
}
