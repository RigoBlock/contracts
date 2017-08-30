//! Proof-of-Performance algorithm contract.
//! By Gabriele Rigo (RigoBlock, Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.16;

contract ProofOfPerformance {

    modifier only_minter {
        assert(msg.sender == minter);
        _;
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
    
    function ProofOfPerformance(address _rigoblock, address _dragoRegistry) {
        rigoblock = _rigoblock;
        dragoRegistry = _dragoRegistry;
    }
    
    function setRegistry(address _dragoRegistry) only_rigoblock {
        dragoRegistry = _dragoRegistry;
    }
    
    function setRigoblock(address _rigoblock) only_rigoblock {
        rigoblock = _rigoblock;
    }
    
    function calcNetworkValue() constant returns (uint256 totalAum) {
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        for (uint256 i = 0; i < registry.dragoCount(); ++i) {
            calcPoolValue(i);
            totalAum = sum(poolAUM(i));
        }
    }
    
    function calcPoolValue(address _ofPool) internal constant returns (uint256 poolAum) {
        Pool pool = Pool(_ofPool);
        uint poolPrice = pool.getPrice();       //uint256 poolPrice = Pool(ofPool).getPrice();
        uint poolTokens = pool.totalSupply();   //uint256 poolTokens = Pool(ofPool).totalSupply();
        uint256 poolAum = safeMul(poolPrice, poolTokens); //check whether to divide by a factor in order to prevent overflow
    }
    
    function proofOfPerformance(address _ofPool) only_pool_owner minimum_rigoblock {
        require(poolValue != 0);
        var poolValue = calcPoolValue(_ofPool);
        var networkValue = calcNetworkValue();
        RigoTok rigoToken = RigoTok(rigoblock);
        var rigoblockTokens = rigoToken.totalSupply();
        PoP = rigoblockTokens (*inflation / 100) * (poolValue) / networkValue;  //var PoP = networkValue / poolValue; (it is a multiplier, bigger as the fund is very small);
        //mapping of value per user
        //can claim in proportion to participation in excess to what has already been claimed
        //this can be developed in Inflation.sol
    }
    
    function setMinimumRigo(uint256 _amount) only_rigoblock {
        minimumRigo = _amount;
    }
    
    address public dragoRegistry;
    address public rigoblock;
    uint256 public totalAum;
    uint256 public minimumRigo;
    uint256 PoP;
}    
