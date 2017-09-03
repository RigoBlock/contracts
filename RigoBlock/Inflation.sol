/*

  Copyright 2017 RigoBlock, Rigo Investment Sagl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity 0.4.16;

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

	function balanceOf(address _who) constant returns (uint) {}
	function getEventful() constant returns (address) {}
	function getData() constant returns (string name, string symbol, uint sellPrice, uint buyPrice) {}
	function getAdminData() constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {}
	function getOwner() constant returns (address) {}
	function totalSupply() constant returns (uint256) {}
}

contract ERC20 {

	//EVENTS
	
	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  
  	//METHODS
	
  	function transfer(address _to, uint256 _value) returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
	function approve(address _spender, uint256 _value) returns (bool success) {}

	function totalSupply() constant returns (uint256 total) {}
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

    function balanceOf(address _owner) constant returns (uint256) {}
    function getName() constant returns (string) {}
    function getSymbol() constant returns (string) {}
    function getDecimals() constant returns (uint) {}
    function getStartTime() constant returns (uint) {}
    function getEndTime() constant returns (uint) {}
    function getMinter() constant returns (address) {}
    function getRigoblock() constant returns (address) {}
    function getInflationFactor() constant returns (uint) {}
    function totalSupply() constant returns (uint256) {}
}

contract ProofOfPerformance {

    function setRegistry(address _dragoRegistry) {}
    function setRigoblock(address _rigoblock) {}
    function setMinimumRigo(uint256 _amount) {}
    
    function calcNetworkValue() constant returns (uint256 totalAum) {}
    function calcPoolValue(uint256 _ofPool) internal constant returns (uint256 poolAum) {}
    function proofOfPerformance(uint _ofPool) constant returns (uint256 PoP) {}
    function getPoolAddress(uint _ofPool) public constant returns (address) {}
}

contract Inflation is SafeMath {

    struct Performer {
  	    uint deposit;
  	    uint claimedTokens;
	    bool hasClaimed;
	    mapping(uint => bool) claim;
    }

     modifier only_pool_owner(address thePool) {
        Pool pool = Pool(thePool);
        assert(msg.sender == pool.getOwner());
        _;
    }
    
    //in order to qualify for PoP user has to told at least some rigo token
    modifier minimum_rigoblock {
        RigoTok rigoToken = RigoTok(rigoblock);
        assert(minimumRigo <= rigoToken.balanceOf(msg.sender));
        _;
    }
    
    modifier only_rigoblock {
        require(msg.sender == rigoblock); _;
    }
    
    modifier time_at_least {
        require(now >= endTime); _;
    }

    modifier has_not_withdrawn_epoch(address _thePool) {
    	require(performers[_thePool].claim[epoch] != true); _;
    	//require(performers[_thePool].hasClaimed != true); _; //this has to be corrected for sure
    }
    
    function Inflation(address _rigoToken, address _proofOfPerformance, uint _inflationFactor) only_rigoblock {
        RigoTok rigoToken = RigoTok(_rigoToken);
        rigo = _rigoToken;
	    rigoblock = msg.sender;
        rigoToken.setInflationFactor(_inflationFactor);
	    startTime = now;
	    endTime = now + period;
	    proofOfPerformance = _proofOfPerformance;
    }

    function mintInflation() external only_rigoblock time_at_least {
    	startTime = now;
	    endTime = now + period;
	    ++epoch;
        RigoTok rigoToken = RigoTok(rigo);
	    var inflation = rigoToken.totalSupply() * rigoToken.getInflationFactor() / 100 * 12 / 42; //quartetly inflation of an annual rate
        rigoToken.mintToken(this, inflation);
	    delete inflationTokens; //if we ignore this, late users might be able to recover a portion
        inflationTokens = safeAdd(inflationTokens, inflation);
	    performers[this].deposit = safeAdd(performers[this].deposit, inflationTokens); //claim);
    }
    
    function proof(address _pool, uint _ofPool) external only_pool_owner(_pool) minimum_rigoblock has_not_withdrawn_epoch(_pool) {
    	RigoTok rigoToken = RigoTok(rigo);
    	ProofOfPerformance pop = ProofOfPerformance(proofOfPerformance);
    	//address thePool = pop.getPoolAddress(_ofPool); //NOT USED, IN CASPER DEPOSITS ARE LOOKED UP FROM ID VALIDATOR, DOUBLE CHECK WHETHER IT'S A SMART MOVE HERE AS WELL
	    var networkContribution = pop.proofOfPerformance(_ofPool);
	    var claim = networkContribution * inflationTokens;
	    performers[this].deposit = safeSub(performers[this].deposit, claim);
	    performers[_pool].claimedTokens = safeAdd(performers[_pool].claimedTokens, claim);
	    performers[_pool].claim[epoch] = true;
	    //performers[_pool].hasClaimed = true; //we have to map per epoch, one claim allowed for each subperiod
	    require(rigoToken.transferFrom(this, msg.sender, claim));	
    }
    
    /* //TODO: double check as it is being used in Proof-of-Performance
    function proofTokens(address _pool) internal returns(uint) { //or constant?
    	RigoTok rigoToken = RigoTok(_rigoTok);
  	    var newTokens = inflationTokens - performers[_pool].claimedTokens;
  	    return (performers[_pool].deposit * newTokens) / rigoTok.totalSupply();
    }
    */

    function setInflationFactor(uint _inflationFactor, address _rigoTok) only_rigoblock {
	    RigoTok rigoToken = RigoTok(_rigoTok);
        rigoToken.setInflationFactor(_inflationFactor);
    }
    
    //TODO: check whether this functions should be moved to authority or rigoDAO
    function setMinimumRigo(uint _minimum) only_rigoblock {
        minimumRigo = _minimum;
    }
    
    function setRigoblock(address _newRigoblock) only_rigoblock {
    	rigoblock = _newRigoblock;
    }
    
    //set period on shorter subsets of time for testing
    function setPeriod(uint _newPeriod) only_rigoblock {
    	period = _newPeriod;
    }
    
    function epochWithdrawal(address _pool) constant returns (bool) {
    	return performers[_pool].claim[epoch]; //indexing by epoch
    	//return performers[_pool].hasClaimed; //indexing by epoch. this function has to be amended
    }
    
    uint public inflationTokens;
    uint startTime; //in order to reset at each subperiod
    uint endTime; //maybe each quarter, or even on a daily basis
    uint public period = 12 weeks; //(inflation tokens can be minted every 3 months)
    uint public epoch; //mapping(uint=>bool/uint);
    uint minimumRigo; //double check whether to get minimumRigo from an authority/Dao contract
    bool has_withdrawn_in_epoch;
    address public rigoblock;
    address public proofOfPerformance;
    address public rigo; //double check whether we can find it differently
    mapping(address=>Performer) performers;
}
