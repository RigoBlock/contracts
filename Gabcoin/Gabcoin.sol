//! Gabcoin contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Safely manage your multiple Ether holdings

pragma solidity ^0.4.10;

contract Owned {
	event NewOwner(address indexed old, address indexed current);
	function setOwner(address _new) {}
	function getOwner() constant returns (address owner) {}
}

contract ERC20Face {

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  
	function transfer(address _to, uint256 _value) returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
	function approve(address _spender, uint256 _value) returns (bool success) {}

	function totalSupply() constant returns (uint256 total) {}
	function balanceOf(address _who) constant returns (uint256 balance) {}
	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
}

contract GabcoinRegistry {

	event Registered(string indexed tla, uint indexed id, address addr, string name);
	event Unregistered(string indexed tla, uint indexed id);
	event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);

	function register(address _drago, uint _dragoID) {}	
	function register(address _addr, string _tla, uint _base, string _name) payable returns (bool) {}
	function unregister(uint _id) {}

	function accountOf(uint _dragoID) constant returns (address) {}   
	function dragoOf(address _drago) constant returns (uint) {}
	function tokenCount() constant returns (uint) {}
	function token(uint _id) constant returns (address addr, string tla, uint base, string name, address owner) {}
	function fromAddress(address _addr) constant returns (uint id, string tla, uint base, string name, address owner) {}
	function fromTLA(string _tla) constant returns (uint id, address addr, uint base, string name, address owner) {}
	function meta(uint _id, bytes32 _key) constant returns (bytes32) {}
	function setMeta(uint _id, bytes32 _key, bytes32 _value) {}
}

contract GabcoinFace is Owned, ERC20Face {

	event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount,uint256 _revenue);
 
 	function Gabcoin(string _dragoName,  string _dragoSymbol) {}    
	function() payable {}		
	function buyGabcoin() payable returns (uint amount) {}	
	function sellGabcoin(uint256 amount) returns (uint revenue, bool success) {}	
	function changeRatio(uint256 _ratio) {}	
	function setTransactionFee(uint _transactionFee) {}	
	function changeFeeCollector(address _feeCollector) {}	
	function changeCoinator(address _coinator) {}
	
	
	function balanceOf(address _from) constant returns (uint256 balance) {}
	function getVersion() constant returns (string version) {}
	function getName() constant returns (string name) {}
	function getSymbol() constant returns (string symbol) {}
	function getPrice() constant returns (uint256 price) {}
	function getTransactionFee() constant returns (uint256 transactionFee) {}
	function getFeeCollector() constant returns (address feeCollector) {}
}

contract Gabcoin is Owned, ERC20Face, GabcoinFace {
	
	modifier only_coinator { if (msg.sender != coinator) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }

	event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
 
	function Gabcoin(string _gabcoinName,  string _gabcoinSymbol) {
		name = _gabcoinName;    
		symbol = _gabcoinSymbol;
    	}
    
	function() payable {
		buyGabcoin();
	}
		
	function buyGabcoin() payable returns (uint amount) {
		//if (!approvedAccount[msg.sender]) throw;
		if (msg.value < min_order) throw;
		gross_amount = msg.value / price;
		fee = gross_amount * transactionFee / (1 ether);
		fee_gabcoin = fee * ratio;
		fee_coinator = fee - fee_gabcoin;
		amount = gross_amount - fee;
		balances[msg.sender] += amount;
		balances[feeCollector] += fee_gabcoin;
		balances[coinator] += fee_coinator;
		totalSupply += gross_amount;
		Buy(msg.sender, this, msg.value, amount);
		return amount;
	}
	
	function sellGabcoin(uint256 amount) returns (uint revenue, bool success) {
		//if (!approvedAccount[msg.sender]) throw;
		revenue = /*safeMul(*/amount * price/*)*/;
		if (balances[msg.sender] >= amount && balances[msg.sender] + amount > balances[msg.sender] && revenue >= min_order) {
			balances[msg.sender] -= amount;
			totalSupply -= amount;
			if (!msg.sender.send(revenue)) {
				throw;
		} else {  
			Sell(this, msg.sender, amount, revenue);
		}
		return (revenue, true);
		} else { return (revenue, false); }
	}
	
	/*
	//used to deposit for pooled Proof of Stake mining
	function depositPOS(address _validation, address _withdrawal, address _pos) only_approved_validator only_owner returns (bool success) {
		assert self.current_epoch = block.number / self.epoch_length;
		assert msg.sender = _withdrawal;
		deposit = msg.value;
		Pos pos = pos(_pos);
		pos.deposit(_validation, _withdrawal);
		return (bool success);
		DepositPOS(msg.value, msg.sender, _validation, _withdrawal, _pos);
	}
	
	function withdrawPOS(uint _validatorIndex) only_approved_validator only_owner {
		assert self.current_epoch >= self.validators[validator_index].withdrawal_epoch
		//assert(validators[_validatorIndex]._withdrawal.call.value(validators[validatorIndex].deposit));
		Pos pos = pos(_pos);
		pos.withdraw(uint _validatorIndex);
		WithdrawPOS(deposit, msg.sender);
	}	
	*/
	
	function changeRatio(uint256 _ratio) only_coinator {
		ratio = _ratio;
	}
	
	function setTransactionFee(uint _transactionFee) only_owner {	//exmple, uint public fee = 100 finney;
		transactionFee = _transactionFee  * (10 ** 18) / (10 finney);	//fee is in basis points (1 bps = 0.01%)
	}
	
	function changeFeeCollector(address _feeCollector) only_owner {	
	        feeCollector = _feeCollector; 
	}
	
	function changeCoinator(address _coinator) only_coinator {
        	coinator = _coinator;
	}
	
	function balanceOf(address _from) constant returns (uint256 balance) {
		return balances[_from];
	}
	
	string public name;
	string public symbol;
	string public version = 'GC 0.2';
	uint256 public totalSupply = 0;
	uint256 public price= 1 ether;  // prevously 1 finney
	uint256 public transactionFee = 0; //in basis points (1bps=0.01%)
	uint min_order = 100 finney; // minimum stake to avoid dust clogging things up
	address public feeCollector = msg.sender;
	address public coinator = msg.sender;
	address public owner = msg.sender;
	uint gross_amount;
	uint fee;
	uint fee_gabcoin;
	uint fee_coinator;
	uint256 public ratio = 80;
	mapping (address => uint256) public balances;
}
