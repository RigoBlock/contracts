//! Drago Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract DragoFace {
    
	// METHODS

 	function Drago(string _dragoName,  string _dragoSymbol, uint _dragoID) {}
	function() payable {}
	function buyDrago() payable returns (bool success) {}
	function sellDrago(uint256 amount) returns (uint revenue, bool success) {}
	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) {}
	function changeRefundActivationPeriod(uint32 _refundActivationPeriod) {}
	function changeRatio(uint256 _ratio) {}
	function setTransactionFee(uint _transactionFee) {}
	function changeFeeCollector(address _feeCollector) {}
	function changeDragator(address _dragator) {}
	function depositToExchange(address exchange, address _token, uint256 _value) payable returns(bool success) {}
	function depositToCFDExchange(address _cfdExchange, uint256 _value) payable returns(bool success) {}
	function withdrawFromExchange(address exchange, address token, uint256 value) returns (bool success) {}
	function withdrawFromCFDExchange(address _cfdExchange, uint amount) returns(bool success) {}
	function placeOrderExchange() {}
	function placeTradeExchange() {}
	function placeOrderCFDExchange(address _cfdExchange, address _cfd, bool is_stable, uint32 adjustment, uint128 stake) {}
	function cancelOrderExchange() {}
	function cancelOrderCFDExchange(address _cfdExchange, address _cfd, uint32 id) {}	
	function finalizeDealCFDExchange(address _cfdExchange, address _cfd, uint24 id) {}

	function balanceOf(address _from) constant returns (uint256) {}
	function getName() constant returns (string) {}
	function getSymbol() constant returns (string) {}
	function getPrice() constant returns (uint256 sellPrice, uint256 buyPrice) {}
	function getSupply() constant returns (uint256) {}
	function getTransactionFee() constant returns (uint256) {}
	function getFeeCollector() constant returns (address) {}
	function getRefundActivationPeriod() constant returns (uint32) {}
}
