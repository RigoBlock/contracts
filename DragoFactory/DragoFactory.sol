//! DragoFactory contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract DragoRegistryFace {

    function register(address _drago, uint _dragoID) {}
    
    function accountOf(uint _dragoID) constant returns (address) {}
    function dragoOf(address _drago) constant returns (uint) {}
}

contract DragoFactory is Dragowned, DragoFactoryFace {
	
    string public version = 'DF0.1'; //alt uint public version = 1
    //uint[] _dragoID; //amended below to have first fund ID = 1
    uint _dragoID = 0;
    uint public fee = 0;
    address public dragoDAO = msg.sender;
    address[] public newDragos;
    address _targetDrago;
    
    modifier when_fee_paid { if (msg.value < fee) return; _; }
	
    event DragoCreated(string _name, address _drago, address _dragowner, uint _dragoID);
    
    function DragoFactory () {}
    
    function createDrago(string _name, string _symbol, address _dragowner) when_fee_paid returns (address _drago, uint _dragoID) {
	      HumanStandardDragoo newDrago = (new HumanStandardDragoo(_name, _symbol, _dragowner));
	      newDragos.push(address(newDrago));
	      created[msg.sender].push(address(newDrago));
        newDrago.transferDragownership(msg.sender);  //library or new.tranfer(_from)
        _dragoID = nextDragoID;     //decided at last to add sequential ID numbers
        ++nextDragoID;              //decided at last to add sequential ID numbers
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        if (!registry.register(_drago, _dragoID)) throw; ; //register @ registry
        DragoCreated(_name, address(newDrago), msg.sender, uint(newDrago));
        return (address(newDrago), uint(newDrago));
    }
    
    function setFee(uint _fee) onlyDragowner {    //exmple, uint public fee = 100 finney;
        fee = _fee;
    }
    
    function setBeneficiary(address _dragoDAO) onlyDragowner {
        dragoDAO = _dragoDAO;
    }
    
    function drain() onlyDragowner {
        if (!dragoDAO.send(this.balance))
            throw;
    }
    
    function() {
        throw;
    }
        
    function buyDrago(address targetDrago) payable {
        HumanStandardDrago m = HumanStandardDragoo(targetDrago);
        if (!m.buy.value(msg.value)(); throw ;
    }
    
    function sellDrago(address targetDragoo, uint256 amount) {
        HumanStandardDrago m = HumanStandardDrago(targetDrago);
        if (!m.sell(amount); throw ;
    }
    
    function changeRatio(address targetDragoo, uint256 _ratio) {  //modifier onlyDragoDAO
        HumanStandardDragoo m = HumanStandardDragoo(targetDragoo);
        if (!m.changeRatio(_ratio); throw ;
    }
    
    function setTransactionFee(address targetDragoo, uint _transactionFee) {    //exmple, uint public fee = 100 finney;
        HumanStandardDragoo m = HumanStandardDragoo(targetDragoo);
        if (!m.setTransactionFee(_transactionFee); throw ;       //fee is in basis points (1 bps = 0.01%)
    }
    
    function changeFeeCollector(address targetDragoo, address _feeCollector) {
        HumanStandardDragoo m = HumanStandardDragoo(targetDragoo);
        if (!m.changeFeeCollector(_feeCollector); throw ;
    }
    
    function changeDragator(address targetDragoo, address _dragator) {
        HumanStandardDragoo m = HumanStandardDragoo(targetDragoo);
        if (!m.changeDragator(_dragator); throw ;
    }
    
    function depositToExchange(address targetDragoo, address exchange, address _who) /*when_approved_exchange*/ payable returns(bool success) {
    //address who used to determine from which account
        HumanStandardDragoo m = HumanStandardDragoo(targetDragoo);
        if (!m.depositToExchange(exchange, _who); throw ;
    }
    
    //remember to reinsert address _who
    function withdrawFromExchange(address targetDragoo, address exchange, uint value) returns (bool success) {
        HumanStandardDragoo m = HumanStandardDragoo(targetDragoo);
        if (!m.withdrawFromExchange(exchange, value); throw ;
        //these functions will probably require adjustment at CFD contract level
        //to set address _who
    }
    
    function placeOrderExchange(address targetDragoo, address exchange, bool is_stable, uint32 adjustment, uint128 stake) {
        HumanStandardDragoo m = HumanStandardDragoo(targetDragoo);
        if (!m.placeOrderExchange(exchange, is_stable, adjustment, stake); throw ;
    }
    
    function cancelOrderExchange(address targetDragoo, address exchange, uint32 id) {
        HumanStandardDragoo m = HumanStandardDragoo(targetDragoo);
        if (!m.cancelOrderExchange(exchange, id); throw ;
    }
    
    function finalizedDealExchange(address targetDragoo, address exchange, uint24 id) {
        HumanStandardDragoo m = HumanStandardDragoo(targetDragoo);
        if (!m.finalizeDealExchange(exchange, id); throw; ;
    }  
}
