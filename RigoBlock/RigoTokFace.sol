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

    function balanceOf(address _owner) constant returns (uint256 balance) {}
    function totalSupply() constant returns (uint256 totalSupply) {}
    function getName() constant returns (string) {}
    function getSymbol() constant returns (string) {}
    function getDecimals() constant returns (uint) {}
    function getStartTime() constant returns (uint) {}
    function getEndTime() constant returns (uint) {}
    function getMinter() constant returns (address) {}
    function getRigoblock() constant returns (address) {}
    function getInflationFactor() constant returns (uint) {}
}
