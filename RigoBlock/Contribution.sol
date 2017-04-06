//! Contribution contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.8;

contract Contribution is SafeMath {

    event TokensBought(address indexed sender, uint eth, uint amount);

    modifier isSignerSignature(uint8 v, bytes32 r, bytes32 s) {
        bytes32 hash = sha256(msg.sender);
        assert(ecrecover(hash, v, r, s) == signer);
        _;
    }

    modifier onlyRigoblock {
        assert(msg.sender == rigoblock);
        _;
    }

    modifier notHalted {
        assert(!halted);
        _;
    }

    modifier etherTargetNotReached {
        assert(safeAdd(etherRaised, msg.value) <= ETHER_CAP);
        _;
    }

    modifier notEarlierThan(uint x) {
        assert(now >= x);
        _;
    }

    modifier isEarlierThan(uint x) {
        assert(now < x);
        _;
    }

    function Contribution(address setRigoblock, address setSigner, uint setStartTime) {
        rigoblock = setRigoblock;
        signer = setSigner;
        startTime = setStartTime;
        endTime = startTime + MAX_CONTRIBUTION_DURATION;
        rigoTok = new RigoTok(this, rigoblock, startTime, endTime);
        rigoTok.mintToken(rigoblock, RIGOBLOCK_STAKE * stakeMultiplier);
    }

    function buy(uint8 v, bytes32 r, bytes32 s) payable { buyRecipient(msg.sender, v, r, s); }

    function buyRecipient(address recipient, uint8 v, bytes32 r, bytes32 s) payable isSignerSignature(v, r, s) notEarlierThan(startTime) notHalted etherCapNotReached {
        uint amount = safeMul(msg.value, priceRate()) / DIVISOR_PRICE;
        rigoTok.mintToken(recipient, amount);
        etherRaised = safeAdd(etherRaised, msg.value);
        assert(rigoblock.send(msg.value));
        TokensBought(recipient, msg.value, amount);
    }

    function halt() onlyRigoblock {
        halted = true;
    }

    function unhalt() only_melonport {
        halted = false;
    }

    function changeRigoblockAddress(address newAddress) onlyRigoblock { rigoblock = newAddress; }
    
    function priceRate() constant returns (uint) {
        if (startTime <= now && now < startTime + 1 weeks)
            return PRICE_RATE_FIRST;
        if (startTime + 1 weeks <= now && now < startTime + 2 weeks)
            return PRICE_RATE_SECOND;
        if (startTime + 2 weeks <= now && now < startTime + 3 weeks)
            return PRICE_RATE_THIRD;
        if (startTime + 3 weeks <= now && now < endTime)
            return PRICE_RATE_FOURTH;
        assert(false);
    }
    
    uint public constant ETHER_CAP = 1000000 ether;
    uint public constant MAX_CONTRIBUTION_DURATION = 4 weeks;
    uint public constant PRICE_RATE_FIRST = 55000;
    uint public constant PRICE_RATE_SECOND = 53750;
    uint public constant PRICE_RATE_THIRD = 52500;
    uint public constant PRICE_RATE_FOURTH = 51250;
    uint public constant DIVISOR_PRICE = 1000; // Price rates are divided by this number
    uint public constant RIGOBLOCK_STAKE = 2000; // 20% of all created tokens allocated to rigoblock
    uint public startTime;
    uint public endTime;
    uint public etherRaised;
    address public rigoblock;
    address public signer;
    RigoTok public rigoTok;
}
