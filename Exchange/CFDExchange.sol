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

contract ERC20 {

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  
	function transfer(address _to, uint256 _value) returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
	function approve(address _spender, uint256 _value) returns (bool success) {}

	function totalSupply() constant returns (uint256) {}
	function balanceOf(address _who) constant returns (uint256) {}
	function allowance(address _owner, address _spender) constant returns (uint256) {}
}

contract ExchangeFace {
    
	// EVENTS

	event Deposit(address token, address user, uint amount, uint balance);
	event Withdraw(address token, address user, uint amount, uint balance);
	event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
	event OrderPlaced(address indexed cfd, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
    event OrderMatched(address indexed cfd, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
	event OrderCancelled(address indexed cfd, uint32 indexed id, address indexed who, uint128 stake);
	event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
	event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
	event DealFinalized(address indexed cfd, address indexed stable, address indexed leveraged, uint64 price);

	// METHODS

	function deposit(address _token, uint256 _amount) payable returns (bool success) {}
	function withdraw(address _token, uint256 _amount) returns (bool success) {}
	function order(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint _nonce) {}
	function orderCFD(address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) {} //returns(bool success, uint id)
	function trade(address _tokenGet, uint _amountGet, address _tokenGive, uint amountGive, uint expires, uint nonce, address user, uint amount) {}
	function cancelOrder(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, uint nonce) {}
	function cancel(address _cfd, uint32 _id) {} // returns (bool success) {}
	function finalize(address _cfd, uint24 _id) {}
	
	function balanceOf(address token, address user) constant returns (uint256) {}
	function balanceOf(address _who) constant returns (uint256) {}
	function marginOf(address _who) constant returns (uint) {}
	function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {}
	function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {}
	function getLastOrderId() constant returns (uint) {}
	function isActive(uint id) constant returns (bool) {}
	function getOwner(uint id) constant returns (address) {}
	function getOrder(uint id) constant returns (uint, ERC20, uint, ERC20) {}
}

contract CFDExchange is ExchangeFace, SafeMath, Owned {

	struct Receipt {
		uint units;
		uint32 activation;
	}

	struct Account {
		uint256 balance;
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
	modifier ether_only(address token) { if (token != address(0)) throw; _; }
	modifier minimum_stake(uint amount) { if (amount < min_order) throw; _; }


    	// METHODS

	function deposit(address _token, uint256 _amount) payable ether_only(_token) minimum_stake(_amount) returns (bool success) {
		tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value);
		accounts[msg.sender].balance = safeAdd(accounts[msg.sender].balance, msg.value);
		Deposit(0, msg.sender, msg.value, tokens[address(0)][msg.sender]);
		return true;
	}

	function withdraw(address _token, uint256 _amount) ether_only(_token) minimum_stake(_amount) returns (bool success) {
		if (tokens[address(0)][msg.sender] < _amount) throw;
		tokens[address(0)][msg.sender] = safeSub(tokens[address(0)][msg.sender], _amount);
		accounts[msg.sender].balance = safeSub(accounts[msg.sender].balance, _amount);
		if (!msg.sender.call.value(_amount)()) throw; //if (!msg.sender.call.value(_amount)()) throw;
		Withdraw(0, msg.sender, _amount, tokens[address(0)][msg.sender]);
	}
	
	function orderCFD(address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) margin_ok(_stake) minimum_stake(_stake) {
		CFD cfd = CFD(_cfd);
		cfd.orderExchange(_is_stable, _adjustment, _stake);    //assert!
		accounts[msg.sender].balance = safeSub(accounts[msg.sender].balance, _stake);
		OrderPlaced(_cfd, msg.sender, _is_stable, _adjustment, _stake);
	}
	
	function moveOrder(address _cfd, uint24 _id, bool _is_stable, uint32 _adjustment) returns (bool) {
		CFD cfd = CFD(_cfd);
		cancel(_cfd, _id);
		var stake = cfd.orderDetails(_id);
		orderCFD(_cfd, _is_stable, _adjustment, stake);
	}
  
	function cancel(address _cfd, uint32 _id) {
		CFD cfd = CFD(_cfd);
		var stake = cfd.orderDetails(_id);
		accounts[msg.sender].balance += stake;
		cfd.cancel(_id);
		OrderCancelled(_cfd, _id, msg.sender, stake);
	}
	
	function finalize(address _cfd, uint24 _id) {
		CFD cfd = CFD(_cfd);
		cfd.finalizeExchange(_id);
		accounts[msg.sender].balance += cfd.balanceOf(msg.sender);
		tokens[address(0)][msg.sender] += cfd.balanceOf(msg.sender);
		DealFinalized(_cfd, msg.sender, msg.sender, _id);
	}
	
	function balanceOf(address _who) constant returns (uint) {
		return tokens[address(0)][_who];
	}
	
	function marginOf(address _who) constant returns (uint) {
	    return accounts[_who].balance;
	}
	
	function balanceOf(address _token, address _who) constant returns (uint) {
    		return tokens[_token][_who];
  	}
  	
  	function getBestAdjustment(address _cfd, bool _is_stable) constant returns (uint32) {
  		CFD cfd = CFD(_cfd);
		uint32 bestAdjustment = cfd.bestAdjustment(_is_stable);
		return bestAdjustment;
  	}
  	
	function getBestAdjustmentFor(address _cfd, bool _is_stable, uint128 _stake) constant returns (uint32) {
		CFD cfd = CFD(_cfd);
		uint32 bestAdjustmentFor = cfd.bestAdjustmentFor(_is_stable, _stake);
		return bestAdjustmentFor;
	}
	
	mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
  	mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
  	mapping (address => mapping (bytes32 => uint)) public orderFills; //can group in Struct
  	mapping (address => Account) accounts;
  	uint public feeMake; //percentage times (1 ether)
  	uint public feeTake; //percentage times (1 ether)
  	uint public feeRebate;
	uint min_order = 100 finney;
  	address public feeAccount; //the account that will receive fees
  	address public accountLevelsAddr;
	address public signer = msg.sender;
}
