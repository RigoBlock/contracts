contract DragoFactory is Owned, DragoFactoryFace {
 
	struct Data {
	    uint fee;
	    address dragoRegistry;
	    address dragoDAO;
	    mapping(address => address[]) dragos;
	}

	event DragoCreated(string name, string symbol, address indexed drago, address indexed owner, uint dragoID);

	modifier when_fee_paid { if (msg.value < data.fee) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
    
	function DragoFactory(address _registry, address _dragoDAO) {
	    setRegistry(_registry);
	    data.dragoDAO = _dragoDAO;
	}

    function createDrago(string _name, string _symbol) returns (bool success) {
        uint dragoID = registry.dragoCount();
        if (!createDragoInternal(_name, _symbol, msg.sender, dragoID)) return;
        assert(registry.register(myNewDrago.newAddress, myNewDrago.name, myNewDrago.symbol, myNewDrago.dragoID, myNewDrago.owner));
        return true;
    }

	function createDragoInternal(string _name, string _symbol, address _owner, uint _dragoID) internal when_fee_paid returns (bool success) {
		require(myNewDrago.createDrago(_name, _symbol, _owner, _dragoID));
		data.dragos[msg.sender].push(myNewDrago.newAddress);
		DragoCreated(myNewDrago.name, myNewDrago.symbol, myNewDrago.newAddress, myNewDrago.owner, myNewDrago.dragoID);
	}
	
	function setRegistry(address _newRegistry) only_owner {
		data.dragoRegistry = _newRegistry;
	}
    
	function setBeneficiary(address _dragoDAO) only_owner {
		data.dragoDAO = _dragoDAO;
	}
	
	function setFee(uint _fee) only_owner {
		data.fee = _fee;
	}

	function drain() only_owner {
		if (!data.dragoDAO.send(this.balance)) throw;
	}

	function getRegistry() constant returns (address) {
	    return (data.dragoRegistry);
	}
	
	function getStorage() constant returns (address dragoDAO, string version, uint nextDragoID) {
	    return (data.dragoDAO, version, nextDragoID);
	}
	
	function getNextID() constant returns (uint nextDragoID) {
	    nextDragoID = registry.dragoCount();
	}
	
	function getDragoDAO() constant returns (address dragoDAO) {
	    return data.dragoDAO;
	}
	
	function getVersion() constant returns (string version) {
	    return version;
	}
	
	function getDragosByAddress(address _owner) constant returns (address[]) {
	    return data.dragos[msg.sender];
	}
	
	using DragoFactoryLibrary for DragoFactoryLibrary.NewDrago;
	DragoFactoryLibrary.NewDrago myNewDrago;

    Data data;
    DragoRegistry registry = DragoRegistry(data.dragoRegistry);
	
	string public version = 'DF0.3';
}
