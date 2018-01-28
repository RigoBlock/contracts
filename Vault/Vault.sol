//! the Vault contract.
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
//!
//! Includes proof of stake pooled mining

pragma solidity ^0.4.19;

contract Owned {
    
	modifier only_owner { if (msg.sender != owner) return; _; }

	event NewOwner(address indexed old, address indexed current);
   
	function setOwner(address _new) public only_owner {
		owner = _new;
		NewOwner(owner, _new);
	}
	
	function getOwner() public constant returns (address) {
	    return owner;
	}

	address public owner;// = msg.sender;
}

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
}    

contract ERC20Face {

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  
	function transfer(address _to, uint256 _value) returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
	function approve(address _spender, uint256 _value) returns (bool success) {}

	function totalSupply() constant returns (uint256 total) {}
	function balanceOf(address _who) constant returns (uint256 balance) {}
	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
}

contract VaultEventful {

	// EVENTS

    event BuyVault(address indexed vault, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event SellVault(address indexed vault, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event NewFee(address indexed vault, address indexed from, address indexed to, uint fee);
	event NewCollector(address indexed vault, address indexed from, address indexed to, address collector);
	event VaultDAO(address indexed vault, address indexed from, address indexed to, address vaultDAO);
	event DepositCasper(address indexed vault, address indexed validator, address indexed casper, address withdrawal, uint amount);
	event WithdrawCasper(address indexed vault, address indexed validator, address indexed casper, uint validatorIndex);
	event VaultCreated(address indexed vault, address indexed group, address indexed owner, uint vaultID, string name, string symbol);

    // METHODS

    function buyVault(address _who, address _targetVault, uint _value, uint _amount) returns (bool success) {}
    function sellVault(address _who, address _targetVault, uint _amount, uint _revenue) returns(bool success) {}
    function changeRatio(address _who, address _targetVault, uint256 _ratio) returns(bool success) {}
    function setTransactionFee(address _who, address _targetVault, uint _transactionFee) returns(bool success) {}
    function changeFeeCollector(address _who, address _targetVault, address _feeCollector) returns(bool success) {}
    function changeVaultDAO(address _who, address _targetVault, address _vaultDAO) returns(bool success) {}
    function depositToCasper(address _who, address _targetVault, address _casper, address _validation, address _withdrawal, uint _amount) returns(bool success) {}
    function withdrawFromCasper(address _who, address _targetVault, address _casper, uint _validatorIndex) returns(bool success) {}
    function createVault(address _who, address _vaultFactory, address _newVault, string _name, string _symbol, uint _vaultID, address _owner) returns(bool success) {}
}

contract Authority {

    // EVENTS

    event SetAuthority (address indexed authority);
    event SetWhitelister (address indexed whitelister);
    event SetEventful(address indexed eventful);
    event WhitelistedUser(address indexed target, bool approved);
    event WhitelistedAsset(address indexed asset, bool approved);
    event WhitelistedExchange(address indexed exchange, bool approved);
    event WhitelistedRegistry(address indexed registry, bool approved);
    event WhitelistedFactory(address indexed factory, bool approved);
    event WhitelistedVault(address indexed vault, bool approved);
    event WhitelistedDrago(address indexed drago, bool approved);
    event NewEventful(address indexed eventful);

    // METHODS

    function setAuthority(address _authority, bool _isWhitelisted) {}
    function setWhitelister(address _whitelister, bool _isWhitelisted) {}
    function whitelistUser(address _target, bool _isWhitelisted) {}
    function whitelistAsset(address _asset, bool _isWhitelisted) {}
    function whitelistExchange(address _exchange, bool _isWhitelisted) {}
    function whitelistDrago(address _drago, bool _isWhitelisted) {}
    function whitelistVault(address _vault, bool _isWhitelisted) {}
    function whitelistRegistry(address _registry, bool _isWhitelisted) {}
    function whitelistFactory(address _factory, bool _isWhitelisted) {}
    function setEventful(address _eventful) {}
    function setVaultEventful(address _vaultEventful) {}
    function setExchangeEventful(address _exchangeEventful) {}
    function setCasper(address _casper) {}

    function isWhitelistedUser(address _target) constant returns (bool) {}
    function isWhitelister(address _whitelister) constant returns (bool) {}
    function isAuthority(address _authority) constant returns (bool) {}
    function isWhitelistedAsset(address _asset) constant returns (bool) {}
    function isWhitelistedExchange(address _exchange) constant returns (bool) {}
    function isWhitelistedRegistry(address _registry) constant returns (bool) {}
    function isWhitelistedDrago(address _drago) constant returns (bool) {}
    function isWhitelistedVault(address _vault) constant returns (bool) {} 
    function isWhitelistedFactory(address _factory) constant returns (bool) {}
    function getEventful() constant returns (address) {}
    function getVaultEventful() constant returns (address) {}
    function getExchangeEventful() constant returns (address) {}
    function getCasper() constant returns (address) {}
    function getOwner() constant returns (address) {}
    function getListsByGroups(string _group) constant returns (address[]) {}
}



contract Casper {
    
    function deposit(address _validation, address _withdrawal) payable returns (bool success) {}
    function withdraw(uint _validatorIndex) returns (bool success) {}

    function balanceOf(address _who) constant returns (uint) {}
    //asked viper devs to implement this function
}

contract VaultFace {
    
    // EVENTS

	event Buy(address indexed from, address indexed to, uint256 indexed amount, uint256 revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed amount,uint256 revenue);
	event DepositCasper(uint amount, address indexed who, address indexed validation, address indexed withdrawal);
 	event WithdrawCasper(uint deposit, address indexed who, address casper);

    // METHODS

	function() payable {}
	function deposit(address _token, uint _amount) payable returns (bool success) {}
	function withdraw(address _token, uint _amount) returns (bool success) {}
	function buyVault() payable returns (bool success) {}
	function buyVaultOnBehalf(address _hodler) payable returns (bool success) {}
	function sellVault(uint256 amount) returns (bool success) {}
	function depositCasper(address _validation, address _withdrawal, uint _amount) returns (bool success) {}
	function withdrawCasper(uint _validatorIndex) {}
	function changeRatio(uint256 _ratio) {}	
	function setTransactionFee(uint _transactionFee) {}	
	function changeFeeCollector(address _feeCollector) {}	
	function changeVaultDAO(address _vaultDAO) {}
	function updatePrice() {}
	function changeMinPeriod(uint32 _minPeriod) {}
	
	function balanceOf(address _who) public constant returns (uint) {}
	function getEventful() public constant returns (address) {}
	function getData() public constant returns (string name, string symbol, uint sellPrice, uint buyPrice) {}
	function getAdminData() public constant returns (address feeCollector, address vaultDAO, uint ratio, uint transactionFee, uint32 minPeriod) {}
	function getOwner() public constant returns (address) {}
	function totalSupply() public constant returns (uint256) {}
	function getCasper() public constant returns (address) {}
	function getVersion() public constant returns (string) {}
}

contract Vault is Owned, ERC20Face, SafeMath, VaultFace {
    
    struct Receipt {
		uint32 activation;
	}

	struct Account {
	    uint balance;
		Receipt receipt;
	}
	
	struct VaultData {
		string name;
		string symbol;
		uint vaultID;
		uint totalSupply;
		uint price;
		uint transactionFee; //fee is in basis points (1 bps = 0.01%)
		uint32 minPeriod;
	}
	
	struct Admin {
	    address authority;
		address vaultDAO;
		address feeCollector;
		uint minOrder; // minimum stake to avoid dust clogging things up
		uint ratio; //ratio is 80%
	}
    
    struct AtCasper {
        uint deposits;
    }

    event Buy(address indexed from, address indexed to, uint256 indexed amount, uint256 revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed amount, uint256 revenue);
	event DepositCasper(uint amount, address indexed who, address indexed validation, address indexed withdrawal);
 	event WithdrawCasper(uint deposit, address indexed who, address casper);

	modifier only_vaultDAO {
	    if (msg.sender != admin.vaultDAO) return;
	    _;
	}

	modifier only_owner { 
	    if (msg.sender != owner) return; 
	    _;
	}

	modifier casper_contract_only { 
	    Authority auth = Authority(admin.authority); 
	    require(msg.sender == auth.getCasper()); 
	    _;
	}
	
    modifier minimum_stake(uint _amount) { 
        require(_amount >= admin.minOrder);
        _;
    }
    
	modifier minimum_period_past { 
	    require(now >= accounts[msg.sender].receipt.activation); 
	    _; 
	}

	function Vault(
	    string _vaultName,  
	    string _vaultSymbol, 
	    uint _vaultID, 
	    address _owner, 
	    address _authority) 
	    public
	{
		data.name = _vaultName;
		data.symbol = _vaultSymbol;
		data.vaultID = _vaultID;
		data.price = 1 ether;
		owner = _owner;
		admin.authority = _authority;
		admin.vaultDAO = msg.sender;
		admin.minOrder = 1 finney;
		admin.feeCollector = _owner;
		admin.ratio = 80;
    }

	function() public payable casper_contract_only {}

	//this function enables dragos to buy vaults
	function deposit(address _token, uint _amount) public payable returns (bool success) {
	    require(_token == address(0));
	    require(buyVault());
	    return true;
	}
	
	//this function is used to allow dragos to sell gabcoins
	function withdraw(address _token, uint _amount) public returns (bool success) {
	    require(_token == address(0));
	    require(sellVault(_amount));
	    return true;
	}
	
	function buyVault() public payable minimum_stake(msg.value) returns (bool success) {
	    require(buyVaultOnBehalf(msg.sender));
	    return true;
	}

	function buyVaultOnBehalf(address _hodler)
	    public
	    payable 
	    minimum_stake(msg.value) 
	    returns (bool success) 
	{
		//if (!approvedAccount[msg.sender]) throw;
		uint gross_amount = safeDiv(msg.value * base, data.price);
		uint fee = safeMul(gross_amount, data.transactionFee) / 10000; //fee is in basis points
		uint fee_vault = safeMul(fee , admin.ratio) / 100;
		uint fee_vaultDAO = safeSub(fee, fee_vault);
		uint amount = safeSub(gross_amount, fee);
		Authority auth = Authority(admin.authority);
		VaultEventful events = VaultEventful(auth.getVaultEventful());
		require(events.buyVault(msg.sender, this, msg.value, amount));
		accounts[_hodler].balance = safeAdd(accounts[_hodler].balance, amount);
		accounts[admin.feeCollector].balance = safeAdd(accounts[admin.feeCollector].balance, fee_vault);
		accounts[admin.vaultDAO].balance = safeAdd(accounts[admin.vaultDAO].balance, fee_vaultDAO);
		accounts[_hodler].receipt.activation = uint32(now) + data.minPeriod;
		data.totalSupply = safeAdd(data.totalSupply, gross_amount);
		Buy(msg.sender, this, msg.value, amount);
		return true;
	}

	function sellVault(uint256 _amount) public minimum_period_past returns (bool success) {
		//if (!approvedAccount[msg.sender]) throw;
		require (
		    accounts[msg.sender].balance >= _amount && 
		    accounts[msg.sender].balance + _amount > accounts[msg.sender].balance
		);
		uint fee = safeMul (_amount, data.transactionFee) / 10000; //fee is in basis points
		uint fee_vault = safeMul(fee, admin.ratio) / 100;
		uint fee_vaultDAO = safeSub(fee, fee_vaultDAO);
		uint net_amount = safeSub(_amount, fee);
		uint net_revenue = safeMul(net_amount, data.price) / base;
		Authority auth = Authority(admin.authority);
        VaultEventful events = VaultEventful(auth.getVaultEventful());		
        require(events.sellVault(msg.sender, this, _amount, net_revenue));
		accounts[msg.sender].balance = safeSub(accounts[msg.sender].balance, _amount);
		accounts[admin.feeCollector].balance = safeAdd(accounts[admin.feeCollector].balance, fee_vault);
		accounts[admin.vaultDAO].balance = safeAdd(accounts[admin.vaultDAO].balance, fee_vaultDAO);
		data.totalSupply = safeSub(data.totalSupply, net_amount);
		msg.sender.transfer(net_revenue);
		Sell(this, msg.sender, _amount, net_revenue);
		return true;
	}

	//used to deposit for pooled Proof of Stake mining
	function depositCasper(address _validation, address _withdrawal, uint _amount) 
	    public
	    only_owner 
	    minimum_stake(_amount) 
	    returns (bool success) 
	{
		require(_withdrawal == address(this));
		Authority auth = Authority(admin.authority);
		Casper casper = Casper(auth.getCasper());
		require(casper.deposit.value(_amount)(_validation, _withdrawal));
		VaultEventful events = VaultEventful(auth.getVaultEventful());
		require(events.depositToCasper(msg.sender, this, auth.getCasper(), _validation, _withdrawal, _amount));
		//atCasper.deposits = safeAdd(atCasper.deposits, _amount);
		DepositCasper(_amount, msg.sender, _validation, _withdrawal);
		return true;
	}

	function withdrawCasper(uint _validatorIndex) public only_owner {
		Authority auth = Authority(admin.authority);
		Casper casper = Casper(auth.getCasper());
		require(casper.withdraw(_validatorIndex));
		VaultEventful events = VaultEventful(auth.getVaultEventful());
		require(events.withdrawFromCasper(msg.sender, this, auth.getCasper(), _validatorIndex));
		//uint depositValue = atCasper.deposits;
		//delete(atCasper.deposits);
		uint depositValue = casper.balanceOf(this);
		WithdrawCasper(depositValue, msg.sender, auth.getCasper());
	}

	function changeRatio(uint256 _ratio) public only_vaultDAO {
	    Authority auth = Authority(admin.authority);
	    VaultEventful events = VaultEventful(auth.getVaultEventful());
	    require(events.changeRatio(msg.sender, this, _ratio));
		admin.ratio = _ratio;
	}
	
	function setTransactionFee(uint _transactionFee) public only_owner {
	    require(_transactionFee <= 100); //fee cannot be higher than 1%
	    Authority auth = Authority(admin.authority);
	    VaultEventful events = VaultEventful(auth.getVaultEventful());
	    require(events.setTransactionFee(msg.sender, this, _transactionFee));
		data.transactionFee = _transactionFee;
	}

	function changeFeeCollector(address _feeCollector) public only_owner {
	    Authority auth = Authority(admin.authority);
	    VaultEventful events = VaultEventful(auth.getVaultEventful());
	    require(events.changeFeeCollector(msg.sender, this, _feeCollector));
	    admin.feeCollector = _feeCollector; 
	}

	function changeVaultDAO(address _vaultDAO) public only_vaultDAO {
	    Authority auth = Authority(admin.authority);
	    VaultEventful events = VaultEventful(auth.getVaultEventful());
	    require(events.changeVaultDAO(msg.sender, this, _vaultDAO));
        admin.vaultDAO = _vaultDAO;
	}

	function updatePrice() public {
	    Casper casper = Casper(getCasper());
	    uint casperDeposit = casper.balanceOf(this);
	    uint aum = safeAdd(this.balance, casperDeposit);
	    data.price = safeDiv(aum * base, data.totalSupply);
	}

	function changeMinPeriod(uint32 _minPeriod) public only_vaultDAO {
		data.minPeriod = _minPeriod;
	}

	function balanceOf(address _from) public constant returns (uint256) {
		return accounts[_from].balance;
	}

	function getEventful() public constant returns (address) {
	    Authority auth = Authority(admin.authority);
	    return auth.getVaultEventful();
	}

	function getData() 
	    public 
	    constant 
	    returns (
	        string name, 
	        string symbol, 
	        uint sellPrice, 
	        uint buyPrice
	    ) 
	{
	    return(data.name, data.symbol, data.price, data.price);
	}

	function getAdminData() 
	    public 
	    constant 
	    returns (
	        address feeCollector, 
	        address vaultDAO, 
	        uint ratio, 
	        uint transactionFee, 
	        uint32 minPeriod
	    ) 
	{
	    return (
	        admin.feeCollector, 
	        admin.vaultDAO, 
	        admin.ratio, 
	        data.transactionFee, 
	        data.minPeriod
	    );
	}

	function getCasper() public view returns (address) {
	    Authority auth = Authority(admin.authority);
	    return auth.getCasper();
	}

	function getVersion() public view returns (string) {
	    return version;
	}

	function totalSupply() public view returns (uint256) {
	    return data.totalSupply;
	}

	string public version = 'GC 1.1.0';
	uint public base = 1000000; //tokens are divisible by 1 million

	mapping (address => Account) accounts;

	VaultData data;
	Admin admin;
}
