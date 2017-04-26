//! Oracle contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

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
