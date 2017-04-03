//! NAV contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract NAV is NAVFace {

  function estimateNAV() returns (uint) {
    return estimateAUM();
  }

  function estimateAUM(address _drago) internal returns (uint256 aum) {
    for (uint i = 0; i < numAssignedAssets; ++i) {
      address _asset = address(asset(i));
      ExchangFace exchange = ExchangeFace(_drago);
      uint holdings = exchange.balanceOf(this); // Amount of asset base units this core holds
      PricesFace prices = PricesFace(address(allAssets.prices(i)));
      price = prices.getPrices(_asset);
      aum = safeMul(holdings * prices);
      nav = safeDiv( aum / totalSupply);
      AumValue(holdings, price);
    }  
  } 
}
