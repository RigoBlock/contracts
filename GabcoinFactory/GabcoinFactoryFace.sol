//! Gabcoin Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.11;

contract GabcoinFactoryFace {

	event GabcoinCreated(string _name, address _gabcoin, address _owner, uint _gabcoinID);

	function createGabcoin(string _name, string _symbol) returns (bool success) {}
	function setTargetGabcoinDAO(address _targetGabcoin, address _gabcoinDAO) {}
	function changeGabcoinDAO(address _newGabcoinDAO) {}
	function setRegistry(address _newRegistry) {}
	function setBeneficiary(address _gabcoinDAO) {}
	function setFee(uint _fee) {}
	function drain() {}

	function getRegistry() constant returns (address) {}
	function getStorage() constant returns (address gabcoinDAO, string version, uint nextGabcoinID) {}
	function getNextID() constant returns (uint nextGabcoinID) {}
	function getEventful() constant returns (address) {}
	function getGabcoinDAO() constant returns (address gabcoinDAO) {}
	function getVersion() constant returns (string) {}
	function getGabcoinsByAddress(address _owner) constant returns (address[]) {}
}
