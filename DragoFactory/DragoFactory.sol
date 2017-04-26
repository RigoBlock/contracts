//! DragoFactory contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

import "github.com/RigoBlock/contracts/Drago/Drago.sol";

contract DragoRegistry {

	//EVENTS

	event Registered(string indexed symbol, uint indexed id, address drago, string name);
	event Unregistered(string indexed symbol, uint indexed id);
	event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);
	
	// METHODS
        
	function register(address _drago, uint _dragoID) {}	
	function register(address _drago, string _symbol, uint _base, string _name) payable returns (bool) {}
	function unregister(uint _id) {}
	function setMeta(uint _id, bytes32 _key, bytes32 _value) {}
	function setFee(uint _fee) {}
	function drain() {}
	
	function accountOf(uint _dragoID) constant returns (address) {}   
	function dragoOf(address _drago) constant returns (uint) {}
	function dragoCount() constant returns (uint) {}
	function drago(uint _id) constant returns (address drago, string symbol, uint base, string name, address owner) {}
	function fromAddress(address _drago) constant returns (uint id, string symbol, uint base, string name, address owner) {}
	function fromSymbol(string _symbol) constant returns (uint id, address drago, uint base, string name, address owner) {}
	function fromName(string _name) constant returns (uint id, string symbol, address drago, uint base, address owner) {}
	function meta(uint _id, bytes32 _key) constant returns (bytes32) {}
}

contract DragoFactoryFace {

	event DragoCreated(string _name, address _drago, address _dragowner, uint _dragoID);

	function createDrago(string _name, string _symbol, address _dragowner) returns (address _drago, uint _dragoID) {}
	function setFee(uint _fee) {}
	function setBeneficiary(address _dragoDAO) {}
	function drain() {}
	function() {}
	function changeRatio(address targetDrago, uint256 _ratio) {}
	function setTransactionFee(address targetDrago, uint _transactionFee) {}
	function changeFeeCollector(address targetDrago, address _feeCollector) {}
	function changeDragator(address targetDrago, address _dragator) {}

	function getVersion() constant returns (string) {}
	function getLastId() constant returns (uint) {}
	function getDragoDAO() constant returns (uint) {}
}

contract DragoFactory is Owned, DragoFactoryFace {
    
	modifier when_fee_paid { if (msg.value < fee) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	//modifier only_drago_dao  if (msg.sender != dragoDao) return; _; }
	
	event DragoCreated(string _name, address _drago, address _dragowner, uint _dragoID);
	//event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	//event Sell(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);

	function DragoFactory () {}
    
	function createDrago(string _name, string _symbol, address _owner) when_fee_paid returns (address _drago, uint _dragoID) {
		//can be amended to set owner as per input
		Drago newDrago = (new Drago(_name, _symbol)); //Drago newDrago = (new Drago(_name, _symbol, _dragowner));
		newDragos.push(address(newDrago));
		created[msg.sender].push(address(newDrago));
		newDrago.setOwner(msg.sender);  //library or new.tranfer(_from)
		_dragoID = nextDragoID;     //decided at last to add sequential ID numbers
		++nextDragoID;              //decided at last to add sequential ID numbers
		registerDrago(_drago, _dragoID, _dragoRegistry);
		DragoCreated(_name, address(newDrago), msg.sender, uint(newDrago));
		return (address(newDrago), uint(newDrago));
	}
	
	function registerDrago(address _drago, uint _dragoID, address _dragoRegistry) internal only_owner {
		DragoRegistry registry = DragoRegistry(_dragoRegistry); //define address
		registry.register(_drago, _dragoID);
	}
    
	function setFee(uint _fee) only_owner {    //exmple, uint public fee = 100 finney;
		fee = _fee;
	}
	
	function changeRegistry(address _newRegistry) only_owner {
		_dragoRegistry = _newRegistry;
		//NewRegistry(_dragoRegistry, _newRegistry);
	}
    
	function setBeneficiary(address _dragoDAO) only_owner {
		dragoDAO = _dragoDAO;
	}

	function drain() only_owner {
		if (!dragoDAO.send(this.balance)) throw;
	}
    
	function() {
		throw;
	}
	
	string public version = 'DF0.2';
	uint _dragoID = 0;
	uint public fee = 0;
	uint public nextDragoID;
	address public dragoDAO = msg.sender;
	address[] public newDragos;
	address _dragoRegistry;
	address public owner = msg.sender;
	mapping(address => address[]) public created;
}
