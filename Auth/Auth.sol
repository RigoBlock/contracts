//! Authority contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Auth has the possibility of blocking/unblocking single user.

pragma solidity ^0.4.10;

contract Auth is Owned, AuthFace {

  event ApprovedUser(address target, bool approved);

  function approveUser(address target, bool approve) onlyOwner {
        approvedAccount[target] = approve;
        ApprovedFunds(target, approve);
  }
  
  function setWhitelister(address whitelister, bool isWhitelister) onlyOwner {
    whitelistAdmins[whitelister] = isWhitelister;
  }

  modifier onlyWhitelister {
    if (!whitelistAdmins[msg.sender]) throw;
    _;
  }

  modifier onlyAdmin {
    if (msg.sender != owner && !admins[msg.sender]) throw;
    _;
  }
  
  function setWhitelisted(address target, bool isWhitelisted) onlyWhitelister {
    accounts[target].authorized = isWhitelisted;
  }
}
