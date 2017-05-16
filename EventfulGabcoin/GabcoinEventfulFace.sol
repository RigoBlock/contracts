//! Gabcoin Eventful Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Collects all events from all gabcoins

pragma solidity ^0.4.11;

contract GabcoinEventfulFace {

	// EVENTS

    event BuyGabcoin(address indexed gabcoin, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event SellGabcoin(address indexed gabcoin, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event NewFee(address indexed gabcoin, address indexed from, address indexed to, uint fee);
	event NewCollector(address indexed gabcoin, address indexed from, address indexed to, address collector);
	event GabcoinDAO(address indexed gabcoin, address indexed from, address indexed to, address gabcoinDAO);
	event DepositCasper(address indexed gabcoin, address indexed validator, address indexed casper, address withdrawal, uint amount);
	event WithdrawCasper(address indexed gabcoin, address indexed validator, address indexed casper, uint validatorIndex);
	event GabcoinCreated(address indexed gabcoin, address indexed group, address indexed owner, uint gabcoinID, string name, string symbol);

    // METHODS

    function buyGabcoin(address _who, address _targetGabcoin, uint _value, uint _amount) returns (bool success) {}
    function sellGabcoin(address _who, address _targetGabcoin, uint _amount, uint _revenue) returns(bool success) {}
    function changeRatio(address _who, address _targetGabcoin, uint256 _ratio) returns(bool success) {}
    function setTransactionFee(address _who, address _targetGabcoin, uint _transactionFee) returns(bool success) {}
    function changeFeeCollector(address _who, address _targetGabcoin, address _feeCollector) returns(bool success) {}
    function changeGabcoinDAO(address _who, address _targetGabcoin, address _gabcoinDAO) returns(bool success) {}
    function depositToCasper(address _who, address _targetGabcoin, address _casper, address _validation, address _withdrawal, uint _amount) returns(bool success) {}
    function withdrawFromCasper(address _who, address _targetGabcoin, address _casper, uint _validatorIndex) returns(bool success) {}
    function createGabcoin(address _who, address _gabcoinFactory, address _newGabcoin, string _name, string _symbol, uint _gabcoinId, address _owner) returns(bool success) {}
}
