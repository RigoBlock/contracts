//! Exchange Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract ExchangeFace {

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
	function deposit(address token, uint256 amount) payable {}
	//function withdraw(uint value) returns (bool success) {}
	function withdraw(address token, uint256 amount) {}
	function order(bool is_stable, uint32 adjustment, uint128 stake) payable {}
	function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {}
	function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {}
    	function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {}
	function cancel(uint32 id) {}
	function finalize(uint24 id) {}
	
	function bestAdjustment(bool _is_stable) constant returns (uint32) {}
	function bestAdjustmentFor(bool _is_stable, uint128 _stake) constant returns (uint32) {}
	function dealDetails(uint32 _id) constant returns (address stable, address leveraged, uint64 strike, uint128 stake, uint32 end_time) {}
	//function balanceOf(address _who) constant returns (uint) {}
	function balanceOf(address token, address user) constant returns (uint) {}
	function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {}
    	function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {}
    
    	//mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
    	//mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
    	//mapping (address => mapping (bytes32 => uint)) public orderFills;
}
