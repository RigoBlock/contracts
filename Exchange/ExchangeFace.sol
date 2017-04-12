//! Exchange Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract ExchangeFace {

	// EVENTS

    	event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
    	event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
    	event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
    	event Deposit(address token, address user, uint amount, uint balance);
    	event Withdraw(address token, address user, uint amount, uint balance);

	// METHODS

	function deposit(address token, uint256 amount) payable {}
	function withdraw(address token, uint256 amount) {}
	function orderCFD(bool is_stable, uint32 adjustment, uint128 stake) payable {}	//returns(uint id)
	function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {}
	function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {}
	function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {}
	function cancel(uint32 id) {}	//function cancel(uint id) returns (bool) {}
	function finalize(uint24 id) {}
	function moveOrder(uint id, uint quantity) returns (bool) {}
	
	function balanceOf(address _who) constant returns (uint256) {}
	function balanceOf(address token, address user) constant returns (uint256) {}
	function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {}
    	function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {}
    	
	function getLastOrderId() constant returns (uint) {}
	function isActive(uint id) constant returns (bool active) {}
	function getOwner(uint id) constant returns (address owner) {}
	//function getOrder(uint id) constant returns (uint, ERC20, uint, ERC20) {}
    	//mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
    	//mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
    	//mapping (address => mapping (bytes32 => uint)) public orderFills;
}
