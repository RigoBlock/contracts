//! Exchange contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract AccountLevels {
	function accountLevel(address user) constant returns(uint) {}
}

contract Exchange is ExchangeFace {

	// EVENTS

	event Deposit(address indexed who, uint value);
	event Withdraw(address indexed who, uint value);
	event OrderPlaced(uint32 indexed id, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	event OrderMatched(uint32 indexed id, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(uint32 indexed id, address indexed who, uint128 stake);
	event DealFinalized(uint32 indexed id, address indexed stable, address indexed leveraged, uint64 price);

	event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
  	event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
  	event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
  	event Deposit(address token, address user, uint amount, uint balance);
  	event Withdraw(address token, address user, uint amount, uint balance);
	
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
	function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {
    		bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
    		orders[msg.sender][hash] = true;
    		Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
  	}
	
	function moveOrder(uint id, uint quantity) returns (bool) {
		cancel(uint32 id);
		order(bool is_stable, uint32 adjustment, uint128 stake);
	}	
	
	function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {
    		//amount is in amountGet terms
    		bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
    		if (!(
      			(orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
      			block.number <= expires &&
      			safeAdd(orderFills[user][hash], amount) <= amountGet
    		)) throw;
    		tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
    		orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
    		Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
  	}
	
	function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) internal {
    		uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
    		uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
    		uint feeRebateXfer = 0;
    		if (accountLevelsAddr != 0x0) {
      			uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
      			if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);
      			if (accountLevel==2) feeRebateXfer = feeTakeXfer;
    		}
    		tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
    		tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));
    		tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
    		tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
    		tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
  	}
  
	function cancel(uint32 id) {}
	function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
   		bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
    		if (!(orders[msg.sender][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) throw;
    		orderFills[msg.sender][hash] = amountGet;
    		Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
  	}
  	
	function finalize(uint24 id) {}
	
	function bestAdjustment(bool _is_stable) constant returns (uint32) {}
	function bestAdjustment_for(bool _is_stable, uint128 _stake) constant returns (uint32) {}
	function dealDetails(uint32 _id) constant returns (address stable, address leveraged, uint64 strike, uint128 stake, uint32 end_time) {}
	
	function balanceOf(address _who) constant returns (uint) {}	
	function balanceOf(address token, address user) constant returns (uint256) {
    		return tokens[token][user];
  	}
	
	function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
    		bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
    		if (!(
      			(orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
      			block.number <= expires
    		)) return 0;
    		uint available1 = safeSub(amountGet, orderFills[user][hash]);
    		uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
    		if (available1<available2) return available1;
    		return available2;
  	}
	
	function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
    		bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
    		return orderFills[user][hash];
  	}
	
	mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
  	mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
  	mapping (address => mapping (bytes32 => uint)) public orderFills;
  	uint public feeMake; //percentage times (1 ether)
  	uint public feeTake; //percentage times (1 ether)
  	uint public feeRebate;
  	address public feeAccount; //the account that will receive fees
  	address public accountLevelsAddr;
}
