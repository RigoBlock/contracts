//! Casper Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2..

pragma solidity ^0.4.11;

contract Casper {
    
    function deposit(address _validation, address _withdrawal) payable returns (bool success) {}
    function withdraw(uint _validatorIndex) returns (bool success) {}

    function balanceOf(address _who) constant returns (uint) {}
    //asked viper devs to implement this function
}
