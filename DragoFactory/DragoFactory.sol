//! DragoFactory contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract DragoRegistryFace {

	function register(address _drago, uint _dragoID) {}
    
	function accountOf(uint _dragoID) constant returns (address) {}
	function dragoOf(address _drago) constant returns (uint) {}
}

library DragoFactory is Dragowned, DragoFactoryFace {
    
	modifier when_fee_paid { if (msg.value < fee) return; _; }
	//modifier only_drago_dao
	
	event DragoCreated(string _name, address _drago, address _dragowner, uint _dragoID);
    
	function DragoFactory () {}
    
	function createDrago(string _name, string _symbol, address _dragowner) when_fee_paid returns (address _drago, uint _dragoID) {
		Drago newDrago = (new Drago(_name, _symbol, _dragowner));
		newDragos.push(address(newDrago));
		created[msg.sender].push(address(newDrago));
		newDrago.transferDragownership(msg.sender);  //library or new.tranfer(_from)
		_dragoID = nextDragoID;     //decided at last to add sequential ID numbers
		++nextDragoID;              //decided at last to add sequential ID numbers
		if (!registerDrago(_drago, _dragoID)) throw; ;
		DragoCreated(_name, address(newDrago), msg.sender, uint(newDrago));
		return (address(newDrago), uint(newDrago));
	}
	
	function registerDrago(address _drago, uint _dragoID) onlyDragowner {
		DragoRegistry registry = DragoRegistry(dragoRegistry);
		if (!registry.register(_drago, _dragoID)) throw; ; //register @ registry
		//event DragoRegistered
	}
    
	function setFee(uint _fee) onlyDragowner {    //exmple, uint public fee = 100 finney;
		fee = _fee;
	}
    
	function setBeneficiary(address _dragoDAO) onlyDragowner {
		dragoDAO = _dragoDAO;
	}
    
	function drain() onlyDragowner {
		if (!dragoDAO.send(this.balance)); throw ;
	}
    
	function() {
		throw;
	}
        
	function buyDrago(address targetDrago) payable {
		Drago m = Drago(targetDrago);
		if (!m.buy.value(msg.value)(); throw ;
	}
    
	function sellDrago(address targetDragoo, uint256 amount) {
		Drago m = Drago(targetDrago);
		if (!m.sell(amount); throw ;
	}
    
	function changeRatio(address targetDrago, uint256 _ratio) /*only_drago_dao*/ {
		Drago m = Drago(targetDrago);
		if (!m.changeRatio(_ratio); throw ;
	}
    
	function setTransactionFee(address targetDrago, uint _transactionFee) {    //exmple, uint public fee = 100 finney;
		Drago m = Drago(targetDrago);
		if (!m.setTransactionFee(_transactionFee); throw ;       //fee is in basis points (1 bps = 0.01%)
	}
    
	function changeFeeCollector(address targetDrago, address _feeCollector) {
		Drago m = Drago(targetDrago);
		if (!m.changeFeeCollector(_feeCollector); throw ;
	}
    
	function changeDragator(address targetDrago, address _dragator) {
		Dragoo m = Drago(targetDrago);
		if (!m.changeDragator(_dragator); throw ;
	}
    
	function depositToExchange(address targetDrago, address exchange, address _who) /*when_approved_exchange*/ payable returns(bool success) {
		//address who used to determine from which account
		Drago m = Drago(targetDrago);
		if (!m.depositToExchange(exchange, _who); throw ;
	}
	
	function withdrawFromExchange(address targetDrago, address exchange, uint value) returns (bool success) {
		//remember to reinsert address _who
		Drago m = Drago(targetDrago);
		if (!m.withdrawFromExchange(exchange, value); throw ;
		//apply adjustment at CFD contract level (address _who)
	}
    
	function placeOrderExchange(address targetDrago, address exchange, bool is_stable, uint32 adjustment, uint128 stake) {
		Drago m = Drago(targetDrago);
		if (!m.placeOrderExchange(exchange, is_stable, adjustment, stake); throw ;
	}
    
	function cancelOrderExchange(address targetDrago, address exchange, uint32 id) {
		Drago m = Drago(targetDrago);
		if (!m.cancelOrderExchange(exchange, id); throw ;
	}
    
	function finalizedDealExchange(address targetDrago, address exchange, uint24 id) {
		Drago m = Drago(targetDrago);
		if (!m.finalizeDealExchange(exchange, id); throw; ;
	}
	
	string public version = 'DF0.2';
	//uint[] _dragoID; //amended below to have first fund ID = 1
	uint _dragoID = 0;
	uint public fee = 0;
	address public dragoDAO = msg.sender;
	address[] public newDragos;
	address _targetDrago;
}
