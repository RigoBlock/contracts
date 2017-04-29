//! Authority contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Auth has the possibility of blocking/unblocking single user.

pragma solidity ^0.4.10;

contract AuthorityFace {

    // EVENTS
  
    event SetAuthority (address indexed authority);
    event SetWhitelister (address indexed whitelister);
    event WhitelistedUser(address indexed target, bool approved);
    event WhitelistedAsset(address indexed asset, bool approved);
    event WhitelistedExchange(address indexed exchange, bool approved);
    event WhitelistedRegistry(address indexed registry, bool approved);
    
    // METHODS
  
    function setAuthority(address _authority) {}
    function setWhitelister(address _whitelister) {}
    function whitelistUser(address _target, bool _isWhitelisted) {}
    function whitelistAsset(address _asset, bool _isWhitelisted) {}
    function whitelistExchange(address _exchange, bool _isWhitelisted) {}
    function whitelistRegistry(address _registry, bool _isWhitelisted) {}
  
    function isWhitelistedUser(address _target) constant returns (bool) {}
    function isWhitelistedAsset(address _asset) constant returns (bool) {}
    function isWhitelistedExchange(address _exchange) constant returns (bool) {}
    function isWhitelistedRegistry(address _registry) constant returns (bool) {}
    function isWhitelistedDrago(address _drago) constant returns (bool) {}
    function getOwner() constant returns (address) {}
    function getAuth() constant returns (address) {}
    function getWhitelisters() constant returns (address[]) {}
}

contract Authority is Owned, AuthorityFace {	

    event SetAuthority (address indexed authority);
    event SetWhitelister (address indexed whitelister);
    event WhitelistedUser(address indexed target, bool approved);
    event WhitelistedAsset(address indexed asset, bool approved);
    event WhitelistedExchange(address indexed exchange, bool approved);
    event WhitelistedRegistry(address indexed registry, bool approved);
   		
    //modifier only_auth { assert(isAuthorized(msg.sender, msg.sig)); _; }		
    modifier only_whitelister { if (!whitelistAdmins[msg.sender]) throw; _; }		
    modifier only_admin { if (msg.sender != owner && !whitelistAdmins[msg.sender]) throw; _; }		
    modifier only_whitelisted { if (!accounts[msg.sender].authorized) throw; _; }		
	
    function setAuthority(address _authority) only_owner {		
      authority = _authority;		
      SetAuthority(authority);		
    }		

    function setWhitelister(address _whitelister) only_admin {		
      whitelistAdmins[whitelister] = _whitelister;		
    }		
		
    function whitelistUser(address _target, bool _isWhitelisted) only_whitelister {		
      accounts[_target].authorized = _isWhitelisted;		
      WhitelistedUser(_target, _isWhitelisted);		
    }
    
    function whitelistAsset(address _asset, bool _isWhitelisted) only_whitelister {
      accounts[_asset].authorized = _isWhitelisted;		
      WhitelistedUser(_asset, _isWhitelisted);
    }
    
    function whitelistExchange(address _exchange, bool _isWhitelisted) only_whitelister {
      accounts[_exchange].authorized = _isWhitelisted;		
      WhitelistedExchange(_target, _isWhitelisted);
    }
    
    function whitelistDrago(address _drago, bool _isWhitelisted) only_whitelister {
      accounts[_drago].authorized = _isWhitelisted;		
      WhitelistedDrago(_drago, _isWhitelisted);
    }
    
    function whitelistRegistry(address _registry, bool _isWhitelisted) only_whitelister {
      accounts[_registry].authorized = _isWhitelisted;		
      WhitelistedRegistry(_target, _isWhitelisted);
    }
		
    function isWhitelistedUser(address _target) constant returns (bool) {
      return accounts[_target].authorized;
    }
    
    function isWhitelistedAsset(address _asset) constant returns (bool) {
      return accounts[_asset].authorized;
    }	
    
    function isWhitelistedExchange(address _exchange) constant returns (bool) {
      return accounts[_exchange].authorized;
    }	
    
    function isWhitelistedDrago(address _drago) constant returns (bool) {
      return accounts[_dragoy].authorized;
    }	
    
    function isWhitelistedRegistry(address _registry) constant returns (bool) {
      return accounts[_registry].authorized;
    }	
	
    address public owner = msg.sender;		
    address public authority = msg.sender;		
    address[] public whitelister = msg.sender;		
    mapping (address => bool) public approvedAccount;
    mapping (address => bool) public approvedAsset;
    mapping (address => bool) public approvedExchange;
    mapping (address => bool) public approvedDrago;
    mapping (address => bool) public approvedRegistry;
}
