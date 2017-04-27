//! Drago Admin Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract DragoAdminFace {

	// EVENTS

	event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event NAV(uint sellPrice, uint buyPrice);
	event DepositExchange(uint value, uint256 indexed _amount, address indexed who, address token , address indexed _exchange);
	event DepositCFDExchange(uint , uint256 indexed _amount, address indexed who, address , address indexed _cfdExchange);
	event WithdrawExchange(uint , uint256 indexed _amount, address indexed who, address , address indexed _cfdExchange);
	event WithdrawCFDExchange(uint , uint256 indexed _amount, address indexed who, address , address indexed _cfdExchange);
	event OrderCFD(address indexed _cfdExchange, address indexed _cfd);
	event CancelCFD(address indexed _cfdExchange, address indexed _cfd);
	event FinalizeCFD(address indexed _cfdExchange, address indexed _cfd);
	
	// METHODS
	
	function buyDrago(address targetDrago) payable returns (uint amount) {}
	function sellDrago(address targetDrago, uint256 amount) returns (uint revenue) {}
	function setDragoPrice(address _targetDrago, uint _sellPrice, uint _buyPrice) {}
	function changeRatio(address _targetDrago, uint256 _ratio) {}
	function setTransactionFee(address _targetDrago, uint _transactionFee) {}
	function changeFeeCollector(address _targetDrago, address _feeCollector) {}
	function changeDragator(address _targetDrago, address _dragator) {}
	function depositToExchange(address targetDrago, address exchange, address token, uint256 value) payable returns(bool) {}
	function depositToCFDExchange(address _targetDrago, address _cfdExchange) payable returns(bool) {}
	function withdrawFromExchange(address targetDrago, address exchange, address token, uint256 value) returns (bool) {}
	function withdrawFromCFDExchange(address _targetDrago, address _cfdExchange, uint amount) returns(bool) {}
	function placeOrderExchange() {}
	function placeTradeExchange() {}
	function placeOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, bool is_stable, uint32 adjustment, uint128 stake) {}
	function cancelOrderExchange() {}
	function cancelOrderCFDExchange(address targetDrago, address _cfdExchange, address _cfd, uint32 id) {}
	function finalizedDealExchange(address targetDrago, address exchange, uint24 id) {}
} 
