//! the RigoBlock Token contract.
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

pragma solidity ^0.4.19;


contract Inflation {

    // NON-CONSTANT METHODS

    function mintInflation(address _thePool, uint _reward) external returns (bool) {}
    function setInflationFactor(address _group, uint _inflationFactor) public {}
    function setMinimumRigo(uint _minimum) public {}
    function setRigoblock(address _newRigoblock) public {}
    function setPeriod(uint _newPeriod) public {}
    
    // CONSTANT METHODS
    
    function canWithdraw(address _thePool) public constant returns (bool) {}
    function getInflationFactor(address _group) public constant returns (uint) {}
}

contract SafeMath {

    function safeMul(uint a, uint b) internal pure returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }
    
    function safeDiv(uint a, uint b) internal pure returns (uint) {
        assert(b > 0);
        uint c = a / b;
        assert(a == b * c + a % b);
        return c;
    }

    function safeSub(uint a, uint b) internal pure returns (uint) {
        assert(b <= a);
        return a - b;
    }

    function safeAdd(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        assert(c>=a && c>=b);
        return c;
    }
    
    function max64(uint64 a, uint64 b) internal pure returns (uint64) {
        return a >= b ? a : b;
    }

    function min64(uint64 a, uint64 b) internal pure returns (uint64) {
        return a < b ? a : b;
    }

    function max256(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function min256(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}

contract ERC20Face {
	
	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	
  	function transfer(address _to, uint256 _value) public returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
	function approve(address _spender, uint256 _value) public returns (bool success) {}

	function totalSupply() public constant returns (uint256 totalSupply) {}
	function balanceOf(address _owner) public constant returns (uint256 balance) {}
	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
}

contract ERC20 is ERC20Face {

	function transfer(address _to, uint256 _value) public returns (bool success) {
		if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
			balances[msg.sender] -= _value;
			balances[_to] += _value;
			Transfer(msg.sender, _to, _value);
			return true;
		} else { return false; }
	}

	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
		if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
			balances[_to] += _value;
			balances[_from] -= _value;
			allowed[_from][msg.sender] -= _value;
			Transfer(_from, _to, _value);
			return true;
		} else { return false; }
	}

	function balanceOf(address _owner) public constant returns (uint256 balance) {
		return balances[_owner];
	}

	function approve(address _spender, uint256 _value) public returns (bool success) {
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);
		return true;
	}

	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
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

contract RigoTok is UnlimitedAllowanceToken, SafeMath, RigoTokFace { //UnlimitedAllowanceToken is ERC20

    // EVENTS

    event TokenMinted(address indexed recipient, uint amount);
    
    // MODIFIERS

    modifier only_minter {
        assert(msg.sender == minter);
        _;
    }

    modifier only_rigoblock {
        assert(msg.sender == rigoblock);
        _;
    }
    
    // MOTHODS

    function RigoTok(address _setMinter, address _setRigoblock) public {
        minter = _setMinter;
        rigoblock = _setRigoblock;
        balances[msg.sender] = totalSupply; //ALT: balances[rigoblock] = totalSupply;
    }

    function mintToken(address recipient, uint amount) external only_minter {
        balances[recipient] = safeAdd(balances[recipient], amount);
        totalSupply = safeAdd(totalSupply, amount);
    }

    function transfer(address recipient, uint amount) public returns (bool success) {
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint amount) public returns (bool success) {
        return super.transferFrom(sender, recipient, amount);
    }

    function changeMintingAddress(address newAddress) public only_rigoblock { 
        minter = newAddress; 
    }

    function changeRigoblockAddress(address newAddress) public only_rigoblock {
        rigoblock = newAddress;
    }

    // CONSTANT METHODS

    function getName() public constant returns (string) {
        return name;
    }

    function getSymbol() public constant returns (string) {
        return symbol;
    }

    function getDecimals() public constant returns (uint) {
        return decimals;
    }

    function getMinter() public constant returns (address) {
        return minter;
    }

    function getRigoblock() public constant returns (address) {
        return rigoblock;
    }

    function getInflationFactor(address _group) public constant returns (uint) {
        Inflation inflation = Inflation(minter);
        inflation.getInflationFactor(_group);
    }

    string public constant name = "Rigo Token";
    string public constant symbol = "GRG";
    uint public constant decimals = 18;
    uint public totalSupply = 10**27; // 1 billion tokens, 18 decimal places
    uint public startTime;
    uint public endTime;
    address public minter;
    address public rigoblock;
}
