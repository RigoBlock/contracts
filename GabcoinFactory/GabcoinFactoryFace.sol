//! Gabcoin Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract GabcoinFactoryFace is Owned {

    event GabcoinCreated(string _name, address _gabcoin, address _owner, uint _gabcoinID);

    function createGabcoin(string _name, string _symbol, address _owner) returns (address _gabcoin, uint _gabcoinID) {}
    function setFee(uint _fee) {}
    function setBeneficiary(address _gabcoinDAO) {}
    function drain() {}
    function() {}
    function buyGabcoin(address targetGabcoin) payable {}
    function sellGabcoin(address targetGabcoin, uint256 amount) {}
    function changeRatio(address targetGabcoin, uint256 _ratio) {}
    function setTransactionFee(address targetGabcoin, uint _transactionFee) {}
    function changeFeeCollector(address targetGabcoin, address _feeCollector) {}
    function changeCoinator(address targetGabcoin, address _coinator) {}

    function getVersion() constant returns (string version) {}
    function geeLastId() constant returns (uint _dragoID) {}
    function getGabcoinDao() constant returns (uint gabcoinDao) {}
}
