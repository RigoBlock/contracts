//! Gabcoin Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract GabcoinFactoryFace is Owned {

	event GabcoinCreated(string _name, address _gabcoin, address _owner, uint _gabcoinID);
	//event GabcoinBought();
	//event GabcoinSold();
	//event CasperDeposit(uint msg.value, address indexed msg.sender, address indexed _validation, address indexed _withdrawal, address _casper);
 	//event CasperWithdraw(uint deposit, address indexed msg.sender, address _casper);

	function createGabcoin(string _name, string _symbol, address _owner) returns (address _gabcoin, uint _gabcoinID) {}
	function setFee(uint _fee) {}
	function setBeneficiary(address _gabcoinDAO) {}
	function drain() {}
	function() {}
	function buyGabcoin(address targetGabcoin) payable {}
	function sellGabcoin(address targetGabcoin, uint256 amount) {}
	//function depositCasper(address targetGabcoin, address _casper) {}
	//function withdrawCasper(address targetGabcoin, address _casper) {}
	function changeRatio(address targetGabcoin, uint256 _ratio) {}
	function setTransactionFee(address targetGabcoin, uint _transactionFee) {}
	function changeFeeCollector(address targetGabcoin, address _feeCollector) {}
	function changeCoinator(address targetGabcoin, address _coinator) {}

	function getVersion() constant returns (string version) {}
	function geeLastId() constant returns (uint _dragoID) {}
	function getGabcoinDao() constant returns (address gabcoinDao) {}
	//function getCasper() constant returns (address casper) {}
}
