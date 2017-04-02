//! Drago contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Dragowned {

	event NewDragowner(address indexed old, address indexed current);

	function transferDragownership(address newDragowner) onlyDragowner {}
}

contract ERC20Face is Dragowned {

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  
	function transfer(address _to, uint256 _value) returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
	function approve(address _spender, uint256 _value) returns (bool success) {}

	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
	function totalSupply() constant returns (uint256 total) {}
	function balanceOf(address _owner) constant returns (uint256 balance) {}
	//function balanceOf(address _who) constant returns (uint256 balance);
	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
}

contract DragoFace is ERC20Face {

	event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 indexed _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount, uint256 indexed _revenue);
    
	function buy() payable returns (uint amount) {
		if (!approvedAccount[msg.sender]) throw;
		if (msg.value < min_order) throw;
        	gross_amount = msg.value / buyPrice;
        	fee = gross_amount * transactionFee / (100 ether);
        	fee_dragoo = fee * 80 / 100;
        	fee_dragator = fee - fee_dragoo;
        	amount = gross_amount - fee;
        	balances[msg.sender] += amount;
        	balances[feeCollector] += fee_dragoo;
        	balances[Dragator] += fee_dragator;
        	totalSupply += gross_amount;
        	Buy(0, msg.sender, this, amount, revenue);
        	return amount;
	}
	
	function sell(uint256 amount) returns (uint revenue, bool success) {
		revenue = amount * price;
        	if (balances[msg.sender] >= amount && balances[msg.sender] + amount > balances[msg.sender] && revenue >= min_order) {
            	balances[msg.sender] -= amount;
            	totalSupply -= amount;
		if (!msg.sender.send(amount * price)) {
			throw;
		} else {  
			Transfer(this, msg.sender, 0, amount, revenue);
			}
			return (revenue, true);
		} else { return (revenue, false);
	}
	
	function changeRatio(uint256 _ratio) onlyDragator {}  
	function setTransactionFee(uint _transactionFee) onlyDragowner {}  
	function changeFeeCollector(address _feeCollector) onlyDragowner {}
	function changeDragator(address _dragator) onlyDragator {}
	
	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
        	sellPrice = newSellPrice*(10**(18 - 4));
        	buyPrice = newBuyPrice*(10**(18 - 4));
    	}
	
	function balanceOf(address _from) constant returns (uint256 balance) {}
}

contract DragoAdmin is DragoFace {
    
	string public name;
	string public symbol;
	string public version = 'H0.1';
    
	function DragoAdmin(string _dragoName,  string _dragoSymbol, address _dragowner) {
		name = _dragoName;    
		symbol = _dragoSymbol;
		dragowner = _dragowner;
	}
    
	//modifier when_approved_exchange { if (exchange != approved) return; _; }
    
	function depositToExchange(address exchange, address _who) /*when_approved_exchange*/ payable returns(bool success) {
		//address who used to determine from which account _who is the drago contract
		CFD c = CFD(exchange);
		if (!c.deposit.value(msg.value)(_who)) ;
	}
    
	function withdrawFromExchange(address exchange, uint value) returns (bool success) {
		CFD c = CFD(exchange);
		if (!c.withdraw(value)) ; throw;
	}
    
	function placeOrderExchange(address exchange, bool is_stable, uint32 adjustment, uint128 stake) {
		CFD c = CFD(exchange);
		if (!c.order(is_stable, adjustment, stake)); throw ;
	}
    
	function cancelOrderExchange(address exchange, uint32 id) {
		CFD c = CFD(exchange);
		if (!c.cancel(id)) ; throw ;
	}
    
	function finalizeDealExchange(address exchange, uint24 id) {
		CFD c = CFD(exchange);
		if (!c.finalize(id) ; throw ;
	}
    
	function() payable {
		buy();
	}
}
