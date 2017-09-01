//! RigoBlock Token contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.16;

contract SafeMath {

    function safeMul(uint a, uint b) internal returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }
    
    function safeDiv(uint a, uint b) internal returns (uint) {
        assert(b > 0);
        uint c = a / b;
        assert(a == b * c + a % b);
        return c;
    }

    function safeSub(uint a, uint b) internal returns (uint) {
        assert(b <= a);
        return a - b;
    }

    function safeAdd(uint a, uint b) internal returns (uint) {
        uint c = a + b;
        assert(c>=a && c>=b);
        return c;
    }
    
    function max64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a >= b ? a : b;
    }

    function min64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a < b ? a : b;
    }

    function max256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a >= b ? a : b;
    }

    function min256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a < b ? a : b;
    }
}

contract ERC20Face {
	
	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	
  	function transfer(address _to, uint256 _value) returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
	function approve(address _spender, uint256 _value) returns (bool success) {}

	function totalSupply() constant returns (uint256 total) {}
	function balanceOf(address _owner) constant returns (uint256 balance) {}
	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
}

contract ERC20 is ERC20Face {

	function transfer(address _to, uint256 _value) returns (bool success) {
		if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
			balances[msg.sender] -= _value;
			balances[_to] += _value;
			Transfer(msg.sender, _to, _value);
			return true;
		} else { return false; }
	}

	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
		if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
			balances[_to] += _value;
			balances[_from] -= _value;
			allowed[_from][msg.sender] -= _value;
			Transfer(_from, _to, _value);
			return true;
		} else { return false; }
	}

	function balanceOf(address _owner) constant returns (uint256 balance) {
		return balances[_owner];
	}

	function approve(address _spender, uint256 _value) returns (bool success) {
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);
		return true;
	}

	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
		return allowed[_owner][_spender];
	}

	uint256 public totalSupply;
	mapping (address => uint256) balances;
	mapping (address => mapping (address => uint256)) allowed;
}

contract UnlimitedAllowanceToken is ERC20 {

    uint constant MAX_UINT = 2**256 - 1;
    
    /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance.
    /// @param _from Address to transfer from.
    /// @param _to Address to transfer to.
    /// @param _value Amount to transfer.
    /// @return Success of transfer.
    function transferFrom(address _from, address _to, uint _value)
        public
        returns (bool)
    {
        uint allowance = allowed[_from][msg.sender];
        if (balances[_from] >= _value
            && allowance >= _value
            && balances[_to] + _value >= balances[_to]
        ) {
            balances[_to] += _value;
            balances[_from] -= _value;
            if (allowance < MAX_UINT) {
                allowed[_from][msg.sender] -= _value;
            }
            Transfer(_from, _to, _value);
            return true;
        } else {
            return false;
        }
    }
}

contract RigoTokFace {

    event TokenMinted(address indexed recipient, uint amount);

    function RigoTok(address setMinter, address setRigoblock, uint setStartTime, uint setEndTime) {}
    function mintToken(address recipient, uint amount) external {}
    function transfer(address recipient, uint amount) returns (bool success) {}
    function transferFrom(address sender, address recipient, uint amount) returns (bool success) {}
    function changeMintingAddress(address newAddress) {}
    function changeRigoblockAddress(address newAddress) {}
    
    function getName() constant returns (string name) {}
    function getSymbol() constant returns (string symbol) {}
    function getDecimals() constant returns (uint decimals) {}
    function getStartTime() constant returns (uint startTime) {}
    function getEndTime() constant returns (uint endTime) {}
    function getMinter() constant returns (address minter) {}
    function getRigoblock() constant returns (address rigoblock) {}
}

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
        endTime = _endTime;
    }
   
    function setInflationFactor(uint _inflationFactor) only_rigoblock {
        inflationFactor = _inflationFactor;
    }
    
    function getInflationFactor() constant returns (uint) {
        return inflationFactor;
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
