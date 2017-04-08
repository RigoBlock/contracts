//! Authority contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Auth has the possibility of blocking/unblocking single user.

pragma solidity ^0.4.10;

contract Auth is Owned, AuthFace {

  event SetAuthority (address indexed authority);
  event SetOwner (address indexed owner);
  event ApprovedUser(address indexed target, bool approved);
  
  modifier only_auth { assert(isAuthorized(msg.sender, msg.sig)); _; }
  modifier only_authorized(bytes4 sig) { assert(isAuthorized(msg.sender, sig)); _; }  
  modifier only_whitelister { if (!whitelistAdmins[msg.sender]) throw; _; }
  modifier only_admin { if (msg.sender != owner && !admins[msg.sender]) throw; _; }
  modifier only_whitelisted { if (!accounts[msg.sender].authorized) throw; _; }

  function approveUser(address target, bool approve) onlyOwner {
        approvedAccount[target] = approve;
        ApprovedFunds(target, approve);
  }
  
  function setOwner(address _owner) only_auth {
    owner = owner_;
    SetOwner(owner);
  }

  function setAuthority(address _authority) only_auth {
    authority = _authority;
    SetAuthority(authority);
  }
  
  function setWhitelister(address whitelister, bool isWhitelister) only_owner {
    whitelistAdmins[whitelister] = isWhitelister;
  }
  
  function isAuthorized(address src, bytes4 sig) internal returns (bool) {
    if (src == owner) {
      return true;
    } else if (authority == DSAuthority(0)) {
      return false;
    } else {
      return authority.canCall(src, this, sig);
    }
  }
  
  function setWhitelisted(address target, bool isWhitelisted) onlyWhitelister {
    accounts[target].authorized = isWhitelisted;
  }
  
  function canCall(address src, address dst, bytes4 sig) constant returns (bool);
  
  Authority public authority;
  address public owner = msg.sender;
  address public logOwner = msg.sender;
}
