//! Authority contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Auth has the possibility of blocking/unblocking single user.

pragma solidity ^0.4.10;

contract Owned {
    
	modifier only_owner { if (msg.sender != owner) return; _; }

	event NewOwner(address indexed old, address indexed current);
   
	function setOwner(address _new) only_owner {
		owner = _new;
		NewOwner(owner, _new);
	}
	
	function getOwner() constant returns (address) {
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

    // METHODS

    function setAuthority(address _authority, bool _isWhitelisted) {}
    function setWhitelister(address _whitelister, bool _isWhitelisted) {}
    function whitelistUser(address _target, bool _isWhitelisted) {}
    function whitelistAsset(address _asset, bool _isWhitelisted) {}
    function whitelistExchange(address _exchange, bool _isWhitelisted) {}
    function whitelistDrago(address _drago, bool _isWhitelisted) {}
    function whitelistRegistry(address _registry, bool _isWhitelisted) {}
    function whitelistFactory(address _factory, bool _isWhitelisted) {}
    function setEventful(address _eventful) {}

    function isWhitelistedUser(address _target) constant returns (bool) {}
    function isWhitelister(address _whitelister) constant returns (bool) {}
    function isAuthority(address _authority) constant returns (bool) {}
    function isWhitelistedAsset(address _asset) constant returns (bool) {}
    function isWhitelistedExchange(address _exchange) constant returns (bool) {}
    function isWhitelistedRegistry(address _registry) constant returns (bool) {}
    function isWhitelistedDrago(address _drago) constant returns (bool) {} 
    function isWhitelistedFactory(address _factory) constant returns (bool) {}
    function getEventful() constant returns (address) {}
    function getOwner() constant returns (address) {}
}

contract Authority is Owned, AuthorityFace {
    
    struct Group {
		bool whitelister;
		bool exchange;
		bool drago;
		bool asset;
		bool user;
		bool registry;
		bool authority;
	}
	
	struct Account {
	    address account;
		bool authorized;
		mapping (address => Group) groups;
	}
	
	struct Eventful {
	    address eventful;
	}

    event SetAuthority (address indexed authority);
    event SetWhitelister (address indexed whitelister);
    event WhitelistedUser(address indexed target, bool approved);
    event WhitelistedAsset(address indexed asset, bool approved);
    event WhitelistedExchange(address indexed exchange, bool approved);
    event WhitelistedDrago(address indexed drago, bool isWhitelisted);
    event WhitelistedRegistry(address indexed registry, bool approved);
    event NewEventful(address indexed old, address indexed eventful);
   		
    modifier only_whitelister { if (!accounts[msg.sender].groups[msg.sender].whitelister) return; _; }
    modifier only_authority { if (!accounts[msg.sender].groups[msg.sender].authority) return; _; }
    modifier only_admin { if (msg.sender != owner || !accounts[msg.sender].groups[msg.sender].whitelister) return; _; }
	
    function setAuthority(address _authority, bool _isWhitelisted) only_owner {		
        accounts[_authority].account = _authority;
        accounts[_authority].authorized = _isWhitelisted;
        accounts[_authority].groups[_authority].authority = _isWhitelisted;
        SetAuthority(_authority);
    }

    function setWhitelister(address _whitelister, bool _isWhitelisted) only_owner {
        accounts[_whitelister].account = _whitelister;
        accounts[_whitelister].authorized = _isWhitelisted;
        accounts[_whitelister].groups[_whitelister].whitelister = _isWhitelisted;
        SetWhitelister(_whitelister);
    }
	
    function whitelistUser(address _target, bool _isWhitelisted) only_whitelister {
        accounts[_target].account = _target;
        accounts[_target].authorized = _isWhitelisted;
        accounts[_target].groups[_target].user = _isWhitelisted;
        WhitelistedUser(_target, _isWhitelisted);
    }
    
    function whitelistAsset(address _asset, bool _isWhitelisted) only_whitelister {
        accounts[_asset].account = _asset;
        accounts[_asset].authorized = _isWhitelisted;
        accounts[_asset].groups[_asset].asset = _isWhitelisted;
        WhitelistedAsset(_asset, _isWhitelisted);
    }
    
    function whitelistExchange(address _exchange, bool _isWhitelisted) only_whitelister {
        accounts[_exchange].account = _exchange;
        accounts[_exchange].authorized = _isWhitelisted;
        accounts[_exchange].groups[_exchange].exchange = _isWhitelisted;
        WhitelistedExchange(_exchange, _isWhitelisted);
    }
    
    function whitelistDrago(address _drago, bool _isWhitelisted) only_admin {
        accounts[_drago].account = _drago;
        accounts[_drago].authorized = _isWhitelisted;
        accounts[_drago].groups[_drago].drago = _isWhitelisted;
        WhitelistedDrago(_drago, _isWhitelisted);
    }
    
    function whitelistRegistry(address _registry, bool _isWhitelisted) only_admin {
        accounts[_registry].account = _registry;
        accounts[_registry].authorized = _isWhitelisted;
        accounts[_registry].groups[_registry].registry = _isWhitelisted;		
        WhitelistedRegistry(_registry, _isWhitelisted);
    }
    
    function setEventful(address _eventful) only_owner {
		events.eventful = _eventful;
		NewEventful(events.eventful, _eventful);
	}

    function isWhitelistedUser(address _target) constant returns (bool) {
        return accounts[_target].groups[_target].user;
    }
    
    function isWhitelister(address _whitelister) constant returns (bool) {
        return accounts[_whitelister].groups[_whitelister].whitelister;
    }
    
    function isAuthority(address _authority) constant returns (bool) {
        return accounts[_authority].groups[_authority].authority;
    }
    
    function isWhitelistedAsset(address _asset) constant returns (bool) {
        return accounts[_asset].groups[_asset].asset;
    }	
    
    function isWhitelistedExchange(address _exchange) constant returns (bool) {
        return accounts[_exchange].groups[_exchange].exchange;
    }	
    
    function isWhitelistedDrago(address _drago) constant returns (bool) {
        return accounts[_drago].groups[_drago].drago;
    }	
    
    function isWhitelistedRegistry(address _registry) constant returns (bool) {
        return accounts[_registry].groups[_registry].registry;
    }
    
    function getEventful() constant returns (address) {
	    return events.eventful;
	}
    
    Eventful events;
    
    mapping (address => Account) accounts;
}
