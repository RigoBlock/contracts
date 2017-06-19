//! Maker Token Exchange interface
//! Copyright 2017 Gabriele Rigo, RigoBlock (Rigo Investment Sagl)
//! exchange contract from https://github.com/makerdao/maker-otc/blob/master/src/simple_market.sol

pragma solidity ^0.4.8;

import "erc20/erc20.sol";

contract EventfulMarket {
    event ItemUpdate( uint id );
    event Trade( uint sell_how_much, address indexed sell_which_token,
                 uint buy_how_much, address indexed buy_which_token );

    event LogMake(
        bytes32  indexed  id,
        bytes32  indexed  pair,
        address  indexed  maker,
        ERC20             haveToken,
        ERC20             wantToken,
        uint128           haveAmount,
        uint128           wantAmount,
        uint64            timestamp
    );

    event LogBump(
        bytes32  indexed  id,
        bytes32  indexed  pair,
        address  indexed  maker,
        ERC20             haveToken,
        ERC20             wantToken,
        uint128           haveAmount,
        uint128           wantAmount,
        uint64            timestamp
    );

    event LogTake(
        bytes32           id,
        bytes32  indexed  pair,
        address  indexed  maker,
        ERC20             haveToken,
        ERC20             wantToken,
        address  indexed  taker,
        uint128           takeAmount,
        uint128           giveAmount,
        uint64            timestamp
    );

    event LogKill(
        bytes32  indexed  id,
        bytes32  indexed  pair,
        address  indexed  maker,
        ERC20             haveToken,
        ERC20             wantToken,
        uint128           haveAmount,
        uint128           wantAmount,
        uint64            timestamp
    );
}

contract SimpleMarket is EventfulMarket {
    
    function isActive(uint id) constant returns (bool active) {}
    function getOwner(uint id) constant returns (address owner) {}
    function getOffer( uint id ) constant returns (uint, ERC20, uint, ERC20) {}

    function make(ERC20 haveToken, ERC20 wantToken, uint128 haveAmount, uint128 wantAmount) returns (bytes32 id) {}
    function take(bytes32 id, uint128 maxTakeAmount) {}
    function kill(bytes32 id) {}
    function offer(uint sell_how_much, ERC20 sell_which_token, uint buy_how_much, ERC20 buy_which_token) returns (uint id) {}
    function bump(bytes32 id_) {}
    function buy(uint id, uint quantity) returns (bool success) {}
    function cancel(uint id) returns (bool success) {}
}
