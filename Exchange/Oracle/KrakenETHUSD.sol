//! Kraken ETHUSD Feed contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Inspired by https://github.com/oraclize/ethereum-examples/blob/master/solidity/KrakenPriceTicker.sol

/*
   Kraken-based ETH/XBT price ticker

   This contract keeps in storage an updated ETH/XBT price,
   which is updated every ~60 minutes.
*/

pragma solidity ^0.4.10;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract Owned {
    
    modifier only_owner { if (msg.sender != owner) return; _; }
    
    event NewOwner(address indexed old, address indexed current);
    
    function setOwner(address _new) only_owner {
        owner = _new;
        NewOwner(owner, _new);
    }

    address public owner = msg.sender;
}

contract OracleFace {
  
    event Changed(uint224 current);
  
    function updatePrice() {}
    function note(uint224 _value) internal {}
    
    function get() constant returns (uint) {}
    function getPrice() constant returns (uint224) {}
    function getTimestamp() constant returns (uint32) {}
}

contract Oracle is Owned, OracleFace {
  
    event Changed(uint224 current);
    
    struct Value {
      uint32 timestamp;
      uint224 value;
    }
    
    function note(uint224 _value) internal {
      if (data.value != _value) {
       data.value = _value;
       Changed(_value);
      }
	    data.timestamp = uint32(now);
    }
    
    function get() constant returns (uint) {}
    
    function getPrice() constant returns (uint224) {
        return data.value;
    }

    function getTimestamp() constant returns (uint32) {
        return data.timestamp;
    }

    Value public data;
}

contract KrakenPriceTicker is usingOraclize, Oracle {
    
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
        var price = uint224(ETHUSD);
        note(price); // do something with ETHUSD
        update(3600); // recursive price update every 60 minutes
    }

    function update(uint delay) payable {
        if (oraclize_getPrice("URL") > this.balance) {
            NewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            oraclize_query(delay, "URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
            NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
        }
    }
    
    function() payable only_owner {} //allows to charge-up the contract without interfering with normal update loop
    
    function get() constant returns (uint) {
        return ETHUSD;
    }
    
    uint public ETHUSD;
}
