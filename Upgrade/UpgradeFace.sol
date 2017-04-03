//! Upgrade Interface contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Upgrade {

  function setUpgraded(uint done) restricted {}
  function upgrade(address newAddress) restricted {}
  
  function getOwner() constant returns (address owner) {}
  function getConfirmedUpgrade() constant returns (uint lastConfirmedUpgrade) {}
}
