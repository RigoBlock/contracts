//! Gabcoin Factory contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.11;

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
	function fromAddress(address _drago) constant returns (uint id, string name, string symbol, uint dragoID, address owner, address group) {}
	function fromSymbol(string _symbol) constant returns (uint id, address drago, string name, uint dragoID, address owner, address group) {}
	function fromName(string _name) constant returns (uint id, address drago, string symbol, uint dragoID, address owner, address group) {}
	function fromNameSymbol(string _name, string _symbol) constant returns (address) {}
	function meta(uint _id, bytes32 _key) constant returns (bytes32) {}
	function getGroups(address _group) constant returns (address[]) {}
	function getFee() constant returns (uint) {}
}

contract GabcoinFactoryFace {

	event GabcoinCreated(string _name, address _gabcoin, address _owner, uint _gabcoinID);

	function createGabcoin(string _name, string _symbol, address _owner) returns (address gabcoin, uint gabcoinID) {}
	function setTargetGabcoinDAO(address _targetGabcoin, address _gabcoinDAO) {}
	function changeGabcoinDAO(address _newGabcoinDAO) {}
	function setRegistry(address _newRegistry) {}
	function setBeneficiary(address _gabcoinDAO) {}
	function setFee(uint _fee) {}
	function drain() {}

    function getRegistry() constant returns (address) {}
	function getStorage() constant returns (address gabcoinDAO, string version, uint nextGabcoinID) {}
	function getNextID() constant returns (uint nextGabcoinID) {}
	function getEventful() constant returns (address) {}
	function getGabcoinDAO() constant returns (address gabcoinDAO) {}
	function getVersion() constant returns (string) {}
	function getGabcoinsByAddress(address _owner) constant returns (address[]) {}
}

library GabcoinFactoryLibrary {

    struct NewGabcoin {
	    string name;
	    string symbol;
	    uint256 gabcoinID;
	    address owner;
	    address newAddress;
	}

    modifier whitelisted_factory { Authority auth = Authority(0xDFF383e12A7939779359bf6A7f8766E123a18452); if (auth.isWhitelistedFactory(this)) _; }

	function createGabcoin(NewGabcoin storage self, string _name, string _symbol, address _owner, uint _gabcoinID, address _authority) whitelisted_factory returns (bool success) {
	    Gabcoin gabcoin = new Gabcoin(_name, _symbol, _gabcoinID, _owner, _authority);
	    self.name = _name;
	    self.symbol = _symbol;
	    self.gabcoinID = _gabcoinID;
	    self.newAddress = address(gabcoin);
	    self.owner = _owner;
	    return true;
	}
}

contract GabcoinFactory is Owned, GabcoinFactoryFace {
    
    struct Data {
	    uint fee;
	    address gabcoinRegistry;
	    address gabcoinDAO;
	    address authority;
	    mapping(address => address[]) gabcoins;
	}
	
	event GabcoinCreated(string name, string symbol, address indexed gabcoin, address indexed owner, uint gabcoinID);

	modifier when_fee_paid { if (msg.value < data.fee) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	modifier only_gabcoin_dao { if (msg.sender != data.gabcoinDAO) return; _; }
    modifier whitelisted_factory { Authority auth = Authority(0xDFF383e12A7939779359bf6A7f8766E123a18452); if (auth.isWhitelistedFactory(this)) _; }

	function GabcoinFactory(address _registry, address _gabcoinDAO, address _authority) {
	    data.gabcoinRegistry = _registry;
	    data.gabcoinDAO = _gabcoinDAO;
	    data.authority = _authority;
	    //REMEMBER TO SET FACTORY AS WHITELISTER WHEN CREATE A NEW ONE
	    //SO THAT IT CAN WHITELIST MSG.SENDER AND GABCOIN IMMEDIATELY
	}
	
	function createGabcoin(string _name, string _symbol) returns (bool success) {
        DragoRegistry registry = DragoRegistry(data.gabcoinRegistry);
        uint regFee = registry.getFee();
        uint gabcoinID = registry.dragoCount();
        if (!createGabcoinInternal(_name, _symbol, msg.sender, gabcoinID)) return;
        assert(registry.register.value(regFee)(libraryData.newAddress, _name, _symbol, gabcoinID, msg.sender));
        return true;
    }
    
    function createGabcoinInternal(string _name, string _symbol, address _owner, uint _gabcoinID) internal when_fee_paid returns (bool success) {
	    Authority auth = Authority(data.authority);
	    require(GabcoinFactoryLibrary.createGabcoin(libraryData, _name, _symbol, _owner, _gabcoinID, data.authority));
		data.gabcoins[msg.sender].push(libraryData.newAddress);
		GabcoinEventful events = GabcoinEventful(getEventful());
		if (!events.createGabcoin(msg.sender, this, libraryData.newAddress, _name, _symbol, _gabcoinID, _owner)) return;
		auth.whitelistGabcoin(libraryData.newAddress, true);
		auth.whitelistUser(msg.sender, true);
		GabcoinCreated(_name, _symbol, libraryData.newAddress, _owner, _gabcoinID); //already mapping global events in library
		return true;
	}

    function setTargetGabcoinDAO(address _targetGabcoin, address _gabcoinDAO) only_owner {
		Gabcoin gabcoin = Gabcoin(_targetGabcoin);
		gabcoin.changeGabcoinDAO(_gabcoinDAO);
	}
	
	function changeGabcoinDAO(address _newGabcoinDAO) only_gabcoin_dao {
	    data.gabcoinDAO = _newGabcoinDAO;
	}
	
	function setRegistry(address _newRegistry) only_owner {
		data.gabcoinRegistry = _newRegistry;
	}
    
	function setBeneficiary(address _gabcoinDAO) only_owner {
		data.gabcoinDAO = _gabcoinDAO;
	}
	
	function setFee(uint _fee) only_owner {
		data.fee = _fee;
	}

	function drain() only_owner {
		if (!data.gabcoinDAO.call.value(this.balance)()) throw;
	}

	function getRegistry() constant returns (address) {
	    return (data.gabcoinRegistry);
	}
	
	function getStorage() constant returns (address gabcoinDAO, string version, uint nextGabcoinID) {
	    return (data.gabcoinDAO, version, nextGabcoinID);
	}
	
	function getNextID() constant returns (uint nextGabcoinID) {
	    DragoRegistry registry = DragoRegistry(data.gabcoinRegistry);
	    nextGabcoinID = registry.dragoCount(); //we use the global gabcoin registry
	}
	
	function getEventful() constant returns (address) {
	    Authority auth = Authority(data.authority);
	    return auth.getEventful();
	}
	
	function getGabcoinDAO() constant returns (address) {
	    return data.gabcoinDAO;
	}
	
	function getVersion() constant returns (string) {
	    return version;
	}
	
	function getGabcoinsByAddress(address _owner) constant returns (address[]) {
	    return data.gabcoins[msg.sender];
	}
	
	GabcoinFactoryLibrary.NewGabcoin libraryData;

	Data data;

	string public version = 'GC 1.1.0';
	address public owner = msg.sender;
}
