//! Upgrade contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Upgrade {

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  function setUpgraded(uint confirmed) restricted {
    lastCompletedUpgrade = confirmed;
  }

  function upgrade(address newAddress) restricted {
    Upgrade upgraded = Upgrade(newAddress);
    upgraded.setUpgraded(lasConfirmedUpgrade);
  }
  
  address public owner = msg.sender;
  uint public lastConfirmedUpgrade;
}
