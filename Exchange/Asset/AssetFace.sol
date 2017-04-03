//! Asset Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract AssetFace is ERC20Face {

  function getName() constant returns (string) {}
  function getSymbol() constant returns (string) {}
  function getDecimals() constant returns (uint) {}
}
