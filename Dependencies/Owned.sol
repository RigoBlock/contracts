//! Owned contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.18;

contract Owned {

	modifier only_owner { require(msg.sender == owner); _; }

	event NewOwner(address indexed old, address indexed current);
   
	function setOwner(address _new) public only_owner {
		owner = _new;
		NewOwner(owner, _new);
	}

	function getOwner() public constant returns (address) {
	    return owner;
	}

	address public owner = msg.sender;
}
