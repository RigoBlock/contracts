//! Recovery contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Recovery is Owned, Multisig, RecoveryFace {

  event RecoveredOwner(address indexed _recoverer, address indexed _newOwner, address indexed _newRecoverer);
  
  modifier only_owner { assert(msg.sender == owner); _; }  
  modifier only_recovery_address { assert(msg.sender == owner); _; }
  modifier address_not_null(address addr) { assert(addr != 0); _; }
  
  function Recovery(address _recoverer) {
    recoverer = _recoverer;
  }
  
  function recoverOwner(address _newOwner) only_backup_owner address_not_null(_newOwner) {
    owner = msg.sender;
    recoveryOwner = _newOwner;
  }
 
  function setRecovery(address _newRecoverer) only_owner address_not_null(_newRecoverer) {
    recoverer = _newRecoverer;
    RecoveredOwner(address indexed _recoverer, address indexed _newOwner, address indexed _newRecoverer);
  }

 address public owner = msg.sender;
 address public _recoverer;
}
