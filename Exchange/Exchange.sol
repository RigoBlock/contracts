//! Exchange contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Exchange is ExchangeFace {

	// EVENTS

	event Deposit(address indexed who, uint value);
	event Withdraw(address indexed who, uint value);
	event OrderPlaced(uint32 indexed id, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	event OrderMatched(uint32 indexed id, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(uint32 indexed id, address indexed who, uint128 stake);
	event DealFinalized(uint32 indexed id, address indexed stable, address indexed leveraged, uint64 price);

	// METHODS

	//function deposit(address _who) payable {}	
	function deposit(address token, uint256 amount) payable {
        //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
        	if (token == address(0)) {
            		tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value);
        	} else {
            		if (msg.value != 0) throw;
            		tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
            		if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
        	}
       		Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
	}
	
	//function withdraw(uint value) returns (bool success) {}	
	function withdraw(address token, uint256 amount) {
        	if (tokens[token][msg.sender] < amount) throw;
        	tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
        	if (token == address(0)) {
            		if (!msg.sender.call.value(amount)()) throw; //amended from msg.sender.send(amount)
        	} else {
            		if (!Token(token).transfer(msg.sender, amount)) throw;
        	}
        	Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
    	}
  
	function order(bool is_stable, uint32 adjustment, uint128 stake) payable {}
	function cancel(uint32 id) {}
	function finalize(uint24 id) {}
	
	function bestAdjustment(bool _is_stable) constant returns (uint32) {}
	function bestAdjustment_for(bool _is_stable, uint128 _stake) constant returns (uint32) {}
	function dealDetails(uint32 _id) constant returns (address stable, address leveraged, uint64 strike, uint128 stake, uint32 end_time) {}
	
	function balanceOf(address _who) constant returns (uint) {}	
	function balanceOf(address token, address user) constant returns (uint256) {
    		return tokens[token][user];
  	}
}
