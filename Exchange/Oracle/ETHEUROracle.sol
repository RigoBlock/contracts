//! Bitcoin/Ether Oracle contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract ETHEUROracle.sol is Oracle {

  function updatePrice() onlyOwner {
    feed = json(https://api.kraken.com/0/public/Ticker?pair=ETHEUR).result.XETHZEUR.c.0;
    newPrice = safeMul( feed * 10 ** 18 );
    note(newPrice);
  }
}
