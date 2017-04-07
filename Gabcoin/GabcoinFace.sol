//! Gabcoin Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Owned {
	event NewOwner(address indexed old, address indexed current);
	function setOwner(address _new) {}
	function getOwner() constant returns (address owner) {}
}

contract ERC20Face is Owned {

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);

	function transfer(address _to, uint256 _value) returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
	function approve(address _spender, uint256 _value) returns (bool success) {}

	function totalSupply() constant returns (uint256 total) {}
	function balanceOf(address _who) constant returns (uint256 balance) {}
	function allowance(address _owner, address _spender) constant returns (uint256 remaining)
}

contract GabcoinFace is ERC20Face {

	event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount,uint256 _revenue);
	//event DepositCasper(uint msg.value, address indexed msg.sender, address indexed _validation, address indexed _withdrawal, address _casper);
 	//event WithdrawCasper(uint deposit, address indexed msg.sender, address _casper);

 	function Gabcoin(string _dragoName,  string _dragoSymbol) {}    
	function() payable {}		
	function buyGabcoin() payable returns (uint amount) {}	
	function sellGabcoin(uint256 amount) returns (uint revenue, bool success) {}
	//function depositCasper(address _validation, address _withdrawal, address _casper) returns (bool success) {}
	//function withdrawCasper(uint _validatorIndex, address _casper) {}
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
	function getCasper() constant returns (address _casper) {}
}
