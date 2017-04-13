//! Drago contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Inspired by https://github.com/oraclize/ethereum-examples/blob/master/solidity/KrakenPriceTicker.sol

/*
   Kraken-based ETH/XBT price ticker

   This contract keeps in storage an updated ETH/XBT price,
   which is updated every ~60 seconds.
*/

pragma solidity ^0.4.10;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract KrakenPriceTicker is usingOraclize {
    
    event NewOraclizeQuery(string description);
    event NewKrakenPriceTicker(string price);
    event NewKrakenPriceTicker(uint price);

    function KrakenPriceTicker() {
        // FIXME: enable oraclize_setProof is production
        // oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
        update(0);
    }

    function __callback(bytes32 myid, string result, bytes proof) {
        if (msg.sender != oraclize_cbAddress()) throw;
        ETHUSD = parseInt(result, 2); // save it in storage as $ cents
        NewKrakenPriceTicker(ETHUSD);
        NewKrakenPriceTicker(result);
        // do something with ETHUSD
        // update(60); // FIXME: comment this out to enable recursive price updates
    }

    function update(uint delay) payable {
        if (oraclize_getPrice("URL") > this.balance) {
            NewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            oraclize_query(delay, "URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
            NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
        }
    }
    
    function getPrice() constant returns (uint ETHUSD) {
        return ETHUSD;
    }
    
    uint public ETHUSD;
}
