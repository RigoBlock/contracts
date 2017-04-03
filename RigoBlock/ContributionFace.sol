//! Contribution Interface contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.8;

contract Contribution is SafeMath {

    event TokensBought(address indexed sender, uint eth, uint amount);
    
    function Contribution(address setRigoblock, address setSigner, uint setStartTime) {}
    function buy(uint8 v, bytes32 r, bytes32 s) payable {}
    function halt() onlyRigoblock {}
    function unhalt() only_melonport {}
    function changeRigoblockAddress(address newAddress) onlyRigoblock {}
    
    function priceRate() constant returns (uint) {}
    function getEtherCap() constant returns (uint ETHER_CAP) {}
    function getStartTime() constant returns (uint startTime) {}
    function getEndTime() constant returns (uint endTime) {}
    function getRigoblock() constant returns (address rigoblock) {}
}
