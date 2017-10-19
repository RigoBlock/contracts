//! Authority Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! Auth has the possibility of blocking/unblocking single user.

pragma solidity ^0.4.18;

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
