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
//! Includes pooled proof of stake mining

pragma solidity ^0.4.19;

contract Owned {

	modifier only_owner { require(msg.sender == owner); _; }

    event NewOwner(address indexed old, address indexed current);

	function setOwner(address _new) public only_owner {
		owner = _new;
		NewOwner(owner, _new);
	}

	function getOwner() public constant returns (address) {
	    return owner;
	}

	address public owner; //= msg.sender; commented as otherwise cannot set owner at creation
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
}    

contract ERC20Face {

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  
	function transfer(address _to, uint256 _value) public returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
	function approve(address _spender, uint256 _value) public returns (bool success) {}

	function totalSupply() public view returns (uint256 total) {}
	function balanceOf(address _who) public view returns (uint256 balance) {}
	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {}
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

    function buyVault(address _who, address _targetVault, uint _value, uint _amount) public returns (bool success) {}
    function sellVault(address _who, address _targetVault, uint _amount, uint _revenue) public returns(bool success) {}
    function changeRatio(address _who, address _targetVault, uint256 _ratio) public returns(bool success) {}
    function setTransactionFee(address _who, address _targetVault, uint _transactionFee) public returns(bool success) {}
    function changeFeeCollector(address _who, address _targetVault, address _feeCollector) public returns(bool success) {}
    function changeVaultDAO(address _who, address _targetVault, address _vaultDAO) public returns(bool success) {}
    function depositToCasper(address _who, address _targetVault, address _casper, address _validation, address _withdrawal, uint _amount) public returns(bool success) {}
    function withdrawFromCasper(address _who, address _targetVault, address _casper, uint _validatorIndex) public returns(bool success) {}
    function createVault(address _who, address _vaultFactory, address _newVault, string _name, string _symbol, uint _vaultID, address _owner) public returns(bool success) {}
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

    function setAuthority(address _authority, bool _isWhitelisted) public {}
    function setWhitelister(address _whitelister, bool _isWhitelisted) public {}
    function whitelistUser(address _target, bool _isWhitelisted) public {}
    function whitelistAsset(address _asset, bool _isWhitelisted) public {}
    function whitelistExchange(address _exchange, bool _isWhitelisted) public {}
    function whitelistDrago(address _drago, bool _isWhitelisted) public {}
    function whitelistVault(address _vault, bool _isWhitelisted) public {}
    function whitelistRegistry(address _registry, bool _isWhitelisted) public {}
    function whitelistFactory(address _factory, bool _isWhitelisted) public {}
    function setEventful(address _eventful) public {}
    function setVaultEventful(address _vaultEventful) public {}
    function setExchangeEventful(address _exchangeEventful) public {}
    function setCasper(address _casper) public {}

    function isWhitelistedUser(address _target) public view returns (bool) {}
    function isWhitelister(address _whitelister) public view returns (bool) {}
    function isAuthority(address _authority) public view returns (bool) {}
    function isWhitelistedAsset(address _asset) public view returns (bool) {}
    function isWhitelistedExchange(address _exchange) public view returns (bool) {}
    function isWhitelistedRegistry(address _registry) public view returns (bool) {}
    function isWhitelistedDrago(address _drago) public view returns (bool) {}
    function isWhitelistedVault(address _vault) public view returns (bool) {} 
    function isWhitelistedFactory(address _factory) public view returns (bool) {}
    function getEventful() public view returns (address) {}
    function getVaultEventful() public view returns (address) {}
    function getExchangeEventful() public view returns (address) {}
    function getCasper() public view returns (address) {}
    function getOwner() public view returns (address) {}
    function getListsByGroups(string _group) public view returns (address[]) {}
}



contract Casper {
    
    function deposit(address _validation, address _withdrawal) public payable {}
    function withdraw(uint128 _validatorIndex) public {}

    function get_deposit_size(uint128 _validatorIndex) public constant returns (uint128) {}
    function get_nextValidatorIndex() public constant returns (uint128) {}
}

contract VaultFace {

    // EVENTS

	event Buy(address indexed from, address indexed to, uint256 indexed amount, uint256 revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed amount,uint256 revenue);
	event DepositCasper(uint amount, address indexed who, address indexed validation, address indexed withdrawal);
 	event WithdrawCasper(uint deposit, address indexed who, address casper);

    // METHODS

	function() public payable {}
	function buyVault() public payable returns (bool success) {}
	function buyVaultOnBehalf(address _hodler) public payable returns (bool success) {}
	function sellVault(uint256 amount) public returns (bool success) {}
	function depositCasper(address _validation, address _withdrawal, uint _amount) public returns (bool success) {}
	function withdrawCasper(uint128 _validatorIndex) public {}
	function changeRatio(uint256 _ratio) public {}	
	function setTransactionFee(uint _transactionFee) public {}	
	function changeFeeCollector(address _feeCollector) public {}	
	function changeVaultDAO(address _vaultDAO) public {}
	function updatePrice() public {}
	function changeMinPeriod(uint32 _minPeriod) public {}
	
	function balanceOf(address _who) public view returns (uint) {}
	function getEventful() public view returns (address) {}
	function getData() public view returns (string name, string symbol, uint sellPrice, uint buyPrice) {}
	function getAdminData() public view returns (address feeCollector, address vaultDAO, uint ratio, uint transactionFee, uint32 minPeriod) {}
	function getOwner() public view returns (address) {}
	function totalSupply() public view returns (uint256) {}
	function getCasper() public view returns (address) {}
	function getCasperDeposit() public view returns (uint128) {}
	function getNav() public view returns (uint) {}
	function getVersion() public view returns (string) {}
}

contract Vault is Owned, ERC20Face, SafeMath, VaultFace {

    string constant VERSION = 'GC 2.1.0';
	uint constant BASE = 1000000; //tokens are divisible by 1 million
	
	VaultData data;
	Admin admin;

	mapping (address => Account) accounts;
	
	event Buy(
	    address indexed from, 
	    address indexed to, 
	    uint256 indexed amount, 
	    uint256 revenue
	);
	
	event Sell(
	    address indexed from, 
	    address indexed to, 
	    uint256 indexed amount, 
	    uint256 revenue
	);
	
	event DepositCasper(
	    uint amount, 
	    address indexed who, 
	    address indexed validation, 
	    address indexed withdrawal
	);
	
 	event WithdrawCasper(
 	    uint deposit, 
 	    address indexed who, 
 	    address casper
 	);

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
		uint128 validatorIndex;
	}

	struct Admin {
	    address authority;
		address vaultDAO;
		address feeCollector;
		uint minOrder; // minimum stake to avoid dust clogging things up
		uint ratio; //ratio is 80%
	}

	modifier only_vaultDAO {
	    require(msg.sender == admin.vaultDAO);
	    _;
	}

	modifier only_owner { 
	    require(msg.sender == owner); 
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

    modifier has_enough(uint _amount) {
        require(accounts[msg.sender].balance >= _amount);
        _;
    }
    
    modifier positive_amount(uint _amount) {
        require(accounts[msg.sender].balance + _amount > accounts[msg.sender].balance);
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
		data.price = 1 ether; //initial price is 1 Ether
		owner = _owner;
		admin.authority = _authority;
		admin.vaultDAO = msg.sender;
		admin.minOrder = 1 finney;
		admin.feeCollector = _owner;
		admin.ratio = 80;
    }

    //can receive from casper contract when withdrawing
	function() public payable casper_contract_only {}
	
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
		var (gross_amount, fee_vault, fee_vaultDAO, amount) = getPurchaseAmounts();
		addPurchaseLog(amount);
		allocateTokens(_hodler, amount, fee_vault, fee_vaultDAO);
		data.totalSupply = safeAdd(data.totalSupply, gross_amount);
		Buy(msg.sender, this, msg.value, amount);
		return true;
	}

	function sellVault(uint256 _amount) 
	    public
	    has_enough(_amount)
	    positive_amount(_amount)
	    minimum_period_past 
	    returns (bool success) 
	{
	    var(fee_vault, fee_vaultDAO, net_amount, net_revenue) = getSaleAmounts(_amount);
        addSaleLog(_amount, net_revenue);
        allocateTokens(msg.sender, _amount, fee_vault, fee_vaultDAO);
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
		data.validatorIndex = casper.get_nextValidatorIndex();
		casper.deposit.value(_amount)(_validation, _withdrawal);
		VaultEventful events = VaultEventful(auth.getVaultEventful());
		require(events.depositToCasper(msg.sender, this, auth.getCasper(), _validation, _withdrawal, _amount));
		DepositCasper(_amount, msg.sender, _validation, _withdrawal);
		return true;
	}

	function withdrawCasper() public only_owner {
		Authority auth = Authority(admin.authority);
		Casper casper = Casper(auth.getCasper());
		uint128 casperDeposit = getCasperDeposit();
		casper.withdraw(data.validatorIndex);
		VaultEventful events = VaultEventful(auth.getVaultEventful());
		require(events.withdrawFromCasper(msg.sender, this, auth.getCasper(), data.validatorIndex));
		WithdrawCasper(casperDeposit, msg.sender, auth.getCasper());
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
	    data.price = getNav();
	}

	function changeMinPeriod(uint32 _minPeriod) public only_vaultDAO {
		data.minPeriod = _minPeriod;
	}

	function balanceOf(address _from) public view returns (uint256) {
		return accounts[_from].balance;
	}

	function getEventful() public view returns (address) {
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
	    sellPrice = buyPrice = getNav();
	    return(
	        name = data.name,
	        symbol = data.symbol,
	        sellPrice,
	        buyPrice
	    );
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

	function getCasperDeposit() public view returns (uint128) {
	    Casper casper = Casper(getCasper());
        return casper.get_deposit_size(data.validatorIndex);
	}
	
	function getNav() public constant returns (uint) {
	    uint casperDeposit = uint(getCasperDeposit());
	    uint aum = safeAdd(this.balance, casperDeposit);
	    return safeDiv(aum * BASE, data.totalSupply);
	}

	function getVersion() public view returns (string) {
	    return VERSION;
	}

	function totalSupply() public view returns (uint256) {
	    return data.totalSupply;
	}
	
	/*
    * Internal functions
    */
    
    function allocateTokens(address _hodler, uint _amount, uint _fee_vault, uint _fee_vaultDAO)
	    internal
	{
	    accounts[_hodler].balance = safeAdd(accounts[_hodler].balance, _amount);
		accounts[admin.feeCollector].balance = safeAdd(accounts[admin.feeCollector].balance, _fee_vault);
		accounts[admin.vaultDAO].balance = safeAdd(accounts[admin.vaultDAO].balance, _fee_vaultDAO);
		accounts[_hodler].receipt.activation = uint32(now) + data.minPeriod;
	}
	
	function addPurchaseLog(uint _amount)
	    internal
	{
	    Authority auth = Authority(admin.authority);
		VaultEventful events = VaultEventful(auth.getVaultEventful());
		require(events.buyVault(msg.sender, this, msg.value, _amount));
	}
	
	function addSaleLog(uint _amount, uint _netRevenue)
	    internal
	{
	    Authority auth = Authority(admin.authority);
        VaultEventful events = VaultEventful(auth.getVaultEventful());		
        require(events.sellVault(msg.sender, this, _amount, _netRevenue));
	} 
	
	function getPurchaseAmounts() 
	    internal 
	    constant 
	    returns (
	        uint gross_amount,
	        uint fee_vault,
	        uint fee_vaultDAO,
	        uint amount
	    )
	{
	    gross_amount = safeDiv(msg.value * BASE, getNav());
	    uint fee = safeMul(gross_amount, data.transactionFee) / 10000; //fee is in basis points
	    return (
	        gross_amount = safeDiv(msg.value * BASE, getNav()),
	        fee_vault = safeMul(fee , admin.ratio) / 100,
	        fee_vaultDAO = safeSub(fee, fee_vault),
	        amount = safeSub(gross_amount, fee)
	    );
	}
	
	function getSaleAmounts(uint _amount) 
	    internal
	    constant 
	    returns (
	        uint fee_vault,
	        uint fee_vaultDAO,
	        uint net_amount,
	        uint net_revenue
	    )
	{
	    uint fee = safeMul (_amount, data.transactionFee) / 10000; //fee is in basis points
	    return (
	        fee_vault = safeMul(fee, admin.ratio) / 100,
	        fee_vaultDAO = safeSub(fee, fee_vaultDAO),
	        net_amount = safeSub(_amount, fee),
	        net_revenue = safeMul(net_amount, getNav()) / BASE
	    );
	}
}
