//! the RigoBlock Token Interface contract.
//!
//! The proof-of-performance contract.
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

contract RigoTokFace {

    // EVENTS

    event TokenMinted(address indexed recipient, uint amount);

    // NON-CONSTANT METHODS

    function RigoTok(address setMinter, address setRigoblock) public {}
    function mintToken(address recipient, uint amount) external {}
    //function transfer(address recipient, uint amount) public returns (bool success) {}
    //function transferFrom(address sender, address recipient, uint amount) public returns (bool success) {}
    function changeMintingAddress(address newAddress) public {}
    function changeRigoblockAddress(address newAddress) public {}

    // CONSTANT METHODS

    //function balanceOf(address _owner) constant returns (uint256 balance) {}
    //function totalSupply() constant returns (uint256 totalSupply) {}
    function getName() public constant returns (string) {}
    function getSymbol() public constant returns (string) {}
    function getDecimals() public constant returns (uint) {}
    function getMinter() public constant returns (address) {}
    function getRigoblock() public constant returns (address) {}
    function getInflationFactor(address _group) public constant returns (uint) {}
}
