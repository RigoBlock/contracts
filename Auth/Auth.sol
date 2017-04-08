//! Authority contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Auth has the possibility of blocking/unblocking single user.

pragma solidity ^0.4.10;

contract Auth is Owned, AuthFace {

  event SetAuthority (address indexed authority);
  event SetWhitelister (address indexed whitelister);
  event WhitelistedUser(address indexed target, bool approved);
  
  //modifier only_auth { assert(isAuthorized(msg.sender, msg.sig)); _; }
  modifier only_whitelister { if (!whitelistAdmins[msg.sender]) throw; _; }
  modifier only_admin { if (msg.sender != owner && !whitelistAdmins[msg.sender]) throw; _; }
  modifier only_whitelisted { if (!accounts[msg.sender].authorized) throw; _; }

  function setAuthority(address _authority) only_owner {
    authority = _authority;
    SetAuthority(authority);
  }
  
  function setWhitelister(address _whitelister) only_admin {
    whitelistAdmins[whitelister] = _whitelister;
  }
  
  function whitelistUser(address _target, bool _isWhitelisted) only_whitelister {
    accounts[_target].authorized = _isWhitelisted;
    WhitelistedUser(_target, _isWhitelisted);
  }

  function isWhitelistedUser(address _target) constant returns (bool) {}

  address public owner = msg.sender;
  address public auth = msg.sender;
  address[] public whitelister = msg.sender;
  mapping (address => bool) public approvedAccount;
}
