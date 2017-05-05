//! Eventful Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Eventful pools together drago events.

pragma solidity ^0.4.10;

contract EventfulFace {

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

    function buyDrago(address _who, address _targetDrago, uint _value, uint _amount) returns (bool success) {}
    function sellDrago(address _who, address _targetDrago, uint _amount, uint _revenue) returns(bool success) {}
    function setDragoPrice(address _who, address _targetDrago, uint _sellPrice, uint _buyPrice) returns(bool success) {}
    function changeRatio(address _who, address _targetDrago, uint256 _ratio) returns(bool success) {}
    function setTransactionFee(address _who, address _targetDrago, uint _transactionFee) returns(bool success) {}
    function changeFeeCollector(address _who, address _targetDrago, address _feeCollector) returns(bool success) {}
    function changeDragoDAO(address _who, address _targetDrago, address _dragoDAO) returns(bool success) {}
    function depositToExchange(address _who, address _targetDrago, address _exchange, address _token, uint256 _value) returns(bool success) {}
    function withdrawFromExchange(address _who, address _targetDrago, address _exchange, address _token, uint256 _value) returns(bool success) {}
    function placeOrderExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) returns(bool success) {}
    function placeTradeExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce, address _user, uint _amount) returns(bool success) {}
    function placeOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) returns(bool success) {}
    function cancelOrderExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) returns(bool success) {}
    function cancelOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, uint32 _id) returns(bool success) {}
    function finalizedDealExchange(address _who, address _targetDrago, address _exchange, address _cfd, uint24 _id) returns(bool success) {}
    function createDrago(address _who, address _dragoFactory, address _newDrago, string _name, string _symbol, uint _dragoId, address _owner) returns(bool success) {}
}  
