//! Proof-of-Performance algorithm contract.
//! By Gabriele Rigo (RigoBlock, Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.16;

contract ProofOfPerformance {

    modifier only_minter {
        assert(msg.sender == minter);
        _;
    }
}    
