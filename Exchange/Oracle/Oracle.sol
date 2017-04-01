//! Oracle contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

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
    
    function get() constant returns (uint224) {
        return data.value;
    }

    function get_timestamp() constant returns (uint32) {
        return data.timestamp;
    }

    Value public data;
}
