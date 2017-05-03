//! Eventful contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Eventful is used to collect all events from all dragos automatically.

contract Eventful {

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
    function buyDrago(address _who, address _targetDrago, uint value, uint amount) returns (bool success) {}
    function sellDrago(address who, address _targetDrago, uint _amount, uint _revenue) returns (bool success) {}
    function setDragoPrice(address _who, address _targetDrago, uint _sellPrice, uint _buyPrice) returns (bool success) {}
    function changeRatio(address _who, address _targetDrago, uint256 _ratio) {}
    function setTransactionFee(address _who, address _targetDrago, uint _transactionFee) {}
    function changeFeeCollector(address _who, address _targetDrago, address _feeCollector) {}
    function changeDragoDAO(address _who, address _targetDrago, address _dragoDAO) {}
    function depositToExchange(address _who, address _targetDrago, address _exchange, address _token, uint256 _value) returns(bool) {}
    function withdrawFromExchange(address _who, address _targetDrago, address _exchange, address _token, uint256 _value) returns (bool) {}
    function placeOrderExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {}
    function placeTradeExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce, address _user, uint _amount) {}
    function placeOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) {}
    function cancelOrderExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {}
    function cancelOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, uint32 _id) {}
    function finalizedDealExchange(address _who, address _targetDrago, address _exchange, address _cfd, uint24 _id) {}
    function createDrago(address _who, address _dragoFactory, string _name, string _symbol, uint _dragoId, address _owner) returns (address _drago, uint _dragoID) {}
}
