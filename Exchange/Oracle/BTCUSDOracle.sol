//! Bitcoin/Dollar Oracle contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract BTCUSDOracle.sol is Oracle {

  function updatePrice() onlyOwner {
    feed = json(https://poloniex.com/public?command=returnTicker).BTC_USD.last;
    newPrice = safeMul( feed*10**18 );
    // newPrice = json(https://api.coinmarketcap.com/v1/ticker/bitcoin/).price_usd
    note(newPrice);
  }
}
