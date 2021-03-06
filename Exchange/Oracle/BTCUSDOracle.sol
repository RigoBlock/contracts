//! Bitcoin/Dollar Oracle contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Owned {
    
    event NewOwner(address indexed old, address indexed current);
    
    modifier onlyOwner { if (msg.sender != owner) return; _; }
    
    function setOwner(address _new) only_owner {
        owner = _new;
        NewOwner(owner, _new);
    }
    
    address public owner = msg.sender;
}

contract OracleFace {
  
    event Changed(uint224 current);
  
    function updatePrice() {}
    function note(uint224 _value) {}
    
    function get() constant returns (uint224) {}
    function getTimestamp() constant returns (uint32) {}
}

contract Oracle is Owned, OracleFace {
  
    event Changed(uint224 current);
    
    struct Value {
      uint32 timestamp;
      uint224 value;
    }
    
    function note(uint224 _value) only_owner {
      if (data.value != _value) {
       data.value = _value;
       Changed(_value);
      }
	    data.timestamp = uint32(now);
    }
    
    function updatePrice() {}
    
    function get() constant returns (uint224) {
        return data.value;
    }

    function getTimestamp() constant returns (uint32) {
        return data.timestamp;
    }

    Value public data;
}

contract BTCUSDOracle is Oracle {

    function updatePrice() onlyOwner {
      feed = "json(https://poloniex.com/public?command=returnTicker).BTC_USD.last";
      newPrice = safeMul( feed*10**18 );
      // newPrice = json(https://api.coinmarketcap.com/v1/ticker/bitcoin/).price_usd
      note(newPrice);
    }
}
