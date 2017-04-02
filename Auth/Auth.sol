//! Authority contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Auth has the possibility of blocking/unblocking single user.

pragma solidity ^0.4.10;

contract Auth is Owned, AuthFace {

  function approveAccount(address target, bool approve) onlyOwner {
        approvedAccount[target] = approve;
        ApprovedFunds(target, approve);
  }
}
