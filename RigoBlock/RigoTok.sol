//! RigoBlock Token contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.16;

contract RigoTok is UnlimitedAllowanceToken, SafeMath, RigoTokFace { //UnlimitedAllowanceToken is ERC20

    event TokenMinted(address indexed recipient, uint amount);

    modifier only_minter {
        assert(msg.sender == minter);
        _;
    }

    modifier only_rigoblock {
        assert(msg.sender == rigoblock);
        _;
    }
    
    modifier is_later_than(uint time) {
        assert(now > time);
        _;
    }

    function RigoTok(address setMinter, address setRigoblock, uint setStartTime, uint setEndTime) {
        minter = setMinter;
        rigoblock = setRigoblock;
        startTime = setStartTime;
        endTime = setEndTime;
        balances[msg.sender] = totalSupply; //ALT: balances[rigoblock] = totalSupply;
    }

    function mintToken(address recipient, uint amount) external only_minter {
        balances[recipient] = safeAdd(balances[recipient], amount);
        totalSupply = safeAdd(totalSupply, amount);
    }

    function transfer(address recipient, uint amount) is_later_than(endTime) returns (bool success) {
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint amount) is_later_than(endTime) returns (bool success) {
        return super.transferFrom(sender, recipient, amount);
    }

    function changeMintingAddress(address newAddress) only_rigoblock { 
        minter = newAddress; 
    }

    function changeRigoblockAddress(address newAddress) only_rigoblock {
        rigoblock = newAddress;
    }
    
    function setStartTime(uint _startTime) only_rigoblock {
        startTime = _startTime;
    }
    
    function setEndTime(uint _endTime) only_rigoblock {
        endTime = _endtTime;
    }
   
    function setInflationFactor(uint _inflationFactor) only_rigoblock {
        inflationFactor = _inflationFactor;
    }
   
    string public constant name = "Rigo Token";
    string public constant symbol = "RGT";
    uint public constant decimals = 18;
    uint public totalSupply = 10**27; // 1 billion tokens, 18 decimal places
    uint public startTime;
    uint public endTime;
    address public minter;
    address public rigoblock; 
    uint public inflationFactor = 1; // an inflation factor of 5 is equal to an inflation of 5%
}
