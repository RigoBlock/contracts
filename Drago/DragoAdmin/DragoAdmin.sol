//! Drago Admin contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Used to interact with Drago.

pragma solidity ^0.4.10;

contract Owned {
    
	modifier only_owner { if (msg.sender != owner) return; _; }

	event NewOwner(address indexed old, address indexed current);
   
	function setOwner(address _new) only_owner {
		owner = _new;
		NewOwner(owner, _new);
	}
	
	function getOwner() constant returns (address) {
	    return owner;
	}

	address public owner = msg.sender;
}

contract Drago {

 	function Drago(string _dragoName,  string _dragoSymbol) {}
	function() payable {}
	function buy() payable returns (uint amount) {}
	function sell(uint256 amount) returns (uint revenue, bool success) {}
	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) {}
	function changeRefundActivationPeriod(uint32 _refundActivationPeriod) {}
	function changeRatio(uint256 _ratio) {}
	function setTransactionFee(uint _transactionFee) {}
	function changeFeeCollector(address _feeCollector) {}
	function changeDragator(address _dragator) {}
	function depositToExchange(address exchange, address token, uint256 value) payable returns(bool success) {}
	function depositToCFDExchange(address _cfdExchange) payable returns(bool success) {}
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
      
contract DragoAdmin is Owned, DragoAdminFace {

	event Buy(address _targetDrago, address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event Sell(address _targetDrago, address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event NAV(address _targetDrago, uint sellPrice, uint buyPrice);
	event DepositExchange(address _targetDrago, uint value, uint256 indexed _amount, address indexed who, address token , address indexed _exchange);
	event DepositCFDExchange(address _targetDrago, uint , uint256 indexed _amount, address indexed who, address , address indexed _cfdExchange);
	event WithdrawExchange(address _targetDrago, uint , uint256 indexed _amount, address indexed who, address , address indexed _cfdExchange);
	event WithdrawCFDExchange(address _targetDrago, uint , uint256 indexed _amount, address indexed who, address , address indexed _cfdExchange);
	event OrderExchange(address _targetDrago, address indexed _exchange, address indexed _token);
	event OrderCFD(address _targetDrago, address indexed _cfdExchange, address indexed _cfd);
	event CancelExchange(address indexed _targetDrago, address indexed _exchange, address indexed token, uint id);
	event CancelCFD(address indexed _targetDrago, address indexed _cfdExchange, address indexed _cfd, uint32 id);
	event FinalizeCFD(address indexed _targetDrago, address indexed _cfdExchange, address indexed _cfd, uint32 id);
	
	modifier only_owner { if (msg.sender != owner) return; _; }
	
	function buyDrago(address _targetDrago) payable returns (uint amount) {
		drago.buy.value(msg.value)(); //assert
		//return amount;  //double check it's the right way to call it
		Buy(_targetDrago, msg.sender, this, msg.value, amount);
		//return true;
	}
    
	function sellDrago(address _targetDrago, uint256 amount) returns (uint revenue) {
		drago.sell(amount);
		Sell(_targetDrago, this, msg.sender, amount, revenue);
	}
	
	function setDragoPrice(address _targetDrago, uint _sellPrice, uint _buyPrice) {
	    drago.setPrices(_sellPrice, _buyPrice);
	    NAV(_targetDrago, _sellPrice, _buyPrice);
	}
    
	function depositToExchange(address _targetDrago, address _exchange, address _token, uint256 _value) /*when_approved_exchange*/ payable returns(bool) {
		//address who used to determine from which account
		assert(drago.depositToExchange.value(msg.value)(_exchange, _token, _value));
		DepositExchange(_targetDrago, _value, msg.value, msg.sender, _token, _exchange);
	}
	
	function depositToCFDExchange(address _targetDrago, address _cfdExchange) /*when_approved_exchange*/ /*only_drago_owner*/ payable returns(bool) {
	    drago.depositToCFDExchange(_cfdExchange);
	    DepositCFDExchange(_targetDrago, 0, msg.value, msg.sender, 0, _cfdExchange);
	}
	
	function withdrawFromExchange(address _targetDrago, address _exchange, address token, uint256 value) only_owner returns (bool) {
		//remember to reinsert address _who
		assert(drago.withdrawFromExchange(_exchange, token, value)); //for ETH token = 0
		WithdrawExchange(_targetDrago, value, value, msg.sender, token, _exchange);
	}
	
	function withdrawFromCFDExchange(address _targetDrago, address _cfdExchange, uint amount) /*when_approved_exchange*/ /*only_drago_owner*/ returns(bool) {
	    assert(drago.withdrawFromCFDExchange(_cfdExchange, amount));
	    WithdrawCFDExchange(_targetDrago, amount, amount, msg.sender, 0, _cfdExchange);
	}
	
	function placeOrderExchange(address _targetDrago, address _exchange, address _token) {
		drago.placeOrderExchange();
		OrderExchange(_targetDrago, _exchange, _token);
	}
	
	function placeOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, bool is_stable, uint32 adjustment, uint128 stake) only_owner {
		drago.placeOrderCFDExchange(_cfdExchange, _cfd, is_stable, adjustment, stake);
		OrderCFD(_targetDrago, _cfdExchange, _cfd);
	}
	
	function placeTradeExchange() {}
	
	function cancelOrderExchange(address _targetDrago, address exchange, address token, uint32 id) {
		drago.cancelOrderExchange();
		CancelExchange(_targetDrago, exchange, token, id);
	}
	
	function cancelOrderCFDExchange(address targetDrago, address _cfdExchange, address _cfd, uint32 id) only_owner {
		drago.cancelOrderCFDExchange(_cfdExchange, _cfd, id);
		CancelCFD(_targetDrago, _cfdExchange, _cfd, id);
	}	
	
	function finalizeDealCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, uint24 id) /*only_drago_owner*/ {
		drago.finalizeDealCFDExchange(_cfdExchange, _cfd, id);
		FinalizeCFD(_targetDrago, _cfdExchange, _cfd, id);
	}
	
	function changeRatio(address _targetDrago, uint256 _ratio) /*only_drago_dao*/ {
		drago.changeRatio(_ratio);
	}
    
	function setTransactionFee(address _targetDrago, uint _transactionFee) {    //exmple, uint public fee = 100 finney;
		drago.setTransactionFee(_transactionFee);       //fee is in basis points (1 bps = 0.01%)
	}
    
	function changeFeeCollector(address _targetDrago, address _feeCollector) {
		drago.changeFeeCollector(_feeCollector);
	}
    
	function changeDragator(address _targetDrago, address _dragator) {
		drago.changeDragator(_dragator);
	}
	
	// CONSTANT METHODS
	
	function() {
		throw;
	}
	
	Drago drago = Drago(_targetDrago);
	string public version = 'DF0.2';
	address _targetDrago;
	address public owner = msg.sender;
}
