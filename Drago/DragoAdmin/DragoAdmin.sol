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

	// EVENTS

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	
	// METHODS
	
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
      
contract DragoAdminFace {

	// EVENTS

	// METHODS
	
	function buyDrago(address targetDrago) payable {}
	function sellDrago(address targetDrago, uint256 amount) {}
	function changeRatio(address _targetDrago, uint256 _ratio) {}
	function setTransactionFee(address _targetDrago, uint _transactionFee) {}
	function changeFeeCollector(address _targetDrago, address _feeCollector) {}
	function changeDragator(address _targetDrago, address _dragator) {}
	function depositToExchange(address targetDrago, address exchange, address token, uint256 value) payable returns(bool) {}
	function depositToCFDExchange(address _targetDrago, address _cfdExchange) payable returns(bool) {}
	function withdrawFromExchange(address targetDrago, address exchange, address token, uint256 value) returns (bool) {}
	function withdrawFromCFDExchange(address _targetDrago, address _cfdExchange, uint amount) returns(bool) {}
	function placeOrderExchange() {}
	function placeOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, bool is_stable, uint32 adjustment, uint128 stake) {}
	function cancelOrderExchange() {}
	function cancelOrderCFDExchange(address targetDrago, address _cfdExchange, address _cfd, uint32 id) {}
	function finalizedDealExchange(address targetDrago, address exchange, uint24 id) {}
}    
      
contract DragoAdmin is Owned, DragoAdminFace {
    
	modifier only_owner { if (msg.sender != owner) return; _; }
	
	function buyDrago(address _targetDrago) payable {
		drago.buy.value(msg.value)();
	}
    
	function sellDrago(address _targetDrago, uint256 amount) {
		drago.sell(amount);
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
    
	function depositToExchange(address _targetDrago, address exchange, address token, uint256 value) /*when_approved_exchange*/ payable returns(bool) {
		//address who used to determine from which account
		assert(drago.depositToExchange.value(msg.value)(exchange, token, value));
	}
	
	function depositToCFDExchange(address _targetDrago, address _cfdExchange) /*when_approved_exchange*/ /*only_drago_owner*/ payable returns(bool) {
	    drago.depositToCFDExchange(_cfdExchange);
	}
	
	function withdrawFromExchange(address _targetDrago, address _exchange, address token, uint256 value) only_owner returns (bool) {
		//remember to reinsert address _who
		assert(drago.withdrawFromExchange(_exchange, token, value)); //for ETH token = 0
	}
	
	function withdrawFromCFDExchange(address _targetDrago, address _cfdExchange, uint amount) /*when_approved_exchange*/ /*only_drago_owner*/ returns(bool) {
	    assert(drago.withdrawFromCFDExchange(_cfdExchange, amount));
	}
	
	function placeOrderExchange(address _targetDrago, address exchange, bool is_stable, uint32 adjustment, uint128 stake) {
		drago.placeOrderExchange();
	}
	
	function placeOrderCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, bool is_stable, uint32 adjustment, uint128 stake) only_owner {
		drago.placeOrderCFDExchange(_cfdExchange, _cfd, is_stable, adjustment, stake);
	}
	
	function cancelOrderExchange(address _targetDrago, address exchange, uint32 id) {
		drago.cancelOrderExchange();
	}
	
	function cancelOrderCFDExchange(address targetDrago, address _cfdExchange, address _cfd, uint32 id) only_owner {
		drago.cancelOrderCFDExchange(_cfdExchange, _cfd, id);
	}	
	
	function finalizeDealCFDExchange(address _targetDrago, address _cfdExchange, address _cfd, uint24 id) /*only_drago_owner*/ {
		drago.finalizeDealCFDExchange(_cfdExchange, _cfd, id);
	}
	
	function() {
		throw;
	}
	
	Drago drago = Drago(_targetDrago);
	string public version = 'DF0.2';
	address _targetDrago;
	address public owner = msg.sender;
	//mapping(address => address[]) public created;
}
