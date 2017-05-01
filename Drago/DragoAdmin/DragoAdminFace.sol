//! Drago Admin Interface library.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

library DragoAdminFace {

	// EVENTS

    event BuyDrago(address indexed drago, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event SellDrago(address indexed drago, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event NewNAV(address indexed drago, address indexed from, address indexed to, uint sellPrice, uint buyPrice);
	event DepositExchange(address indexed drago, address indexed exchange, address indexed token, uint value, uint256 amount);
	event WithdrawExchange(address indexed drago, address indexed exchange, address indexed token, uint value, uint256 amount);
	event OrderExchange(address indexed drago, address indexed exchange, address indexed cfd, uint value, uint revenue);
	event TradeExchange(address indexed drago, address indexed exchange, address tokenGet, address tokenGive, uint amountGet, uint amountGive, address get, address give);
	event CancelOrder(address indexed drago, address indexed exchange, address indexed cfd, uint value, uint id);
	event FinalizeDeal(address indexed drago, address indexed exchange, address indexed cfd, uint value, uint id);
	event DragoCreated(address indexed drago, address indexed group, address indexed owner, uint dragoID, string name, string symbol);
	
    // METHODS
	
    function buyDrago(address _targetDrago) returns (uint amount) {}
    function sellDrago(address _targetDrago, uint256 _amount) returns (uint revenue) {}
    function setDragoPrice(address _targetDrago, uint _sellPrice, uint _buyPrice) {}
    function changeRatio(address _targetDrago, uint256 _ratio) {}
    function setTransactionFee(address _targetDrago, uint _transactionFee) {}
    function changeFeeCollector(address _targetDrago, address _feeCollector) {}
    function changeDragoDAO(address _targetDrago, address _dragoDAO) {}
    function depositToExchange(address _targetDrago, address _exchange, address _token, uint256 _value) returns(bool) {}
    function withdrawFromExchange(address _targetDrago, address _exchange, address _token, uint256 _value) returns (bool) {}
    function placeOrderExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {}
    function placeTradeExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce, address _user, uint _amount) {}
    function placeOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) {}
    function cancelOrderExchange(address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {}
    function cancelOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, uint32 _id) {}
    function finalizedDealExchange(address _targetDrago, address _exchange, uint24 _id) {}
    function createDrago(address _dragoFactory, string _name, string _symbol) returns (address _drago, uint _dragoID) {}
}
