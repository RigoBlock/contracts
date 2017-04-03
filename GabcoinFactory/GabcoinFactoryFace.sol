//! Gabcoin Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

library GabcoinFactoryFace is Owned {
	
    event GabcoinCreated(string _name, address _gabcoin, address _owner, uint _gabcoinID);

    function createGabcoin(string _name, string _symbol, address _owner) when_fee_paid returns (address _gabcoin, uint _gabcoinID) {}
    function setFee(uint _fee) onlyOwner {}
    function setBeneficiary(address _gabcoinDAO) onlyOwner {}
    function drain() onlyOwner {}
    function() {}
    function buyGabcoin(address targetGabcoin) payable {}
    function sellGabcoin(address targetGabcoin, uint256 amount) {}
    function changeRatio(address targetGabcoin, uint256 _ratio) only_gabcoin_dao {}
    function setTransactionFee(address targetGabcoin, uint _transactionFee) {}
    function changeFeeCollector(address targetGabcoin, address _feeCollector) {}
    function changeCoinator(address targetGabcoin, address _coinator) {}
    
    function getVersion() constant returns (string version) {}
    function geeLastId() constant returns (uint _dragoID) {}
    function getGavcoinDAO() constant returns (uint gabcoinDAO) {}
}
