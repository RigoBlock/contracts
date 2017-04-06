//! DragoFactory Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Owned {
	event NewOwner(address indexed old, address indexed current);
	function setOwner(address _new) {}	
	function getOwner() constant returns (address owner) {}
}

contract DragoFactoryFace is Owned {

	event DragoCreated(string _name, address _drago, address _dragowner, uint _dragoID);

	function createDrago(string _name, string _symbol, address _dragowner) returns (address _drago, uint _dragoID) {}
	function setFee(uint _fee) {}
	function setBeneficiary(address _dragoDAO) {}
	function drain() {}
	function() {}
	function buyDrago(address targetDrago) payable {}
	function sellDrago(address targetDrago, uint256 amount) {}
	function changeRatio(address targetDrago, uint256 _ratio) {}
	function setTransactionFee(address targetDrago, uint _transactionFee) {}
	function changeFeeCollector(address targetDrago, address _feeCollector) {}
	function changeDragator(address targetDrago, address _dragator) {}
	function depositToExchange(address targetDrago, address exchange, address _who) payable returns(bool success) {}
	function withdrawFromExchange(address targetDrago, address exchange, uint value) returns (bool success) {}
	function placeOrderExchange(address targetDrago, address exchange, bool is_stable, uint32 adjustment, uint128 stake) {}
	function cancelOrderExchange(address targetDrago, address exchange, uint32 id) {}  
	function finalizedDealExchange(address targetDrago, address exchange, uint24 id) {}
    
	function getVersion() constant returns (string version) {}
	function geeLastId() constant returns (uint _dragoID) {}
	function getDragoDAO() constant returns (uint dragoDAO) {}
}
