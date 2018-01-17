//! the inflation contract.
//!
//! Copyright 2017-2018 Gabriele Rigo, RigoBlock, Rigo Investment Sagl.
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

pragma solidity 0.4.19;

contract SafeMath {

    function safeMul(uint a, uint b) internal returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }
    
    function safeDiv(uint a, uint b) internal returns (uint) {
        assert(b > 0);
        uint c = a / b;
        assert(a == b * c + a % b);
        return c;
    }

    function safeSub(uint a, uint b) internal returns (uint) {
        assert(b <= a);
        return a - b;
    }

    function safeAdd(uint a, uint b) internal returns (uint) {
        uint c = a + b;
        assert(c>=a && c>=b);
        return c;
    }
    
    function max64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a >= b ? a : b;
    }

    function min64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a < b ? a : b;
    }

    function max256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a >= b ? a : b;
    }

    function min256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a < b ? a : b;
    }
}

contract Pool {
    

	function buyDrago() payable returns (bool success) {}
	function sellDrago(uint _amount) returns (uint revenue, bool success) {}
	function setPrices(uint _newSellPrice, uint _newBuyPrice) {}
	function changeMinPeriod(uint32 _minPeriod) {}
	function changeRatio(uint _ratio) {}
	function setTransactionFee(uint _transactionFee) {}
	function changeFeeCollector(address _feeCollector) {}
	function changeDragoDAO(address _dragoDAO) {}
	function depositToExchange(address _exchange, address _token, uint _value) {}
	function withdrawFromExchange(address _exchange, address _token, uint _value) {}
	function placeOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) {}
	function placeTradeExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, address _user, uint _amount) {}
	function placeOrderCFDExchange(address _exchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) {}
	function cancelOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) {}
	function cancelOrderCFDExchange(address _exchange, address _cfd, uint32 _id) {}
	function finalizeDealCFDExchange(address _exchange, address _cfd, uint24 _id) {}
	function setOwner(address _new) {}
	function() payable {}   // only_approved_exchange(msg.sender)

	function balanceOf(address _who) constant returns (uint256 balance) {}
	function totalSupply() constant returns (uint256 totalSupply) {}
	function getEventful() constant returns (address) {}
	function getData() constant returns (string name, string symbol, uint sellPrice, uint buyPrice) {}
	function getAdminData() constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {}
	function getOwner() constant returns (address) {}
}

contract ERC20 {

	//EVENTS
	
	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  
  	//METHODS
	
  	function transfer(address _to, uint256 _value) returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
	function approve(address _spender, uint256 _value) returns (bool success) {}

	function totalSupply() constant returns (uint256 totalSupply) {}
	function balanceOf(address _who) constant returns (uint256 balance) {}
	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
}

contract RigoTok {

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

contract InflationFace {

    // NON-CONSTANT METHODS

    function mintInflation(address _thePool, uint _reward) external returns (bool) {}
    function setInflationFactor(address _group, uint _inflationFactor) public {}
    function setMinimumRigo(uint _minimum) public {}
    function setRigoblock(address _newRigoblock) public {}
    function setPeriod(uint _newPeriod) public {}
    
    // CONSTANT METHODS
    
    function canWithdraw(address _thePool) public constant returns (bool) {}
}

contract Inflation is SafeMath {

    struct Performer {
  	    uint claimedTokens;
	    mapping(uint => bool) claim;
        uint startTime;
        uint endTime;
        uint epoch;
    }
    
    struct Group {
        uint epochReward;
    }

    //in order to qualify for PoP user has to told at least some rigo token
    modifier minimum_rigoblock(address ofPool) {
        RigoTok rigoToken = RigoTok(rigoblock);
        Pool pool = Pool(pool);
        assert(minimumRigo <= rigoToken.balanceOf(pool.getOwner()));
        _;
    }

    modifier only_rigoblock {
        require(msg.sender == rigoblock); _;
    }
    
    modifier only_proof_of_performance {
        require(msg.sender == proofOfPerformance); _;
    }

    modifier time_at_least(address _thePool) {
        require(now >= performers[_thePool].endTime); _;
    }

    function Inflation(address _rigoToken, address _proofOfPerformance) public only_rigoblock {
        rigo = _rigoToken;
	    rigoblock = msg.sender;
	    proofOfPerformance = _proofOfPerformance;
    }

    function mintInflation(address _thePool, uint _reward)
        external
        only_proof_of_performance
        minimum_rigoblock(_thePool)
        time_at_least(_thePool)
        returns (bool)
    {
    	performers[_thePool].startTime = now;
	    performers[_thePool].endTime = now + period;
	    ++performers[_thePool].epoch;
        uint reward = _reward * 95 / 100; //5% royalty to rigoblock
        uint rigoblockReward = safeSub(_reward, reward);
        Pool pool = Pool(_thePool);
        address poolOwner = pool.getOwner();
        RigoTok rigoToken = RigoTok(rigo);
        rigoToken.mintToken(poolOwner, reward);
        rigoToken.mintToken(rigoblock, rigoblockReward);
        return true;
    }

    function setInflationFactor(address _group, uint _inflationFactor) public only_rigoblock {
        groups[_group].epochReward = _inflationFactor;
    }

    //TODO: check whether this functions should be moved to authority or rigoDAO
    function setMinimumRigo(uint _minimum) public only_rigoblock {
        minimumRigo = _minimum;
    }

    function setRigoblock(address _newRigoblock) public only_rigoblock {
    	rigoblock = _newRigoblock;
    }

    //set period on shorter subsets of time for testing
    function setPeriod(uint _newPeriod) public only_rigoblock {
    	period = _newPeriod;
    }

    function canWithdraw(address _thePool) public constant returns (bool) {
    	return (now >= performers[_thePool].endTime ? true : false);
    }

    uint public period = 12 weeks; //(inflation tokens can be minted every 3 months)
    uint minimumRigo; //double check whether to get minimumRigo from an authority/Dao contract
    address public proofOfPerformance;
    address public rigoblock;
    address public rigo; //this is the address of the Rigo token //double check whether we can find it differently
    mapping(address => Performer) performers;
    mapping(address => Group) groups;
}
