//! Authority contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Auth has the possibility of blocking/unblocking single user, drago, gabcoin, factory.

pragma solidity ^0.4.18;

contract Owned {

	modifier only_owner { require(msg.sender == owner); _; }

	event NewOwner(address indexed old, address indexed current);
   
	function setOwner(address _new) public only_owner {
		owner = _new;
		NewOwner(owner, _new);
	}

	function getOwner() public constant returns (address) {
	    return owner;
	}

	address public owner = msg.sender;
}

contract AuthorityFace {

    // EVENTS

    event SetAuthority (address indexed authority);
    event SetWhitelister (address indexed whitelister);
    event SetEventful(address indexed eventful);
    event WhitelistedUser(address indexed target, bool approved);
    event WhitelistedAsset(address indexed asset, bool approved);
    event WhitelistedExchange(address indexed exchange, bool approved);
    event WhitelistedRegistry(address indexed registry, bool approved);
    event WhitelistedFactory(address indexed factory, bool approved);
    event WhitelistedGabcoin(address indexed gabcoin, bool approved);
    event WhitelistedDrago(address indexed drago, bool approved);
    event NewEventful(address indexed eventful);

    // METHODS

    function setAuthority(address _authority, bool _isWhitelisted) public {}
    function setWhitelister(address _whitelister, bool _isWhitelisted) public {}
    function whitelistUser(address _target, bool _isWhitelisted) public {}
    function whitelistAsset(address _asset, bool _isWhitelisted) public {}
    function whitelistExchange(address _exchange, bool _isWhitelisted) public {}
    function whitelistDrago(address _drago, bool _isWhitelisted) public {}
    function whitelistGabcoin(address _gabcoin, bool _isWhitelisted) public {}
    function whitelistRegistry(address _registry, bool _isWhitelisted) public {}
    function whitelistFactory(address _factory, bool _isWhitelisted) public {}
    function setEventful(address _eventful) public {}
    function setGabcoinEventful(address _gabcoinEventful) public {}
    function setExchangeEventful(address _exchangeEventful) public {}
    function setCasper(address _casper) public {}

    function isWhitelistedUser(address _target) public constant returns (bool) {}
    function isWhitelister(address _whitelister) public constant returns (bool) {}
    function isAuthority(address _authority) public constant returns (bool) {}
    function isWhitelistedAsset(address _asset) public constant returns (bool) {}
    function isWhitelistedExchange(address _exchange) public constant returns (bool) {}
    function isWhitelistedRegistry(address _registry) public constant returns (bool) {}
    function isWhitelistedDrago(address _drago) public constant returns (bool) {}
    function isWhitelistedGabcoin(address _gabcoin) public constant returns (bool) {} 
    function isWhitelistedFactory(address _factory) public constant returns (bool) {}
    function getEventful() public constant returns (address) {}
    function getGabcoinEventful() public constant returns (address) {}
    function getExchangeEventful() public constant returns (address) {}
    function getCasper() public constant returns (address) {}
    function getOwner() public constant returns (address) {}
    function getListsByGroups(string _group) public constant returns (address[]) {}
}

contract Authority is Owned, AuthorityFace {
    
    struct List {
        address target;
    }

    struct Type {
        string types;
        mapping (string=> address[]) mapFromGroup;
        List[] list;
    }
    
    struct Group {
		bool whitelister;
		bool exchange;
		bool drago;
		bool gabcoin;
		bool asset;
		bool user;
		bool registry;
		bool factory;
		bool authority;
	}
	
	struct Account {
	    address account;
		bool authorized;
		mapping (bool => Group) groups; //mapping account to bool authorized to bool group
	}
	
	struct BuildingBlocks {
	    address eventful;
	    address gabcoinEventful;
	    address exchangeEventful;
	    address casper;
	}

    event SetAuthority (address indexed authority);
    event SetWhitelister (address indexed whitelister);
    event WhitelistedUser(address indexed target, bool approved);
    event WhitelistedAsset(address indexed asset, bool approved);
    event WhitelistedExchange(address indexed exchange, bool approved);
    event WhitelistedDrago(address indexed drago, bool isWhitelisted);
    event WhitelistedRegistry(address indexed registry, bool approved);
    event NewEventful(address indexed eventful);
    event NewGabcoinEventful(address indexed exchangeEventful);
    event NewExchangeEventful(address indexed gabcoinEventful);
    event NewCasper(address indexed casper);

    modifier only_whitelister { if (isWhitelister(msg.sender)) _; }
    modifier only_authority { if (isAuthority(msg.sender)) _; }
    modifier only_admin { if (msg.sender == owner || isWhitelister(msg.sender)) _; }
	
    function setAuthority(address _authority, bool _isWhitelisted) public only_owner {		
        accounts[_authority].account = _authority;
        accounts[_authority].authorized = _isWhitelisted;
        accounts[_authority].groups[_isWhitelisted].authority = _isWhitelisted;
	//TODO: test setting authority as whitelister as per following function:
	// setWhitelister(_authority, _isWhitelisted);
        types.list.push(List(_authority));
        SetAuthority(_authority);
    }

    function setWhitelister(address _whitelister, bool _isWhitelisted) public only_owner {
        accounts[_whitelister].account = _whitelister;
        accounts[_whitelister].authorized = _isWhitelisted;
        accounts[_whitelister].groups[_isWhitelisted].whitelister = _isWhitelisted;
        types.list.push(List(_whitelister));
        SetWhitelister(_whitelister);
    }

    function whitelistUser(address _target, bool _isWhitelisted) public only_whitelister {
        accounts[_target].account = _target;
        accounts[_target].authorized = _isWhitelisted;
        accounts[_target].groups[_isWhitelisted].user = _isWhitelisted;
        types.list.push(List(_target));
        WhitelistedUser(_target, _isWhitelisted);
    }

    function whitelistAsset(address _asset, bool _isWhitelisted) public only_whitelister {
        accounts[_asset].account = _asset;
        accounts[_asset].authorized = _isWhitelisted;
        accounts[_asset].groups[_isWhitelisted].asset = _isWhitelisted;
        types.list.push(List(_asset));
        WhitelistedAsset(_asset, _isWhitelisted);
    }
    
    function whitelistExchange(address _exchange, bool _isWhitelisted) public only_whitelister {
        accounts[_exchange].account = _exchange;
        accounts[_exchange].authorized = _isWhitelisted;
        accounts[_exchange].groups[_isWhitelisted].exchange = _isWhitelisted;
        types.list.push(List(_exchange));
        WhitelistedExchange(_exchange, _isWhitelisted);
    }
    
    function whitelistDrago(address _drago, bool _isWhitelisted) public only_admin {
        accounts[_drago].account = _drago;
        accounts[_drago].authorized = _isWhitelisted;
        accounts[_drago].groups[_isWhitelisted].drago = _isWhitelisted;
        types.list.push(List(_drago));
        WhitelistedDrago(_drago, _isWhitelisted);
    }
    
    function whitelistGabcoin(address _gabcoin, bool _isWhitelisted) public only_admin {
        accounts[_gabcoin].account = _gabcoin;
        accounts[_gabcoin].authorized = _isWhitelisted;
        accounts[_gabcoin].groups[_isWhitelisted].gabcoin = _isWhitelisted;
        types.list.push(List(_gabcoin));
        WhitelistedDrago(_gabcoin, _isWhitelisted);
    }
    
    function whitelistRegistry(address _registry, bool _isWhitelisted) public only_admin {
        accounts[_registry].account = _registry;
        accounts[_registry].authorized = _isWhitelisted;
        accounts[_registry].groups[_isWhitelisted].registry = _isWhitelisted;
        types.list.push(List(_registry));
        WhitelistedRegistry(_registry, _isWhitelisted);
    }

    function whitelistFactory(address _factory, bool _isWhitelisted) public only_admin {
        accounts[_factory].account = _factory;
        accounts[_factory].authorized = _isWhitelisted;
        accounts[_factory].groups[_isWhitelisted].registry = _isWhitelisted;
        types.list.push(List(_factory));
        WhitelistedFactory(_factory, _isWhitelisted);
    }
    
    function setEventful(address _eventful) public only_owner {
		blocks.eventful = _eventful;
		NewEventful(blocks.eventful);
	}
	
	function setGabcoinEventful(address _gabcoinEventful) public only_owner {
		blocks.gabcoinEventful = _gabcoinEventful;
		NewGabcoinEventful(blocks.gabcoinEventful);
	}
	
	function setExchangeEventful(address _exchangeEventful) public only_owner {
		blocks.exchangeEventful = _exchangeEventful;
		NewExchangeEventful(blocks.exchangeEventful);
	}
	
	function setCasper(address _casper) public only_owner {
		blocks.casper = _casper;
		NewCasper(blocks.casper);
	}

    function isWhitelistedUser(address _target) public constant returns (bool) {
        return accounts[_target].groups[true].user;
    }
    
    function isWhitelister(address _whitelister) public constant returns (bool) {
        return accounts[_whitelister].groups[true].whitelister;
    }
    
    function isAuthority(address _authority) public constant returns (bool) {
        return accounts[_authority].groups[true].authority;
    }
    
    function isWhitelistedAsset(address _asset) public constant returns (bool) {
        return accounts[_asset].groups[true].asset;
    }	
    
    function isWhitelistedExchange(address _exchange) public constant returns (bool) {
        return accounts[_exchange].groups[true].exchange;
    }	
    
    function isWhitelistedDrago(address _drago) public constant returns (bool) {
        return accounts[_drago].groups[true].drago;
    }	
    
    function isWhitelistedGabcoin(address _gabcoin) public constant returns (bool) {
        return accounts[_gabcoin].groups[true].gabcoin;
    } 

    function isWhitelistedRegistry(address _registry) public constant returns (bool) {
        return accounts[_registry].groups[true].registry;
    }
    
    function isWhitelistedFactory(address _factory) public constant returns (bool) {
        return accounts[_factory].groups[true].registry;
    }

    function getEventful() public constant returns (address) {
	    return blocks.eventful;
	}
    
    function getGabcoinEventful() public constant returns (address) {
        return blocks.gabcoinEventful;
    }
    
    function getExchangeEventful() public constant returns (address) {
        return blocks.exchangeEventful;
    }
    
    function getCasper() public constant returns (address) {
        return blocks.casper;
    }
    
    function getListsByGroups(string _group) public constant returns (address[]) {
        return types.mapFromGroup[_group];
    }

    BuildingBlocks blocks;
    Type types;

    mapping (address => Account) accounts;
}
