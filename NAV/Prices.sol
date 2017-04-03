//! Prices contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Prices for NAV Estimate

pragma solidity ^0.4.10;

contract Prices is PricesFace {

  struct Values {
        uint32 timestamp;
        uint224 values;
  }
  
  event PricesUpdated(address indexed _asset, uint32 _timestamp, uint224 _price);
  
  function updatePrice(address[] _assets, uint224[] newPrices) /*only_owner*/ {}
  
  function getStatus(address _asset) constant data_initialised(_asset) returns (bool updated) {
    return now - values[_asset].timestamp <= validity;
  }
    
  function updatePrice(address[] _assets, uint224[] newPrices) /*only_owner*/ returns (uint224, uint32) {
    for (uint i = 0; i < _assets.length; ++i) {
      assert(data[_assets[i]].values != _values);
      assert(data[_assets[i]].timestamp != now);
      data[_assets[i]].values = newPrices[i];
      data[_assets[i]].timestamp = uint32(now);
      PriceUpdated(ofAssets[i], now, newPrices[i]);
    }
  }
  
  function getPrice(address[] _asset) constant returns (uint224) {
    return value[_asset].price;
  }
  
  function getTimestamp(address[] _asset) constant returns (uint32) {
    return value[_asset].timestamp;
  }
  
  function getValues(address _asset) constant returns (uint, uint224) {
    return getValues;
  }
  
  uint constant frequency = 120;
  uint constant validity = 60;
  Value public data;
  address quoteAsset;
  mapping (address => Values) data;
}
  
