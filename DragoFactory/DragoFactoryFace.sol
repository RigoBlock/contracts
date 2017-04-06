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
    function sellDrago(address targetDragoo, uint256 amount) {}
    function changeRatio(address targetDragoo, uint256 _ratio) {}
    function setTransactionFee(address targetDragoo, uint _transactionFee) {}
    function changeFeeCollector(address targetDragoo, address _feeCollector) {}
    function changeDragator(address targetDragoo, address _dragator) {}
    function depositToExchange(address targetDragoo, address exchange, address _who) /*when_approved_exchange*/ payable returns(bool success) {}
    function withdrawFromExchange(address targetDragoo, address exchange, uint value) returns (bool success) {}
    function placeOrderExchange(address targetDragoo, address exchange, bool is_stable, uint32 adjustment, uint128 stake) {}
    function cancelOrderExchange(address targetDragoo, address exchange, uint32 id) {}  
    function finalizedDealExchange(address targetDragoo, address exchange, uint24 id) {}
    
    function getVersion() constant returns (string version) {}
    function geeLastId() constant returns (uint _dragoID) {}
    function getDragoDAO() constant returns (uint dragoDAO) {}
}
