//! Proof-of-Performance algorithm contract.
//! By Gabriele Rigo (RigoBlock, Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.16;

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

	function balanceOf(address _who) constant returns (uint balance) {}
	function totalSupply() constant returns (uint256 totalSupply) {}
	//TODO: the below function is implemented in Gaboins but is aggregated in Dragos
	function getPrice() constant returns (uint256 price) {}
	function getEventful() constant returns (address) {}
	function getData() constant returns (string name, string symbol, uint sellPrice, uint buyPrice) {}
	function getAdminData() constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {}
	function getOwner() constant returns (address) {}
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

contract DragoRegistry {

	//EVENTS

	event Registered(string name, string symbol, uint id, address indexed drago, address indexed owner, address indexed group);
	event Unregistered(string indexed symbol, uint indexed id);
	event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);
	
	// METHODS
        
	function register(address _drago, string _name, string _symbol, uint _dragoID, address _owner) payable returns (bool) {}
	function registerAs(address _drago, string _name, string _symbol, uint _dragoID, address _owner, address _group) payable returns (bool) {}
	function unregister(uint _id) {}
	function setMeta(uint _id, bytes32 _key, bytes32 _value) {}
	function setFee(uint _fee) {}
	function upgrade(address _newAddress) payable {}
	function setUpgraded(uint _version) {}
	function drain() {}
	function kill() {}
	
	function dragoCount() constant returns (uint) {}
	function drago(uint _id) constant returns (address drago, string name, string symbol, uint dragoID, address owner, address group) {}
	// TODO: IMPLEMENT fromId function in registry
	function fromId(uint id) constant returns (address) {}
	function fromAddress(address _drago) constant returns (uint id, string name, string symbol, uint dragoID, address owner, address group) {}
	function fromSymbol(string _symbol) constant returns (uint id, address drago, string name, uint dragoID, address owner, address group) {}
	function fromName(string _name) constant returns (uint id, address drago, string symbol, uint dragoID, address owner, address group) {}
	function fromNameSymbol(string _name, string _symbol) constant returns (address) {}
	function meta(uint _id, bytes32 _key) constant returns (bytes32) {}
	function getGroups(address _group) constant returns (address[]) {}
	function getFee() constant returns (uint) {}
}

contract ProofOfPerformanceFace {

    function setRegistry(address _dragoRegistry) {}
    function setRigoblock(address _rigoblock) {}
    function setMinimumRigo(uint256 _amount) {}
    
    function calcNetworkValue() constant returns (uint256 totalAum) {}
    function calcPoolValue(uint256 _ofPool) internal constant returns (uint256 poolAum) {}
    function proofOfPerformance(uint _ofPool) constant returns (uint256 PoP) {}
    function getPoolAddress(uint _ofPool) public constant returns (address) {}
}

contract ProofOfPerformance is SafeMath, ProofOfPerformanceFace {

    modifier only_minter { RigoTok token = RigoTok(rigoblock);
        assert(msg.sender == token.getMinter());
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
        RigoTok rigoToken = RigoTok(rigoblock);
        assert(minimumRigo <= rigoToken.balanceOf(msg.sender));
        _;
    }
    
    function ProofOfPerformance(address _rigoblock, address _dragoRegistry) {
        rigoblock = _rigoblock;
        dragoRegistry = _dragoRegistry;
    }
    
    function setRegistry(address _dragoRegistry) /*only_rigoblock*/ {
        dragoRegistry = _dragoRegistry;
    }
    
    function setRigoblock(address _rigoblock) /*only_rigoblock*/ {
        rigoblock = _rigoblock;
    }
    
    function calcNetworkValue() constant returns (uint256 totalAum) {
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        for (uint256 i = 0; i < registry.dragoCount(); ++i) {
            calcPoolValue(i);
            //totalAum = safeAdd(calcPoolValue(i));//(poolAUM(i));
        }
    }

    function addressFromId(uint _ofPool) constant returns (address) {
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        var(a,b,c,d,e,f) = registry.drago(_ofPool);//.address[0];
        return a;
    }
    
    function calcPoolValue(uint256 _ofPool) internal constant returns (uint256 poolAum) {
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        address poolAddress = registry.fromId(_ofPool);//.address[0];
        Pool pool = Pool(poolAddress);
        uint poolPrice = pool.getPrice();       //uint256 poolPrice = Pool(ofPool).getPrice();
        uint poolTokens = pool.totalSupply();   //uint256 poolTokens = Pool(ofPool).totalSupply();
        poolAum = safeMul(poolPrice, poolTokens); //check whether to divide by a factor in order to prevent overflow
    }
    
    function proofOfPerformance(uint _ofPool) constant only_pool_owner(_ofPool) minimum_rigoblock returns (uint256 PoP) {
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        var poolValue = calcPoolValue(_ofPool);
        require(poolValue != 0);
        var networkValue = calcNetworkValue();
        RigoTok rigoToken = RigoTok(rigoblock);
        var rigoblockTokens = rigoToken.totalSupply();
        return PoP = (rigoblockTokens * poolValue) / networkValue;  //TODO: double check for overflow
        //mapping of value per user
        //can claim in proportion to participation in excess to what has already been claimed
    }
    
    function getPoolAddress(uint _ofPool) public constant returns (address) {
        DragoRegistry registry = DragoRegistry(dragoRegistry);
        return registry.fromId(_ofPool);
    }
    
    //TODO: mapping of amount paid per fund, in order to only pay the excess not yet paid
    
    function setMinimumRigo(uint256 _amount) /*only_rigoblock*/ {
        minimumRigo = _amount;
    }
    
    address public dragoRegistry;
    address public rigoblock;
    uint256 public totalAum;
    uint256 public minimumRigo;
    uint256 PoP;
}
