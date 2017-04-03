//! Bitcoin/Ether Oracle contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract BTCETHOracle.sol is Oracle {

  function updatePrice() onlyOwner {
    feed = json(https://poloniex.com/public?command=returnTicker).BTC_ETH.last;
    newPrice = safeMul( feed * 10 ** 18 );
    // newPrice = safeDiv ( 1 / (json(https://api.bitfinex.com/v1/pubticker/ethbtc).last_price));
    note(newPrice);
  }
}

  //json(https://api.kraken.com/0/public/Ticker?pair=ETHEUR).result.XETHZEUR.c.0
 
