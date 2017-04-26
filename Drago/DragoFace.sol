//! Drago Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract DragoFace {

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	
 	function Drago(string _dragoName,  string _dragoSymbol) {}
	function() payable {}
	function buy() payable returns (uint amount) {}
	function sell(uint256 amount) returns (uint revenue, bool success) {}
	function changeRefundActivationPeriod(uint32 _refundActivationPeriod) {}
	function changeRatio(uint256 _ratio) {}
	function setTransactionFee(uint _transactionFee) {}
	function changeFeeCollector(address _feeCollector) {}
	function changeDragator(address _dragator) {}
	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) {}
	function DragoAdmin(string _dragoName,  string _dragoSymbol, address _dragowner) {}
	function depositToExchange(address exchange, address token, uint256 value) payable returns(bool success) {}
	function depositToCFDExchange(address _cfdExchange) payable returns(bool success) {}
	function withdrawFromExchange(address exchange, address token, uint256 value) returns (bool success) {}
	function withdrawFromCFDExchange(address _cfdExchange, uint amount) payable returns(bool success) {}
	function placeOrderExchange() {}
	function placeOrderCFDExchange(address _cfdExchange, address _cfd, bool is_stable, uint32 adjustment, uint128 stake) {}
	function cancelOrderExchange() {}
	function cancelOrderCFDExchange(address _cfdExchange, address _cfd, uint32 id) {}	
	function finalizeDealCFDExchange(address _cfdExchange, address _cfd, uint24 id) {}

	function balanceOf(address _from) constant returns (uint256) {}
	function getName() constant returns (string name) {}
	function getSymbol() constant returns (string symbol) {}
	function getPrice() constant returns (uint256 price) {}
	function getTransactionFee() constant returns (uint256 transactionFee) {}
	function getFeeCollector() constant returns (address feeCollector) {}
}
