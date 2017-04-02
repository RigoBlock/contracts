//! Exchange approved contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract ExchangeCheckFace {
      function exchangeCheck(address _exchange) public constant returns (bool _approved) {}
      function setApproval(address _asset, bool _status) onlyowner {}
      function transferOwnership(address _owner) onlyowner {}
      function ownedVerifier(address _owner) {}
}
