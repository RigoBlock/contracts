//! the Distribution contract.
//!
//! Copyright 2018 Gabriele Rigo, RigoBlock, Rigo Investment Sagl.
//!
//! Licensed under the Apache License, Version 2.0 (the "License");
//! you may not use this file except in compliance with the License.
//! You may obtain a copy of the License at
//!
//!     http://www.apache.org/licenses/LICENSE-2.0
//!
//! Unless required by applicable law or agreed to in writing, software
//! distributed under the License is distributed on an "AS IS" BASIS,
//! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//! See the License for the specific language governing permissions and
//! limitations under the License.

pragma solidity ^0.4.19;

contract SafeMath {

	function safeMul(uint a, uint b) internal pure returns (uint) {
		uint c = a * b;
		assert(a == 0 || c / a == b);
		return c;
	}
    
	function safeDiv(uint a, uint b) internal pure returns (uint) {
		assert(b > 0);
		uint c = a / b;
		assert(a == b * c + a % b);
		return c;
	}

	function safeSub(uint a, uint b) internal pure returns (uint) {
		assert(b <= a);
		return a - b;
	}

	function safeAdd(uint a, uint b) internal pure returns (uint) {
		uint c = a + b;
		assert(c>=a && c>=b);
		return c;
	}
}  

contract Gabcoin {

	event Buy(address indexed from, address indexed to, uint256 indexed amount, uint256 revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed amount,uint256 revenue);
	event DepositCasper(uint amount, address indexed who, address indexed validation, address indexed withdrawal);
 	event WithdrawCasper(uint deposit, address indexed who, address casper);
 
	function() payable {}
	function deposit(address _token, uint _amount) payable returns (bool success) {}
	function withdraw(address _token, uint _amount) returns (bool success) {}
	function buyGabcoin() payable returns (bool success) {}
	function buyGabcoinOnBehalf(address _hodler) payable returns (bool success) {}
	function sellGabcoin(uint256 amount) returns (bool success) {}
	function depositCasper(address _validation, address _withdrawal, uint _amount) returns (bool success) {}
    function withdrawCasper(uint _validatorIndex) {}
	function changeRatio(uint256 _ratio) {}	
	function setTransactionFee(uint _transactionFee) {}	
	function changeFeeCollector(address _feeCollector) {}	
	function changeGabcoinDAO(address _gabcoinDAO) {}
	function updatePrice() {}
	function changeMinPeriod(uint32 _minPeriod) {}

    function getMinPeriod() constant returns (uint32) {}
	function balanceOf(address _from) constant returns (uint) {}
	function getVersion() constant returns (string) {}
	function getName() constant returns (string) {}
	function getSymbol() constant returns (string) {}
	function getPrice() constant returns (uint) {}
	function getCasper() constant returns (address) {}
	function getTransactionFee() constant returns (uint) {}
	function getFeeCollector() constant returns (address) {}
	
	function getEventful() public constant returns (address) {}
	function getData() public constant returns (string name, string symbol, uint sellPrice, uint buyPrice) {}
	function getAdminData() public constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {}
	function getOwner() public constant returns (address) {}
	function totalSupply() public constant returns (uint256) {}
}


contract Distribution is SafeMath {

    event Subscription(address indexed buyer, address indexed distributor, uint amount);
    
    struct Distributor {
        uint fee;
    }
    
    modifier address_free(address _distributor) {
        require(distributor[_distributor].fee == 0);
        _;
    }
    
    modifier non_zero_address(address _target) {
        require(_target != 0);
        _;
    }
    
    function subscribe(address _pool, address _distributor, address _buyer) {
        Gabcoin gabcoin = Gabcoin(_pool);
        gabcoin.buyGabcoinOnBehalf(_buyer);
        uint feeAmount = safeDiv(safeMul(msg.value, distributor[_distributor].fee), 10000); //fee is in basis points
        uint netAmount = safeSub(msg.value, feeAmount);
        _pool.transfer(netAmount);
        _distributor.transfer(feeAmount);
    }
    
    function setFee(uint _fee, address _distributor)
        public
        address_free(_distributor)
        non_zero_address(_distributor)
    {
        distributor[_distributor].fee = _fee;
    }
    
    function getFee(address _distributor) public constant returns (uint) {
        return distributor[_distributor].fee;
    }
    
    mapping (address => Distributor) distributor;
}
