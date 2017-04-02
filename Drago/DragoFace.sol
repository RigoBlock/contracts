//! Drago Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract DragoFace is ERC20Face {
    
	function buy() payable returns (uint amount) {}
	function sell(uint256 amount) returns (uint revenue, bool success) {}  
	function changeRatio(uint256 _ratio) onlyDragator {}  
	function setTransactionFee(uint _transactionFee) onlyDragowner {}  
	function changeFeeCollector(address _feeCollector) onlyDragowner {}
	function changeDragator(address _dragator) onlyDragator {}
	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {}
	
	function balanceOf(address _from) constant returns (uint256 balance) {}
}

contract DragoAdmin is DragoFace {
    
	function DragoAdmin(string _dragoName,  string _dragoSymbol, address _dragowner) {}
	function depositToExchange(address exchange, address _who) /*when_approved_exchange*/ payable returns(bool success) {}
	function withdrawFromExchange(address exchange, uint value) returns (bool success) {}
	function placeOrderExchange(address exchange, bool is_stable, uint32 adjustment, uint128 stake) {}
	function cancelOrderExchange(address exchange, uint32 id) {}
	function finalizeDealExchange(address exchange, uint24 id) {}
	function() payable {}
}
