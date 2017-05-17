//! Gabcoin EVO contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! This is the new generation of gabcoin contracts.
//! Includes proof of stake pooled mining

pragma solidity ^0.4.11;

contract Owned {
    
	modifier only_owner { if (msg.sender != owner) return; _; }

	event NewOwner(address indexed old, address indexed current);
   
	function setOwner(address _new) only_owner {
		owner = _new;
		NewOwner(owner, _new);
	}
	
	function getOwner() constant returns (address) {
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

contract GabcoinEventful {

	// EVENTS

    event BuyGabcoin(address indexed gabcoin, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event SellGabcoin(address indexed gabcoin, address indexed from, address indexed to, uint256 amount, uint256 revenue);
	event NewFee(address indexed gabcoin, address indexed from, address indexed to, uint fee);
	event NewCollector(address indexed gabcoin, address indexed from, address indexed to, address collector);
	event GabcoinDAO(address indexed gabcoin, address indexed from, address indexed to, address gabcoinDAO);
	event DepositCasper(address indexed gabcoin, address indexed validator, address indexed casper, address withdrawal, uint amount);
	event WithdrawCasper(address indexed gabcoin, address indexed validator, address indexed casper, uint validatorIndex);
	event GabcoinCreated(address indexed gabcoin, address indexed group, address indexed owner, uint gabcoinID, string name, string symbol);

    // METHODS

    function buyGabcoin(address _who, address _targetGabcoin, uint _value, uint _amount) returns (bool success) {}
    function sellGabcoin(address _who, address _targetGabcoin, uint _amount, uint _revenue) returns(bool success) {}
    function changeRatio(address _who, address _targetGabcoin, uint256 _ratio) returns(bool success) {}
    function setTransactionFee(address _who, address _targetGabcoin, uint _transactionFee) returns(bool success) {}
    function changeFeeCollector(address _who, address _targetGabcoin, address _feeCollector) returns(bool success) {}
    function changeGabcoinDAO(address _who, address _targetGabcoin, address _gabcoinDAO) returns(bool success) {}
    function depositToCasper(address _who, address _targetGabcoin, address _casper, address _validation, address _withdrawal, uint _amount) returns(bool success) {}
    function withdrawFromCasper(address _who, address _targetGabcoin, address _casper, uint _validatorIndex) returns(bool success) {}
    function createGabcoin(address _who, address _gabcoinFactory, address _newGabcoin, string _name, string _symbol, uint _gabcoinId, address _owner) returns(bool success) {}
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
    event WhitelistedGabcoin(address indexed gabcoin, bool approved);
    event WhitelistedDrago(address indexed drago, bool approved);
    event NewEventful(address indexed eventful);

    // METHODS

    function setAuthority(address _authority, bool _isWhitelisted) {}
    function setWhitelister(address _whitelister, bool _isWhitelisted) {}
    function whitelistUser(address _target, bool _isWhitelisted) {}
    function whitelistAsset(address _asset, bool _isWhitelisted) {}
    function whitelistExchange(address _exchange, bool _isWhitelisted) {}
    function whitelistDrago(address _drago, bool _isWhitelisted) {}
    function whitelistGabcoin(address _gabcoin, bool _isWhitelisted) {}
    function whitelistRegistry(address _registry, bool _isWhitelisted) {}
    function whitelistFactory(address _factory, bool _isWhitelisted) {}
    function setEventful(address _eventful) {}
    function setGabcoinEventful(address _gabcoinEventful) {}
    function setExchangeEventful(address _exchangeEventful) {}
    function setCasper(address _casper) {}

    function isWhitelistedUser(address _target) constant returns (bool) {}
    function isWhitelister(address _whitelister) constant returns (bool) {}
    function isAuthority(address _authority) constant returns (bool) {}
    function isWhitelistedAsset(address _asset) constant returns (bool) {}
    function isWhitelistedExchange(address _exchange) constant returns (bool) {}
    function isWhitelistedRegistry(address _registry) constant returns (bool) {}
    function isWhitelistedDrago(address _drago) constant returns (bool) {}
    function isWhitelistedGabcoin(address _gabcoin) constant returns (bool) {} 
    function isWhitelistedFactory(address _factory) constant returns (bool) {}
    function getEventful() constant returns (address) {}
    function getGabcoinEventful() constant returns (address) {}
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

contract GabcoinFace {

	event Buy(address indexed from, address indexed to, uint256 indexed amount, uint256 revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed amount,uint256 revenue);
	event DepositCasper(uint amount, address indexed who, address indexed validation, address indexed withdrawal);
 	event WithdrawCasper(uint deposit, address indexed who, address casper);
 
	function() payable {}
	function deposit(address _token, uint _amount) payable returns (bool success) {}
	function withdraw(address _token, uint _amount) returns (bool success) {}
	function buyGabcoin() payable returns (bool success) {}
	function sellGabcoin(uint256 amount) returns (bool success) {}
	function depositCasper(address _validation, address _withdrawal, uint _amount) returns (bool success) {}
    function withdrawCasper(uint _validatorIndex) {}
	function changeRatio(uint256 _ratio) {}	
	function setTransactionFee(uint _transactionFee) {}	
	function changeFeeCollector(address _feeCollector) {}	
	function changeGabcoinDAO(address _gabcoinDAO) {}
	function newPrice() internal returns (uint price) {}

	function balanceOf(address _from) constant returns (uint) {}
	function getVersion() constant returns (string) {}
	function getName() constant returns (string) {}
	function getSymbol() constant returns (string) {}
	function getPrice() constant returns (uint256 newPrice) {}
	function getCasper() constant returns (address) {}
	function getTransactionFee() constant returns (uint) {}
	function getFeeCollector() constant returns (address) {}
}

contract Gabcoin is Owned, ERC20Face, SafeMath, GabcoinFace {
    
    struct AtCasper {
        uint deposits;
    }
    
    event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event DepositCasper(uint amount, address indexed who, address indexed validation, address indexed withdrawal);
 	event WithdrawCasper(uint deposit, address indexed who, address casper);

	modifier only_gabcoinDAO { if (msg.sender != gabcoinDAO) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	modifier casper_contract_only(address _casper) { Authority auth = Authority(authority); if (_casper != auth.getCasper()) return; _; }
    modifier minimum_stake(uint _amount) { if (_amount < min_order) throw; _; }

	function Gabcoin(string _gabcoinName,  string _gabcoinSymbol, uint _gabcoinID, address _owner, address _authority) {
		name = _gabcoinName;
		symbol = _gabcoinSymbol;
		gabcoinID = _gabcoinID;
		owner = _owner;
		feeCollector = _owner;
		authority = _authority;
    }

	function() payable casper_contract_only(msg.sender) {
	    newPrice(); //estimate new price when receive mining reward or deposit back from casper
	}
	
	//this function is used to allow dragos to buy gabcoins
	function deposit(address _token, uint _amount) payable returns (bool success) {
	    if (_token != address(0)) throw;
	    require(buyGabcoin());
	    return true;
	}
	
	//this function is used to allow dragos to sell gabcoins
	function withdraw(address _token, uint _amount) returns (bool success) {
	    require(sellGabcoin(_amount));
	    return true;
	}

	function buyGabcoin() payable minimum_stake(msg.value) returns (bool success) {
		//if (!approvedAccount[msg.sender]) throw;
		uint gross_amount = safeDiv(msg.value, getPrice()) * base;
		uint fee = safeMul(gross_amount, transactionFee);
		uint fee_gabcoin = safeMul(fee , ratio) / 100;
		uint fee_gabcoinDAO = safeSub(fee, fee_gabcoin);
		uint amount = safeSub(gross_amount, fee);
		Authority auth = Authority(authority);
		GabcoinEventful events = GabcoinEventful(auth.getEventful());
		require(events.buyGabcoin(msg.sender, this, msg.value, amount));
		balances[msg.sender] = safeAdd(balances[msg.sender], amount);
		balances[feeCollector] = safeAdd(balances[feeCollector] ,fee_gabcoin);
		balances[gabcoinDAO] = safeAdd(balances[gabcoinDAO], fee_gabcoinDAO);
		totalSupply = safeAdd(totalSupply, gross_amount);
		Buy(msg.sender, this, msg.value, amount);
		return true;
	}
	
	function sellGabcoin(uint256 _amount) minimum_stake(_amount) returns (bool success) {
		//if (!approvedAccount[msg.sender]) throw;
		if (balances[msg.sender] < _amount || balances[msg.sender] + _amount <= balances[msg.sender]) throw;
		uint fee = safeMul (_amount, transactionFee);
		uint fee_gabcoin = safeMul(fee, ratio) / 100;
		uint fee_gabcoinDAO = safeSub(fee, fee_gabcoinDAO);
		uint net_amount = safeSub(_amount, fee);	
		uint net_revenue = safeMul(net_amount, getPrice()) / base;
		Authority auth = Authority(authority);
        GabcoinEventful events = GabcoinEventful(auth.getEventful());		
        require(events.sellGabcoin(msg.sender, this, _amount, net_revenue));
		balances[msg.sender] = safeSub(balances[msg.sender], _amount);
		balances[feeCollector] = safeAdd(balances[feeCollector], fee_gabcoin);
		balances[gabcoinDAO] =safeAdd(balances[gabcoinDAO], fee_gabcoinDAO);
		totalSupply = safeSub(totalSupply, net_amount);
		if (!msg.sender.call.value(net_revenue)()) throw;
		Sell(this, msg.sender, _amount, net_revenue);
		return true;
	}	

	//used to deposit for pooled Proof of Stake mining
	function depositCasper(address _validation, address _withdrawal, uint _amount) only_owner casper_contract_only(_validation) minimum_stake(_amount) returns (bool success) {
		if (_withdrawal != address(this)) throw;
		if (_validation != address(this)) throw;
		Authority auth = Authority(authority);
		Casper casper = Casper(auth.getCasper());
		require(casper.deposit.value(_amount)(_validation, _withdrawal));
		GabcoinEventful events = GabcoinEventful(auth.getEventful());
		require(events.depositToCasper(msg.sender, this, auth.getCasper(), _validation, _withdrawal, _amount));
		//atCasper.deposits = safeAdd(atCasper.deposits, _amount);
		DepositCasper(_amount, msg.sender, _validation, _withdrawal);
		return true;
	}

	function withdrawCasper(uint _validatorIndex) only_owner {
		Authority auth = Authority(authority);
		Casper casper = Casper(auth.getCasper());
		if (!casper.withdraw(_validatorIndex)) throw;
		GabcoinEventful events = GabcoinEventful(auth.getEventful());
		require(events.withdrawFromCasper(msg.sender, this, auth.getCasper(), _validatorIndex));
		//uint depositValue = atCasper.deposits;
		//delete(atCasper.deposits);
		uint depositValue = casper.balanceOf(this);
		WithdrawCasper(depositValue, msg.sender, auth.getCasper());
	}

	function changeRatio(uint256 _ratio) only_gabcoinDAO {
	    Authority auth = Authority(authority);
	    GabcoinEventful events = GabcoinEventful(auth.getEventful());
	    require(events.changeRatio(msg.sender, this, _ratio));
		ratio = _ratio;
	}
	
	function setTransactionFee(uint _transactionFee) only_owner {
	    Authority auth = Authority(authority);
	    GabcoinEventful events = GabcoinEventful(auth.getEventful());
	    require(events.setTransactionFee(msg.sender, this, _transactionFee));
		transactionFee = _transactionFee;	//fee is in basis points (1 bps = 0.01%)
	}

	function changeFeeCollector(address _feeCollector) only_owner {
	    Authority auth = Authority(authority);
	    GabcoinEventful events = GabcoinEventful(auth.getEventful());
	    require(events.changeFeeCollector(msg.sender, this, _feeCollector));
	    feeCollector = _feeCollector; 
	}
	
	function changeGabcoinDAO(address _gabcoinDAO) only_gabcoinDAO {
	    Authority auth = Authority(authority);
	    GabcoinEventful events = GabcoinEventful(auth.getEventful());
	    require(events.changeGabcoinDAO(msg.sender, this, _gabcoinDAO));
        gabcoinDAO = _gabcoinDAO;
	}
	
	function balanceOf(address _from) constant returns (uint256) {
		return balances[_from];
	}

	function getCasper() constant returns (address) {
	    Authority auth = Authority(authority);
	    return auth.getCasper();
	}
	
	function newPrice() internal returns (uint price) {
	    price = getPrice();
	}
	
	function getPrice() constant returns (uint newPrice) {
	    Authority auth = Authority(authority);
	    Casper casper = Casper(auth.getCasper());
	    if (totalSupply == 0) return newPrice = price;
	    uint casperDeposit = casper.balanceOf(this);
	    uint thisBalance = this.balance;
	    uint aum = safeAdd(thisBalance, casperDeposit);
	    return newPrice = safeDiv(aum, totalSupply);
	}
	
	function getFeeCollector() constant returns (address) {
	    return feeCollector;
	}
	
	function getTransactionFee() constant returns (uint) {
	    return transactionFee;
	}

	function getVersion() constant returns (string) {
	    return version;
	}
	
	function getName() constant returns (string) {
	    return name;
	}
	
	function getSymbol() constant returns (string) {
	    return symbol;
	}

	AtCasper atCasper;

	string public name;
	string public symbol;
	uint public gabcoinID;
	string public version = 'GC 1.1.0';
	uint256 public totalSupply = 0;
	uint256 public price= 1 ether;  // price is 1 ether
	uint public base = 1000000; //tokens are divisible by 1 million
	uint256 public transactionFee = 0; //in basis points (1bps=0.01%)
	uint min_order = 100 finney; // minimum stake to avoid dust clogging things up
	address public feeCollector;
	address public gabcoinDAO = msg.sender;
	address public authority;
	//address public owner;
	uint256 public ratio = 80;
	mapping (address => uint256) public balances;
}
