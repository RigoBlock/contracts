//! RigoBlock Token Interface contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract RigoTokFace {
    
    // EVENTS

    event TokenMinted(address indexed recipient, uint amount);

    // NON-CONSTANT METHODS

    function RigoTok(address setMinter, address setRigoblock, uint setStartTime, uint setEndTime) {}
    function mintToken(address recipient, uint amount) external {}
    function transfer(address recipient, uint amount) returns (bool success) {}
    function transferFrom(address sender, address recipient, uint amount) returns (bool success) {}
    function changeMintingAddress(address newAddress) {}
    function changeRigoblockAddress(address newAddress) {}
    function setStartTime(uint _startTime) {}
    function setEndTime(uint _endTime) {}
    function setInflationFactor(uint _inflationFactor) {}
    
    // CONSTANT METHODS

    function getName() constant returns (string name) {}
    function getSymbol() constant returns (string symbol) {}
    function getDecimals() constant returns (uint decimals) {}
    function getStartTime() constant returns (uint startTime) {}
    function getEndTime() constant returns (uint endTime) {}
    function getMinter() constant returns (address minter) {}
    function getRigoblock() constant returns (address rigoblock) {}
    function getInflationFactor() constant returns (uint) {}
}
