//! Drago Admin Interface library.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

library DragoAdminFace {

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
	event DragoCreated(string _name, string _symbol, address _drago, address _dragowner, uint _dragoID);
	
	// METHODS
	
	function buyDrago(address targetDrago) returns (uint amount) {}
	function sellDrago(address targetDrago, uint256 amount) returns (uint revenue) {}
	function setDragoPrice(address _targetDrago, uint _sellPrice, uint _buyPrice) {}
	function changeRatio(address _targetDrago, uint256 _ratio) {}
	function setTransactionFee(address _targetDrago, uint _transactionFee) {}
	function changeFeeCollector(address _targetDrago, address _feeCollector) {}
	function changeDragoDAO(address _targetDrago, address _dragoDAO) {}
	function depositToExchange(address targetDrago, address exchange, address token, uint256 value) returns(bool) {}
	function depositToCFDExchange(address _targetDrago, address _cfdExchange) returns(bool) {}
	function withdrawFromExchange(address targetDrago, address exchange, address token, uint256 value) returns (bool) {}
	function withdrawFromCFDExchange(address _targetDrago, address _cfdExchange, uint amount) returns(bool) {}
	function placeOrderExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {}
	function placeTradeExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce, address _user, uint8 _v, bytes32 _r, bytes32 _s, uint _amount) {}
	function placeOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, bool is_stable, uint32 adjustment, uint128 stake) {}
	function cancelOrderExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {}
	function cancelOrderCFDExchange(address targetDrago, address _cfdExchange, address _cfd, uint32 id) {}
	function finalizedDealExchange(address targetDrago, address exchange, uint24 id) {}
	function createDrago(address _dragoFactory, string _name, string _symbol) returns (address _drago, uint _dragoID) {}
} 
