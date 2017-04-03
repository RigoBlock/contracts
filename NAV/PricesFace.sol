//! Prices Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Prices for NAV Estimate

pragma solidity ^0.4.10;

contract PricesFace {
  
  event PricesUpdated(address indexed _asset, uint224 _timestamp, uint _price);
  
  function updatePrice(address[] _assets, uint224[] newPrices) /*only_owner*/ {}

  function getPrice(address _asset) constant returns (uint224) {}
  function getTimestamp(address _asset) constant returns (uint32) {}
  function getData(address _asset) constant returns (uint, uint224) {}
}
