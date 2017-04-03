//! Gabcoin contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Safely manage your multiple Ether holdings

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
	
	modifier onlyCoinator { if (msg.sender != Coinator) return; _; }

	event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 indexed _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount, uint256 indexed _revenue);
 
	function Gabcoin(string _dragoName,  string _dragoSymbol) {
		name = _gabcoinName;    
		symbol = _gabcoinSymbol;
    	}
    
	function() payable {
		buyDrago();
	}
		
	function buyGabcoin() payable returns (uint amount) {
		if (!approvedAccount[msg.sender]) throw;
		if (msg.value < min_order) throw;
		gross_amount = msg.value / price;
		fee = gross_amount * transactionFee / (100 ether);
		fee_gabcoin = fee * ratio;
		fee_coinator = fee - fee_gabcoin;
		amount = gross_amount - fee;
		balances[msg.sender] += amount;
		balances[feeCollector] += fee_gabcoin;
		balances[Coinator] += fee_coinator;
		totalSupply += gross_amount;
		Buy(0, msg.sender, this, amount, revenue);
		return amount;
	}
	
	function sellGabcoin(uint256 amount) returns (uint revenue, bool success) {
		if (!approvedAccount[msg.sender]) throw;
		revenue = safeMul(amount * price);
		if (balances[msg.sender] >= amount && balances[msg.sender] + amount > balances[msg.sender] && revenue >= min_order) {
			balances[msg.sender] -= amount;
			totalSupply -= amount;
			if (!msg.sender.send(revenue)) {
				throw;
		} else {  
			Sell(this, msg.sender, 0, amount, revenue);
		}
		return (revenue, true);
		} else { return (revenue, false); }
	}
	
	function changeRatio(uint256 _ratio) onlyCoinator {
		ratio = _ratio;
	}
	
	function setTransactionFee(uint _transactionFee) onlyOwner {	//exmple, uint public fee = 100 finney;
		transactionFee = _transactionFee * msg.value / (100 ether);	//fee is in basis points (1 bps = 0.01%)
	}
	
	function changeFeeCollector(address _feeCollector) onlyOwner {	
	        feeCollector = _feeCollector; 
	}
	
	function changeCoinator(address _coinator) onlyCoinator {
        	coinator = _coinator;
	}
	
	function balanceOf(address _from) constant returns (uint256 balance) {
		return balances[_from];
	}
	
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
