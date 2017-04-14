//! Mortal contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! recoup fees by selfdistructing

pragma solidity ^0.4.10;

import "./Owned.sol";

contract Mortal is Owned {

    function kill() {
        if (msg.sender == owner)
            selfdestruct(owner);
    }
}
