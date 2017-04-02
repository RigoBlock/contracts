//! Authority Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract AuthFace {
  
  event approvedAccount(address target, bool approved);
  
  function approveAccount(address target, bool approve) onlyOwner {}
}
