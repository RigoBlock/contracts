//! Drago Registry Interface contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract DragooRegistryFace {
    
    function register(address _drago, uint _dragoID) {}
    
    function accountOf(uint _dragoID) constant returns (address) {}   
    function dragoOf(address _drago) constant returns (uint) {}
}
