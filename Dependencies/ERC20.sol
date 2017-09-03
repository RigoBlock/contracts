//! ERC20 Token contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.16;

contract ERC20Face {
	
	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	
  	function transfer(address _to, uint256 _value) returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
	function approve(address _spender, uint256 _value) returns (bool success) {}

	function totalSupply() constant returns (uint256 totalSupply) {}
	function balanceOf(address _owner) constant returns (uint256 balance) {}
	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
}

contract ERC20 is ERC20Face {

	function transfer(address _to, uint256 _value) returns (bool success) {
		if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
			balances[msg.sender] -= _value;
			balances[_to] += _value;
			Transfer(msg.sender, _to, _value);
			return true;
		} else { return false; }
	}

	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
		if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
			balances[_to] += _value;
			balances[_from] -= _value;
			allowed[_from][msg.sender] -= _value;
			Transfer(_from, _to, _value);
			return true;
		} else { return false; }
	}

	function balanceOf(address _owner) constant returns (uint256 balance) {
		return balances[_owner];
	}

	function approve(address _spender, uint256 _value) returns (bool success) {
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);
		return true;
	}

	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
		return allowed[_owner][_spender];
	}

	uint256 public totalSupply;
	mapping (address => uint256) balances;
	mapping (address => mapping (address => uint256)) allowed;
}
