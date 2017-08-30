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

contract Inflation {

     struct Performer {
  	uint deposit;
  	uint claimedTokens;
	bool hasClaimed;
	mapping(bool => uint);
     }

     modifier only_pool_owner(address thePool) {
        Pool pool = Pool(thePool);
        assert(msg.sender == pool.getOwner();
        _;
    }
    
    //in order to qualify for PoP user has to told at least some rigo token
    modifier minimum_rigoblock {
        RigoTok rigoToken = RigoTok(rigoblock);
        assert(minimumRigo <= rigoToken.balanceOf(msg.sender);
        _;
    }
    
    modifier only_rigoblock {
        require(msg.sender == _rigoblock);
    }
    
    modifier time_at_least {
        require(now >= endTime);
    }
    
    modifier has_not_withdrawn_epoch(_thePool) {
    	require(performers[_thePool].hasClaimed[epoch] != true);
    }
    
    function Inflation(address _rigoToken, address _proofOfPerformance, uint _inflationFactor) external only_rigoblock {
        rigoTok = RigoTok(_rigoToken);
	rigoblock = msg.sender;
        rigoTok.inflationFactor = _inflationFactor;
	startTime = now;
	endTime = now + period;
	proofOfPerformance = _proofOfPerformance;
    }

    function mintInflation() external only_rigoblock time_at_least {
    	startTime = now;
	endTime = now + period;
	++epoch;
        RigoTok rigoToken = RigoTok(_rigoTok);
	var inflation = rigoTok.totalSupply() * rigoTok.getInflationFactor() / 100 * 12 / 42); quartetly inflation of an annual rate
        rigoToken.mintToken(this, inflation);
	delete inflationTokens;
        inflationTokens = safeAdd(inflationTokens, inflation);
	porformers[this].deposit = safeAdd(porformers[this].deposit, claim);
    }
    
    function proof(address _pool) external only_pool_owner minimum_rigoblock has_not_withdrawn_epoch(_pool) {
    	RigoTok rigoToken = RigoTok(_rigoTok);
    	ProofOfPerformance pop = ProofOfPerformance(proofOfPerformance);
	var networkContribution = pop.proofOfPerformance(_pool);
	var claim = networContribution * inflationTokens;
	porformers[this].deposit = safeSub(porformers[this].deposit, claim);
	performers[_pool].claimedTokens = safeAdd(performers[_pool].claimedTokens, claim);
	performers[_pool].hasClaimed[epoch] = true;
	require(rigoToken.transferFrom(this, msg.sender, claim));	
    }
    
    validators[validator_index].deposit
    
    function proofTokens(address _account) internal returns(uint) {
    	update_account
    	RigoTok rigoToken = RigoTok(_rigoTok);
  	var newTokens = inflationTokens - performers[_account].claimedTokens;
  	return (performers[_account].deposit * newTokens) / rigoTok.totalSupply();
    }

    function setInflationFactor(uint _inflationFactor, address _rigoTok) only_rigoblock {
	RigoTok rigoToken = RigoTok(_rigoTok);
        rigoToken.inflationFactor(_inflationFactor);
    }
    
    function setRigoblock(address _newRigoblock) only_rigoblock {
    	rigoblock = _newRigoblock;
    }
    
    //set period on shorter subsets of time for testing
    function setPeriod(address _newPeriod) only_rigoblock {
    	period = _newPeriod;
    }
    
    function epochWithdrawal(address _pool) constant returns (bool) {
    	return performers[_pool].hasClaimed[epoch]; //indexing by epoch
    }
    
    uint public inflationTokens;
    uint startTime; //in order to reset at each subperiod
    uint endTime; //maybe each quarter, or even on a daily basis
    uint public period = 12 weeks; (inflation tokens can be minted every 3 months)
    uint public epoch; //mapping(uint=>bool/uint);
    bool has_withdrawn_in_epoch;
    address public rigoblock;
    address public proofOfPerformance;
    mapping(address=>Performer) performers;
    
    RigoTok rigoTok;

}
