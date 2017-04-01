//! Oracle Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract OracleFace is Owned {
  
  event Changed(uint224 current);
  
  function note(uint224 _value) only_owner {}
    
  function get() constant returns (uint224) {}
  function get_timestamp() constant returns (uint32) {}
}
