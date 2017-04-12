//! Oracle Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract OracleFace {
  
    event Changed(uint224 current);
  
    function updatePrice() {}
    function note(uint224 _value) {}
    
    function get() constant returns (uint224) {}
    function getTimestamp() constant returns (uint32) {}
}
