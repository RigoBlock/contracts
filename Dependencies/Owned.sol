//! Hedge Fund contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Owned {
    
    modifier only_owner { if (msg.sender != owner) return; _; }
    
    event NewOwner(address indexed old, address indexed current);
    
    function set_owner(address _new) only_owner {
        owner = _new;
        NewOwner(owner, _new);
    }

    address public owner = msg.sender;
}
