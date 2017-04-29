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
    
	// METHODS

 	function Drago(string _dragoName,  string _dragoSymbol, uint _dragoID) {}
	function buyDrago() payable returns (bool success) {}
	function sellDrago(uint256 _amount) returns (uint revenue, bool success) {}
	function setPrices(uint256 _newSellPrice, uint256 _newBuyPrice) {}
	function changeMinPeriod(uint32 _minPeriod) {}
	function changeRatio(uint256 _ratio) {}
	function setTransactionFee(uint _transactionFee) {}
	function changeFeeCollector(address _feeCollector) {}
	function changeDragator(address _dragoDAO) {}
	function depositToExchange(address _exchange, address _token, uint256 _value) payable returns(bool success) {}
	function depositToCFDExchange(address _cfdExchange, uint256 _value) payable returns(bool success) {}
	function withdrawFromExchange(address _exchange, address _token, uint256 _value) returns (bool success) {}
	function withdrawFromCFDExchange(address _cfdExchange, uint _amount) returns(bool success) {}
	function placeOrderExchange() {}
	function placeTradeExchange() {}
	function placeOrderCFDExchange(address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) {}
	function cancelOrderExchange() {}
	function cancelOrderCFDExchange(address _cfdExchange, address _cfd, uint32 _id) {}	
	function finalizeDealCFDExchange(address _cfdExchange, address _cfd, uint24 _id) {}
	function setOwner(address _new) {}

	function balanceOf(address _who) constant returns (uint256) {}
	function getData() constant returns (string name, string symbol, uint sellPrice, uint buyPrice, uint totalSupply) {}
	function getAdminData() constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {}
	function getOwner() constant returns (address) {}
}

contract DragoFactory {
    
	// EVENTS

	event DragoCreated(string _name, address _drago, address _owner, uint _dragoID);

	// METHODS
    
	function createDrago(string _name, string _symbol) returns (address _drago, uint _dragoID) {}
	function setRegistry(address _newRegistry) {}
	function setBeneficiary(address _dragoDAO) {}
	function setFee(uint _fee) {}
	function drain() {}
	function setOwner(address _new) {}
    
	function getRegistry() constant returns (address) {}
	function getStorage() constant returns (address dragoDAO, string version, uint nextDragoID) {}
    function getOwner() constant returns (address) {}
}
      
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
	function changeDragator(address _targetDrago, address _dragator) {}
	function depositToExchange(address targetDrago, address exchange, address token, uint256 value) returns(bool) {}
	function depositToCFDExchange(address _targetDrago, address _cfdExchange) returns(bool) {}
	function withdrawFromExchange(address targetDrago, address exchange, address token, uint256 value) returns (bool) {}
	function withdrawFromCFDExchange(address _targetDrago, address _cfdExchange, uint amount) returns(bool) {}
	function placeOrderExchange() {}
	function placeTradeExchange() {}
	function placeOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, bool is_stable, uint32 adjustment, uint128 stake) {}
	function cancelOrderExchange() {}
	function cancelOrderCFDExchange(address targetDrago, address _cfdExchange, address _cfd, uint32 id) {}
	function finalizedDealExchange(address targetDrago, address exchange, uint24 id) {}
	function createDrago(address _dragoFactory, string _name, string _symbol) returns (address _drago, uint _dragoID) {}
} 
      
library DragoAdmin {

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
	event DragoCreated(string _name, string _symbol, address _drago, address _dragowner, uint _dragoID);

	
	//modifier only_owner { if (msg.sender != owner) return; _; }
	
	function buyDrago(address _targetDrago) returns (uint amount) {
		Drago drago = Drago(_targetDrago);
		drago.buyDrago.value(msg.value)(); //assert
		return amount;
		Buy(_targetDrago, msg.sender, this, msg.value, amount);
		//return true;
	}
    
	function sellDrago(address _targetDrago, uint256 amount) returns (uint revenue) {
		Drago drago = Drago(_targetDrago);
		drago.sellDrago(amount);    //assert()
		Sell(_targetDrago, this, msg.sender, amount, revenue);
	}
	
	function setDragoPrice(address _targetDrago, uint _sellPrice, uint _buyPrice) {
	    Drago drago = Drago(_targetDrago);
	    drago.setPrices(_sellPrice, _buyPrice);
	    NAV(_targetDrago, _sellPrice, _buyPrice);
	}
    
	function depositToExchange(address _targetDrago, address _exchange, address _token, uint256 _value) /*when_approved_exchange*/ returns(bool) {
		//address who used to determine from which account
		Drago drago = Drago(_targetDrago);
		assert(drago.depositToExchange(_exchange, _token, _value));
		DepositExchange(_targetDrago, _value, msg.value, msg.sender, _token, _exchange);
	}
	
	function depositToCFDExchange(address _targetDrago, address _cfdExchange, uint _value) /*when_approved_exchange*/ /*only_drago_owner*/ returns(bool) {
	    Drago drago = Drago(_targetDrago);
	    drago.depositToCFDExchange(_cfdExchange, _value);
	    DepositCFDExchange(_targetDrago, 0, msg.value, msg.sender, 0, _cfdExchange);
	}
	
	function withdrawFromExchange(address _targetDrago, address _exchange, address token, uint256 value) /*only_owner*/ returns (bool) {
		//remember to reinsert address _who
		Drago drago = Drago(_targetDrago);
		assert(drago.withdrawFromExchange(_exchange, token, value)); //for ETH token = 0
		WithdrawExchange(_targetDrago, value, value, msg.sender, token, _exchange);
	}
	
	function withdrawFromCFDExchange(address _targetDrago, address _cfdExchange, uint amount) /*when_approved_exchange*/ /*only_drago_owner*/ returns(bool) {
	    Drago drago = Drago(_targetDrago);
	    assert(drago.withdrawFromCFDExchange(_cfdExchange, amount));
	    WithdrawCFDExchange(_targetDrago, amount, amount, msg.sender, 0, _cfdExchange);
	}
	
	function placeOrderExchange(address _targetDrago, address _exchange, address _token) {
		Drago drago = Drago(_targetDrago);
		drago.placeOrderExchange();
		OrderExchange(_targetDrago, _exchange, _token);
	}
	
	function placeOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, bool is_stable, uint32 adjustment, uint128 stake) /*only_owner*/ {
		Drago drago = Drago(_targetDrago);
		drago.placeOrderCFDExchange(_cfdExchange, _cfd, is_stable, adjustment, stake);
		OrderCFD(_targetDrago, _cfdExchange, _cfd);
	}
	
	function placeTradeExchange() {}
	
	function cancelOrderExchange(address _targetDrago, address exchange, address token, uint32 id) {
		Drago drago = Drago(_targetDrago);
		drago.cancelOrderExchange();
		CancelExchange(_targetDrago, exchange, token, id);
	}
	
	function cancelOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, uint32 id) {
		Drago drago = Drago(_targetDrago);
		drago.cancelOrderCFDExchange(_cfdExchange, _cfd, id);
		CancelCFD(_targetDrago, _cfdExchange, _cfd, id);
	}	
	
	function finalizeDealCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, uint24 id) {
		Drago drago = Drago(_targetDrago);
		drago.finalizeDealCFDExchange(_cfdExchange, _cfd, id);
		FinalizeCFD(_targetDrago, _cfdExchange, _cfd, id);
	}
	
	function changeRatio(address _targetDrago, uint256 _ratio) /*only_drago_dao*/ {
		Drago drago = Drago(_targetDrago);
		drago.changeRatio(_ratio);
	}
    
	function setTransactionFee(address _targetDrago, uint _transactionFee) {    //exmple, uint public fee = 100 finney;
		Drago drago = Drago(_targetDrago);
		drago.setTransactionFee(_transactionFee); //fee is in basis points (1 bps = 0.01%)
	}
    
	function changeFeeCollector(address _targetDrago, address _feeCollector) {
		Drago drago = Drago(_targetDrago);
		drago.changeFeeCollector(_feeCollector);
	}
    
	function changeDragator(address _targetDrago, address _dragator) {
		Drago drago = Drago(_targetDrago);
		drago.changeDragator(_dragator);
	}
	
	function createDrago(address _dragoFactory, string _name, string _symbol) returns (address _drago, uint _dragoID) {
	    DragoFactory factory = DragoFactory(_dragoFactory);
	    factory.createDrago(_name, _symbol);
	    DragoCreated(_name, _symbol, _drago, msg.sender, _dragoID);
	}
	
	// CONSTANT METHODS
	
	string constant public version = 'DA0.2';
	//address constant public owner = msg.sender;
	// add all assertive to prevent event if non executed;
}
