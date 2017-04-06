//! RigoBlock Token contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract RigoTok is ERC20, SafeMath, RigoBlockFace {

    event TokenMinted(address indexed recipient, uint amount);

    modifier onlyMinter {
        assert(msg.sender == minter);
        _;
    }

    modifier onlyRigoblock {
        assert(msg.sender == melonport);
        _;
    }

    modifier isLaterThan(uint x) {
        assert(now > x);
        _;
    }

    function RigoTok(address setMinter, address setRigoblock, uint setStartTime, uint setEndTime) {
        minter = setMinter;
        rigoblock = setRigoblock;
        startTime = setStartTime;
        endTime = setEndTime;
    }

    function mintToken(address recipient, uint amount) external onlyMinter {
        balances[recipient] = safeAdd(balances[recipient], amount);
        totalSupply = safeAdd(totalSupply, amount);
    }

    function transfer(address recipient, uint amount) isLaterThan(endTime) returns (bool success) {
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint amount) isLaterThan(endTime) returns (bool success) {
        return super.transferFrom(sender, recipient, amount);
    }

    function changeMintingAddress(address newAddress) onlyRigoblock { 
        minter = newAddress; 
    }

    function changeRigoblockAddress(address newAddress) onlyRigoblock {
        rigoblock = newAddress;
    }
    
    string public constant name = "Rigo Token";
    string public constant symbol = "RGT";
    uint public constant decimals = 18;
    uint public startTime;
    uint public endTime;
    address public minter;
    address public rigoblock;
}
