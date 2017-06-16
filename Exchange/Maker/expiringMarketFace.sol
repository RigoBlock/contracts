pragma solidity ^0.4.8;

import "ds-auth/auth.sol";

import "./simple_market.sol";

// Simple Market with a market lifetime. When the lifetime has elapsed,
// offers can only be cancelled (offer and buy will throw).

contract ExpiringMarket is DSAuth, SimpleMarket {

    function stop() auth {}

    function getTime() constant returns (uint) {}
    function isClosed() constant returns (bool closed) {}
}
