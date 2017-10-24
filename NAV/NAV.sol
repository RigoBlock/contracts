//! NAV contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.18;

contract NAVFace {

  function estimateNAV() public returns (uint) {}
}

contract NAV is NAVFace {

  function estimateNAV() public returns (uint) {
    return estimateAUM();
  }

  //numAssignedAssets has to be defined
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
