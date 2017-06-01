pragma solidity ^0.4.11;

contract Owned {
    
	modifier only_owner { if (msg.sender != owner) return; _; }

	event NewOwner(address indexed old, address indexed current);
   
	function setOwner(address _new) only_owner {
		owner = _new;
		NewOwner(owner, _new);
	}
	
	function getOwner() constant returns (address) {
	    return owner;
	}

	address public owner = msg.sender;
}

contract SafeMath {

    function safeMul(uint a, uint b) internal returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }
    
    function safeDiv(uint a, uint b) internal returns (uint) {
        assert(b > 0);
        uint c = a / b;
        assert(a == b * c + a % b);
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

contract ERC20 {

	//EVENTS
	
	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  
  	//METHODS
	
  	function transfer(address _to, uint256 _value) returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
	function approve(address _spender, uint256 _value) returns (bool success) {}

	function totalSupply() constant returns (uint256 total) {}
	function balanceOf(address _who) constant returns (uint256 balance) {}
	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
}

contract ExampleCrowdsale is ERC20, SafeMath, Owned {
 //
 // Total collected field is PUBLIC uint that contains amount of ETH in smart contract (included amount of ERC20 tokens).
 // Could be only increased, means if you withdraw ETH, should be not modificated (you can use two fields to keep real available)
 // amount of ETH in contract and totalCollected for total amount of ETH collected
 //
 uint public totalCollected;
 
 // Total contains field to be sure we know how we contains ETH now
 mapping(address => uint) totalContains;
 
 
 // Keep ERC20 token prices
 mapping(uint => address) prices;
 
 function() {
   // just as example detecting ETH as some specific reserved address as 0
   invest(msg.value, address(0));
 }
 
 /*
    To invest token.
    Pseudocode. DON'T USE IT IT'S UNSAFE
 */
 function invest(uint _amount, address _erc20OrEth) payable {
   if (_erc20OrEth == address(0)) {
     if (_amount == 0) {
       throw;
     }
 
     // accept ETH
     // some code for allocate amount of tokens based on price of ETH, etc
     // blah-blah....
 
     // And now we can update total collected (increase it by _amount of ETH)
     totalCollected = safeAdd(totalCollected, _amount);
    } else {
     uint price = 1 ether; //prices[_erc20OrEth];
 
     if (price > 0 && _amount > 0) {
       // accept ERC20
       // some code for allocate amount of tokens based on price of ERC20 tokens, etc
       // blah-blah....
 
       // And now we can update total collected (increase it by _amount of ERC20 tokens in price of ETH)
       totalCollected = safeAdd(totalCollected, safeMul(price, _amount));
     } else {
       throw;
     }
   }
 }
 
  function (uint _amount, address _erc20OrEth, address _toWithdraw) payable /*onlyOwner*/  {
   uint contains = totalContains[_erc20OrEth];
 
   if (contains > 0) {
     if (_erc20OrEth == address(0)) {
       // withdraw ETH, .....
     } else {
       // withdraw token, .....
     }
 
     totalContains[_erc20OrEth] = 0;
   } else {
     throw;
   }
 }
}
