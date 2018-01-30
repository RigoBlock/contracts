//! The Oasis-Direct Adapter contract.
//!
//! Copyright 2017-2018 Gabriele Rigo, RigoBlock, Rigo Investment Sagl.
//!
//! Licensed under the Apache License, Version 2.0 (the "License");
//! you may not use this file except in compliance with the License.
//! You may obtain a copy of the License at
//!
//!     http://www.apache.org/licenses/LICENSE-2.0
//!
//! Unless required by applicable law or agreed to in writing, software
//! distributed under the License is distributed on an "AS IS" BASIS,
//! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//! See the License for the specific language governing permissions and
//! limitations under the License.
//!
//! This code may be distributed under the terms of the Apache Licence
//! version 2.0 (see above) or the MIT-license, at your choice.


pragma solidity 0.4.19;

contract OtcInterface {
    function sellAllAmount(address, uint, address, uint) public returns (uint);
    function buyAllAmount(address, uint, address, uint) public returns (uint);
}

contract TokenInterface {
    function approve(address, uint) public;
    function transfer(address,uint) public returns (bool);
    function transferFrom(address, address, uint) public returns (bool);
    function deposit() public payable;
    function withdraw(uint) public;
}

contract Exchange {
    function sellAllAmount(OtcInterface otc, TokenInterface payToken, uint payAmt, TokenInterface buyToken, uint minBuyAmt) public returns (uint buyAmt) {}
    function sellAllAmountPayEth(OtcInterface otc, TokenInterface wethToken, TokenInterface buyToken, uint minBuyAmt) public payable returns (uint buyAmt) {}
    function sellAllAmountBuyEth(OtcInterface otc, TokenInterface payToken, uint payAmt, TokenInterface wethToken, uint minBuyAmt) public returns (uint wethAmt) {}
    function buyAllAmount(OtcInterface otc, TokenInterface buyToken, uint buyAmt, TokenInterface payToken, uint maxPayAmt) public returns (uint payAmt) {}
    function buyAllAmountPayEth(OtcInterface otc, TokenInterface buyToken, uint buyAmt, TokenInterface wethToken) public payable returns (uint wethAmt) {}
    function buyAllAmountBuyEth(OtcInterface otc, TokenInterface wethToken, uint wethAmt, TokenInterface payToken, uint maxPayAmt) public returns (uint payAmt) {}
}

contract OasisDirectAdapter {
    
    function fillOrder(
        address _exchange,
        address[5] orderAddresses,
        uint[6] orderValues,
        uint fillTakerTokenAmount,
        bool shouldThrowOnInsufficientBalanceOrAllowance,
        uint8 v,
        bytes32 r,
        bytes32 s)
        public
    {
        Exchange exchange = Exchange(_exchange);
        OtcInterface otc = OtcInterface(orderAddresses[4]);
        TokenInterface tokenA = TokenInterface(orderAddresses[0]);
        TokenInterface tokenB = TokenInterface(orderAddresses[1]);
        exchange.sellAllAmount(
            otc,
            tokenA,
            uint128(orderValues[0]),
            tokenB,
            uint128(orderValues[1])
        );
    }
    
    function fillOrKill(
        address _exchange,
        address[5] orderAddresses,
        uint[6] orderValues,
        uint fillTakerTokenAmount,
        uint8 v,
        bytes32 r,
        bytes32 s)
        public
    {
        Exchange exchange = Exchange(_exchange);
        OtcInterface otc = OtcInterface(orderAddresses[4]);
        TokenInterface tokenA = TokenInterface(orderAddresses[0]);
        TokenInterface tokenB = TokenInterface(orderAddresses[1]);
        exchange.sellAllAmountPayEth(
            otc,
            tokenA,
            tokenB,
            orderValues[1]
        );
    }
    
    function buy(
        address _exchange,
        address[5] orderAddresses,
        uint[6] orderValues,
        uint fillTakerTokenAmount,
        uint8 v,
        bytes32 r,
        bytes32 s)
        internal //all functions should be internal as they are called in the context of the calling contract through delegatecall
    {
        Exchange exchange = Exchange(_exchange);
        OtcInterface otc = OtcInterface(orderAddresses[4]);
        TokenInterface tokenA = TokenInterface(orderAddresses[0]);
        TokenInterface tokenB = TokenInterface(orderAddresses[1]);
        exchange.sellAllAmountBuyEth(
            otc,
            tokenA,
            orderValues[0],
            tokenB,
            orderValues[1]
        );
    }
    
    function take(
        address _exchange,
        address[5] orderAddresses,
        uint[6] orderValues,
        uint fillTakerTokenAmount,
        uint8 v,
        bytes32 r,
        bytes32 s)
        public
    {
        Exchange exchange = Exchange(_exchange);
        OtcInterface otc = OtcInterface(orderAddresses[4]);
        TokenInterface tokenA = TokenInterface(orderAddresses[0]);
        TokenInterface tokenB = TokenInterface(orderAddresses[1]);
        exchange.buyAllAmount(
            otc,
            tokenA,
            orderValues[0],
            tokenB,
            orderValues[1]
        );
    }    
    
    function cancelOrder(
        address _exchange, 
        address[5] orderAddresses,
        uint[6] orderValues,
        uint cancelTakerTokenAmount
        )
        public
    {
        Exchange exchange = Exchange(_exchange);
        OtcInterface otc = OtcInterface(orderAddresses[4]);
        TokenInterface tokenA = TokenInterface(orderAddresses[0]);
        TokenInterface tokenB = TokenInterface(orderAddresses[1]);
        exchange.buyAllAmountPayEth(
            otc,
            tokenA,
            orderValues[0],
            tokenB
        );
    }
    
    function order6(
        address _exchange, 
        address[5] orderAddresses,
        uint[6] orderValues,
        uint cancelTakerTokenAmount
        )
        public
    {
        Exchange exchange = Exchange(_exchange);
        OtcInterface otc = OtcInterface(orderAddresses[4]);
        TokenInterface tokenA = TokenInterface(orderAddresses[0]);
        TokenInterface tokenB = TokenInterface(orderAddresses[1]);
        exchange.buyAllAmountBuyEth(
            otc,
            tokenA,
            orderValues[0],
            tokenB,
            orderValues[1]
        );
    }
}
