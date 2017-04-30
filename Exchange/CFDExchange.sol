//! CFD Exchange contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Owned {
    
	modifier only_owner { if (msg.sender != owner) return; _; }

	event NewOwner(address indexed old, address indexed current);
   
	function setOwner(address _new) only_owner {
		owner = _new;
		NewOwner(owner, _new);
	}

	address public owner = msg.sender;
}

contract SafeMath {

	function safeMul(uint a, uint b) internal returns (uint) {
		uint c = a * b;
		assert(a == 0 || c / a == b);
		return c;
	}

	function safeSub(uint a, uint b) internal returns (uint) {
		assert(b <= a);
		return a - b;
	}

	function safeAdd(uint a, uint b) internal returns (uint) {
		uint c = a + b;
		assert(c>=a && c>=b);
		return c;
	}
}

contract AccountLevels {
	function accountLevel(address user) constant returns(uint) {}
}

contract CFD {
	
	event Deposit(address indexed who, uint value);
	event Withdraw(address indexed who, uint value);
	event OrderPlaced(uint32 indexed id, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	event OrderMatched(uint32 indexed id, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(uint32 indexed id, address indexed who, uint128 stake);
	event DealFinalized(uint32 indexed id, address indexed stable, address indexed leveraged, uint64 price);
	
	function deposit(address _who) payable {}
	function withdraw(uint value) returns (bool success) {}
	function orderExchange(bool is_stable, uint32 adjustment, uint128 stake) /*returns (bool success)*/ {}
	function order(bool is_stable, uint32 adjustment, uint128 stake) payable {}
	function cancelExchange(uint32 id) {}
	function cancel(uint32 id) {}
	function finalizeExchange(uint24 id) {}
	function finalize(uint24 id) {}
	
	function bestAdjustment(bool _is_stable) constant returns (uint32) {}
	function bestAdjustmentFor(bool _is_stable, uint128 _stake) constant returns (uint32) {}
	function dealDetails(uint32 _id) constant returns (address stable, address leveraged, uint64 strike, uint128 stake, uint32 end_time) {}
	function orderDetails(uint32 _id) constant returns (uint128 stake) {}
	function balanceOf(address _who) constant returns (uint) {}
}

contract CFDExchangeFace {

	// EVENTS
	
	event Deposit(address token, address user, uint amount, uint balance);
  	event Withdraw(address token, address user, uint amount, uint balance);
	event OrderPlaced(address indexed cfd, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	event OrderMatched(address indexed cfd, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(address indexed cfd, uint32 indexed id, address indexed who, uint128 stake);
	event DealFinalized(address indexed cfd, address indexed stable, address indexed leveraged, uint64 price);

	// METHODS

	function deposit(address token, uint256 amount) payable returns (bool success) {}
	function withdraw(address token, uint256 amount) returns (bool success) {}
	function orderCFD(address _cfd, bool is_stable, uint32 adjustment, uint128 stake) {}	//returns(uint id)
	function cancel(address _cfd, uint32 id) {}	//function cancel(uint id) returns (bool) {}
	function finalize(address _cfd, uint24 id) {}
	function moveOrder(address _cfd, uint24 id, bool is_stable, uint32 adjustment) returns (bool) {}

	function balanceOf(address _who) constant returns (uint) {}
	function marginOf(address _who) constant returns (uint) {}
	function balanceOf(address token, address _who) constant returns (uint) {}
	function getLastOrderId() constant returns (uint) {}
	function isActive(uint id) constant returns (bool) {}
	function getOwner(uint id) constant returns (address) {}
	function getBestAdjustment(address _cfd, bool _is_stable) constant returns (uint32) {}
	function getBestAdjustmentFor(address _cfd, bool _is_stable, uint128 _stake) constant returns (uint32) {}
}

contract CFDExchange is CFDExchangeFace, SafeMath, Owned {

	struct Receipt {
		uint units;
		uint32 activation;
	}

	struct Account {
		uint balance;
		mapping (uint => Receipt) receipt;
		mapping (address => uint) allowanceOf;
	}

	// EVENTS

	event Deposit(address token, address user, uint amount, uint balance);
  	event Withdraw(address token, address user, uint amount, uint balance);
	event OrderPlaced(address indexed cfd, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	event OrderMatched(address indexed cfd, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(address indexed cfd, uint32 indexed id, address indexed who, uint128 stake);
	event DealFinalized(address indexed cfd, address indexed stable, address indexed leveraged, uint64 price);


	// MODIFIERS

	modifier is_signer_signature(uint8 v, bytes32 r, bytes32 s) {
		bytes32 hash = sha256(msg.sender);
        	assert(ecrecover(hash, v, r, s) == signer);
        	_;
	}
 
	modifier only_owner { if (msg.sender != owner) return; _; } 
	modifier margin_ok(uint margin) { if (accounts[msg.sender].balance < margin) return; _; }
	modifier ether_only(address token) { if (token != 0) throw; _; }

    	// METHODS

	function deposit(address token, uint256 amount) payable ether_only(token) returns (bool success) {
		tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value);
		accounts[msg.sender].balance = safeAdd(accounts[msg.sender].balance, msg.value);
		Deposit(0, msg.sender, msg.value, tokens[address(0)][msg.sender]);
	}

	function withdraw(address token, uint256 amount) ether_only(token) returns (bool success) {
		if (tokens[address(0)][msg.sender] < amount) throw;
		tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
		accounts[msg.sender].balance = safeSub(accounts[msg.sender].balance, amount);
		if (!msg.sender.call.value(amount)()) throw;
		Withdraw(0, msg.sender, amount, tokens[address(0)][msg.sender]);
	}
	
	function orderCFD(address _cfd, bool is_stable, uint32 adjustment, uint128 stake) margin_ok(stake) {    //in CFD is payable
		CFD cfd = CFD(_cfd);
		cfd.orderExchange(is_stable, adjustment, stake);    //assert!
		accounts[msg.sender].balance = safeSub(accounts[msg.sender].balance, stake);
		OrderPlaced(_cfd, msg.sender, is_stable, adjustment, stake);
	}
	
	function moveOrder(address _cfd, uint24 id, bool is_stable, uint32 adjustment) returns (bool) {
		CFD cfd = CFD(_cfd);
		cancel(_cfd, id);
		var stake = cfd.orderDetails(id);
		orderCFD(_cfd, is_stable, adjustment, stake);
	}
  
	function cancel(address _cfd, uint32 id) {
		CFD cfd = CFD(_cfd);
		var stake = cfd.orderDetails(id);
		accounts[msg.sender].balance += cfd.orderDetails(id);
		cfd.cancel(id);
		OrderCancelled(_cfd, id, msg.sender, stake);
	}
	
	function finalize(address _cfd, uint24 id) {
		CFD cfd = CFD(_cfd);
		cfd.finalizeExchange(id);
		accounts[msg.sender].balance += cfd.balanceOf(msg.sender);
		tokens[address(0)][msg.sender] += cfd.balanceOf(msg.sender);
		DealFinalized(_cfd, msg.sender, msg.sender, id);
	}
	
	function balanceOf(address _who) constant returns (uint) {
		return tokens[address(0)][_who];
	}
	
	function marginOf(address _who) constant returns (uint) {
	    return accounts[_who].balance;
	}
	
	function balanceOf(address token, address _who) constant returns (uint) {
    		return tokens[token][_who];
  	}
  	
  	function getBestAdjustment(address _cfd, bool _is_stable) constant returns (uint32) {
  		CFD cfd = CFD(_cfd);
		var bestAdjustment = cfd.bestAdjustment(_is_stable);
		return bestAdjustment;
  	}
  	
	function getBestAdjustmentFor(address _cfd, bool _is_stable, uint128 _stake) constant returns (uint32) {
		CFD cfd = CFD(_cfd);
		var bestAdjustmentFor = cfd.bestAdjustmentFor(_is_stable, _stake);
		return bestAdjustmentFor;
	}
	
	mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
  	mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
  	mapping (address => mapping (bytes32 => uint)) public orderFills; //can group in Struct
  	mapping (address => Account) accounts;
  	uint public feeMake; //percentage times (1 ether)
  	uint public feeTake; //percentage times (1 ether)
  	uint public feeRebate;
  	address public feeAccount; //the account that will receive fees
  	address public accountLevelsAddr;
	address public signer = msg.sender;
}
