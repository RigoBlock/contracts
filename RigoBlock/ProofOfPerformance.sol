//! The proof-of-performance contract.
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
    
    function max64(uint64 a, uint64 b) internal pure returns (uint64) {
        return a >= b ? a : b;
    }

    function min64(uint64 a, uint64 b) internal pure returns (uint64) {
        return a < b ? a : b;
    }

    function max256(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function min256(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}

contract Pool {
    

	function buyDrago() public payable returns (bool success) {}
	function sellDrago(uint _amount) public returns (uint revenue, bool success) {}
	function setPrices(uint _newSellPrice, uint _newBuyPrice) public {}
	function changeMinPeriod(uint32 _minPeriod) public {}
	function changeRatio(uint _ratio) public {}
	function setTransactionFee(uint _transactionFee) public {}
	function changeFeeCollector(address _feeCollector) public {}
	function changeDragoDAO(address _dragoDAO) public {}
	function depositToExchange(address _exchange, address _token, uint _value) public {}
	function withdrawFromExchange(address _exchange, address _token, uint _value) public {}
	function placeOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) public {}
	function placeTradeExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, address _user, uint _amount) public {}
	function placeOrderCFDExchange(address _exchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) public {}
	function cancelOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) public {}
	function cancelOrderCFDExchange(address _exchange, address _cfd, uint32 _id) public {}
	function finalizeDealCFDExchange(address _exchange, address _cfd, uint24 _id) public {}
	function setOwner(address _new) public {}
	function() public payable {}   // only_approved_exchange(msg.sender)

	function balanceOf(address _who) public constant returns (uint balance) {}
	function totalSupply() public constant returns (uint256 totalSupply) {}
	//TODO: the below function is implemented in Gaboins but is aggregated in Dragos
	function getPrice() public constant returns (uint256 price) {}
	function getEventful() public constant returns (address) {}
	function getData() public constant returns (string name, string symbol, uint sellPrice, uint buyPrice) {}
	function getAdminData() public constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {}
	function getOwner() public constant returns (address) {}
}

contract RigoTok {

    // EVENTS

    event TokenMinted(address indexed recipient, uint amount);

    // NON-CONSTANT METHODS

    function RigoTok(address setMinter, address setRigoblock, uint setStartTime, uint setEndTime) public {}
    function mintToken(address recipient, uint amount) external {}
    function transfer(address recipient, uint amount) public returns (bool success) {}
    function transferFrom(address sender, address recipient, uint amount) public returns (bool success) {}
    function changeMintingAddress(address newAddress) public {}
    function changeRigoblockAddress(address newAddress) public {}
    function setStartTime(uint _startTime) public {}
    function setEndTime(uint _endTime) public {}
    function setInflationFactor(uint _inflationFactor) public {}
    
    // CONSTANT METHODS

    function balanceOf(address _owner) public constant returns (uint256 balance) {}
    function totalSupply() public constant returns (uint256 totalSupply) {}
    function getName() public constant returns (string) {}
    function getSymbol() public constant returns (string) {}
    function getDecimals() public constant returns (uint) {}
    function getStartTime() public constant returns (uint) {}
    function getEndTime() public constant returns (uint) {}
    function getMinter() public constant returns (address) {}
    function getRigoblock() public constant returns (address) {}
    function getInflationFactor() public constant returns (uint) {}
}

contract DragoRegistry {

	//EVENTS

	event Registered(string name, string symbol, uint id, address indexed drago, address indexed owner, address indexed group);
	event Unregistered(string indexed symbol, uint indexed id);
	event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);
	
	// METHODS
        
	function register(address _drago, string _name, string _symbol, uint _dragoID, address _owner) payable public returns (bool) {}
	function registerAs(address _drago, string _name, string _symbol, uint _dragoID, address _owner, address _group) payable public returns (bool) {}
	function unregister(uint _id) public {}
	function setMeta(uint _id, bytes32 _key, bytes32 _value) public {}
	function setFee(uint _fee) public {}
	function upgrade(address _newAddress) payable external {}
	function setUpgraded(uint _version) external {}
	function drain() external {}
	function kill() external {}
	
	function dragoCount() public constant returns (uint) {}
	function drago(uint _id) public constant returns (address drago, string name, string symbol, uint dragoID, address owner, address group) {}
	// TODO: IMPLEMENT fromId function in registry
	function fromId(uint id) public constant returns (address) {}
	function fromAddress(address _drago) public constant returns (uint id, string name, string symbol, uint dragoID, address owner, address group) {}
	function fromSymbol(string _symbol) public constant returns (uint id, address drago, string name, uint dragoID, address owner, address group) {}
	function fromName(string _name) public constant returns (uint id, address drago, string symbol, uint dragoID, address owner, address group) {}
	function fromNameSymbol(string _name, string _symbol) public constant returns (address) {}
	function meta(uint _id, bytes32 _key) public constant returns (bytes32) {}
	function getGroups(address _group) public constant returns (address[]) {}
	function getFee() public constant returns (uint) {}
}

contract Inflation {

    // NON-CONSTANT METHODS

    function mintInflation(address _thePool, uint _reward) external returns (bool) {}
    function setInflationFactor(address _group, uint _inflationFactor) public {}
    function setMinimumRigo(uint _minimum) public {}
    function setRigoblock(address _newRigoblock) public {}
    function setPeriod(uint _newPeriod) public {}
    
    // CONSTANT METHODS
    
    function canWithdraw(address _thePool) public constant returns (bool) {}
    function getInflationFactor(address _group) public constant returns (uint) {}
}

contract ProofOfPerformanceFace {

    function setRegistry(address _dragoRegistry) external {}
    function setRigoblock(address _rigoblock) external{}
    function setMinimumRigo(uint256 _amount) external {}
    
    function addressFromId(uint _ofPool) public constant returns (address pool, address group) {}
    //temp commt function calcPoolValue(uint256 _ofPool) public constant returns (uint256 aum, bool success) {}
    //temporary comment //function calcNetworkValue() public constant returns (uint networkValue) {}
    //function proofOfPerformance(uint _ofPool) public constant returns (uint256 PoP) {}
    //function getPoolAddress(uint _ofPool) public constant returns (address) {}
}

contract ProofOfPerformance is SafeMath, ProofOfPerformanceFace {
    
    struct PoolPrice {
        uint highwatermark;
    }
    
    struct Group {
        uint rewardRatio;
    }

    modifier only_minter { RigoTok token = RigoTok(rigoblockToken);
        assert(msg.sender == token.getMinter());
        _;
    }

    modifier only_rigoblock_dao {
        require(msg.sender == rigoblockDao);
        _;
    }

    /*
    modifier only_pool_owner(address thePool) {
        Pool pool = Pool(thePool);
        assert(msg.sender == pool.getOwner());
        _;
    }
    */

    modifier only_pool_owner(uint thePool) {
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        var poolAddress = registry.fromId(thePool);
        Pool pool = Pool(poolAddress);
        assert(msg.sender == pool.getOwner());
        _;
    }

    //in order to qualify for PoP user has to told at least some rigo token
    modifier minimum_rigoblock {
        RigoTok rigoToken = RigoTok(rigoblockToken);
        assert(minimumRigo <= rigoToken.balanceOf(msg.sender));
        _;
    }

    function ProofOfPerformance(
        address _rigoblockToken,
        address _rigoblockDao,
        address _dragoRegistry,
        address _inflation)
        public
    {
        rigoblockToken = _rigoblockToken;
        rigoblockDao = rigoblockDao;
        dragoRegistry = _dragoRegistry;
        inflation = _inflation;
    }

    function claimPop(uint _ofPool) public {
        Inflation infl = Inflation(inflation);
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        var(poolAddress,b,c,d,e,f) = registry.drago(_ofPool);
        var (PoP) = proofOfPerformance(_ofPool);
        var (price, supply) = getPoolPrice(_ofPool);
        poolPrice[_ofPool].highwatermark = price;
        require(infl.mintInflation(poolAddress, PoP));
    }

    function setRegistry(address _dragoRegistry) external only_rigoblock_dao {
        dragoRegistry = _dragoRegistry;
    }

    function setRigoblockDao(address _rigoblockDao) external only_rigoblock_dao {
        rigoblockDao = _rigoblockDao;
    }

    function setRigoblockToken(address _rigoblockToken) external only_rigoblock_dao {
        rigoblockToken = _rigoblockToken;
    }

    function setMinimumRigo(uint256 _amount) external only_rigoblock_dao {
        minimumRigo = _amount;
    }

    //! only_rigoblock_dao can set ratio, as it determines the inflation of tokens
    function setRatio(address _ofGroup, uint _ratio)
        public
        only_rigoblock_dao
    {   
        require(_ratio <= 10000); //(from 0 to 10000)
        groups[_ofGroup].rewardRatio = _ratio;
    }

    function isActive(uint _ofPool) public constant returns (bool) {
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        var (a,b,c,d,e,f) = registry.drago(_ofPool);
        if (a != address(0)) {
            return true;
        }
    }

    function addressFromId(uint _ofPool) public constant returns (address pool, address group) {
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        var(a,b,c,d,e,f) = registry.drago(_ofPool);
        return (a,f); //modified to address in order to test calcPoolValue
    }

    function getPoolPrice(uint _ofPool) public constant returns (uint poolPrice, uint totalTokens) {
        var (fund,group) = addressFromId(_ofPool);
        address poolAddress = fund;
        Pool pool = Pool(poolAddress);
        var(a,b,c,d) = pool.getData();
        poolPrice = c;
        /*
        TODO: amend gabcoin/vault interface to make drago compatible
        //uint poolPrice = pool.getPrice();
        //uint256 poolPrice = Pool(ofPool).getPrice();
        */
        totalTokens = pool.totalSupply();
    }
    
    // maybe even return the group here
    // consider retrieving these data from registry and move these functions there
    function getPoolPrices() public constant returns (address[] pools, uint[] poolPrices, uint[] totalTokens) {
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        uint length = registry.dragoCount();
        for (uint i = 0; i < length; ++i) {
            bool active = isActive(i);
            if (!active) {
                 continue;
            }
            var (fund,group) = addressFromId(i);
            pools[i] = fund;
            Pool pool = Pool(fund);
            var(a,b,c,d) = pool.getData();
            poolPrices[i] = c;
            totalTokens[i] = pool.totalSupply();
        }
    }

    function calcPoolValue(uint256 _ofPool) public /*internal*/ constant returns (uint256 aum, bool success) {
        var(price,supply) = getPoolPrice(_ofPool);
        return (aum = price * supply / 1000000, true); //1000000 is the base (decimals)
        //return safeMul(poolPrice, poolTokens); //check whether to divide by a factor in order to prevent overflow
    }

    function calcNetworkValue() public constant returns (uint networkValue, uint numberOfFunds) {
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        uint length = registry.dragoCount();
        for (uint i = 0; i < length; ++i) {
            bool active = isActive(i);
            if (!active) {
                 continue;
            }
            var (m, n) = calcPoolValue(i);
            var pools = m;
            networkValue += pools;
        }
        return (networkValue, length);
    }
    
    function getEpochReward(uint _ofPool) public constant returns (uint) {
        Inflation inflate = Inflation(inflation);
        var (a,group) = addressFromId(_ofPool);
        return inflate.getInflationFactor(group);
    }

    function getRatio(uint _ofPool) public constant returns (uint) {
        var (a,group) = addressFromId(_ofPool);
        return groups[group].rewardRatio;
    }

    //epoch reward should be big enough that it can be decreased if number of funds increases
    //should be at least 10^6, just as pool base to start with
    //rigo token has 10^18 decimals
    function proofOfPerformance(uint _ofPool) public constant returns (uint256) {
        if (poolPrice[_ofPool].highwatermark == 0) {
            poolPrice[_ofPool].highwatermark = 1 ether;
        }
        var (poolValue, y) = calcPoolValue(_ofPool);
        require(poolValue != 0);
        var (newPrice, tokenSupply) = getPoolPrice(_ofPool);
        require (newPrice >= poolPrice[_ofPool].highwatermark);
        var epochReward = getEpochReward(_ofPool);
        var rewardRatio = getRatio(_ofPool);
        var prevPrice = poolPrice[_ofPool].highwatermark;
        uint priceDiff = safeSub(newPrice, prevPrice);
        uint performanceReward = priceDiff * tokenSupply * epochReward * rewardRatio / 10000 ether;
        uint assetsReward = poolValue * epochReward * (10000 - rewardRatio) / 10000 ether;
        return performanceReward + assetsReward;
    }

    function getHwm(uint _ofPool) public constant returns (uint) {
        return poolPrice[_ofPool].highwatermark;
    }

    address public dragoRegistry;
    address public rigoblockToken;
    address public rigoblockDao;
    uint256 public minimumRigo;
    address inflation;
    mapping (uint => PoolPrice) poolPrice;
    mapping (address => Group) groups;
}
