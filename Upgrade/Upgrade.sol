//! Upgrade contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Upgrade {

  modifier only_owner() { if (msg.sender != owner) return; _; }

  function setUpgraded(uint confirmed) only_owner {
    lastCompletedUpgrade = confirmed;
  }

  function upgrade(address newAddress) only_owner {
    Upgrade upgraded = Upgrade(newAddress);
    upgraded.setUpgraded(lasConfirmedUpgrade);
  }
  
  address public owner = msg.sender;
  uint public lastConfirmedUpgrade;
}
