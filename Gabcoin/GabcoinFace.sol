//! Gabcoin Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Owned {

	event NewOwner(address indexed old, address indexed current);

	function transferOwnership(address newOwner) onlyOwner {}
}

contract ERC20Face is Owned {

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

contract Gabcoin is ERC20Face {

	event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 indexed _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount, uint256 indexed _revenue);
 
 	function Gabcoin(string _dragoName,  string _dragoSymbol) {}    
  function() payable {}		
	function buyGabcoin() payable returns (uint amount) {}	
	function sellGabcoin(uint256 amount) returns (uint revenue, bool success) {}	
	function changeRatio(uint256 _ratio) onlyCoinator {}	
	function setTransactionFee(uint _transactionFee) onlyOwner {}	
	function changeFeeCollector(address _feeCollector) onlyOwner {}	
	function changeCoinator(address _coinator) onlyCoinator {}
	
	function balanceOf(address _from) constant returns (uint256 balance) {}
	
	string public name;
  string public symbol;
  string public version = 'GC 0.2';
	uint256 public price= 1 ether;  // prevously 1 finney
	uint256 public transactionFee = 0; //in basis points (1bps=0.01%)
	uint min_order = 100 finney; // minimum stake to avoid dust clogging things up
	address public feeCollector = msg.sender;
	address public coinator = msg.sender;
	uint gross_amount;
	uint fee;
	uint fee_gabcoin;
	uint fee_coinator;
	uint256 public ratio = 80;
	
	mapping (address => uint256) public balances;
}
