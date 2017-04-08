//! Authority Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract AuthFace {
  
  event SetAuthority (address indexed authority);
  event SetWhitelister (address indexed whitelister);
  event WhitelistedUser(address indexed target, bool approved);
  
  function setAuthority(address _authority) {}
  function setWhitelister(address _whitelister) {}
  function whitelistUser(address _target, bool _isWhitelisted) {}
  
  function isWhitelistedUser(address _target) constant returns (bool) {}
  function getOwner() constant returns (address owner) {}
  function getAuth() contant returns (address auth) {}
  function getWhitelisters() constant returns (address[] whitelister) {}
}
