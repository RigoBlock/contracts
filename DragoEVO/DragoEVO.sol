//! Drago contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! These dragos make use of eventful contract.

pragma solidity ^0.4.18;

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

	address owner; // = msg.sender; otherwise cannot set owner at deploy
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

contract ERC20 {

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  
	function transfer(address _to, uint256 _value) public returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
	function approve(address _spender, uint256 _value) public returns (bool success) {}

	function totalSupply() public constant returns (uint256) {}
	function balanceOf(address _who) public constant returns (uint256) {}
	function allowance(address _owner, address _spender) public constant returns (uint256) {}
}

contract Exchange {
    
    //TODO: set all non payable functions to private so that they can be called just in the context of same contract

	// METHODS

	function deposit(address _token, uint _amount) payable public returns (bool success) {}
	function withdraw(address _token, uint _amount) private returns (bool success) {}
	function order(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) public returns (uint id) {}
	function orderCFD(address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) public returns (uint32 id) {}
	function trade(address _tokenGet, uint _amountGet, address _tokenGive, uint amountGive, uint expires, address user, uint amount) public {}
	function cancelOrder(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) public {}
	function cancel(address _cfd, uint32 _id) public {}
	function finalize(address _cfd, uint24 _id) public {}

	function balanceOf(address token, address user) public constant returns (uint) {}
	function balanceOf(address _who) public constant returns (uint) {}
	function marginOf(address _who) public constant returns (uint) {}
	function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user) public constant returns(uint) {}
	function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user) public constant returns(uint) {}
	function getLastOrderId() public constant returns (uint) {}
	function isActive(uint id) public constant returns (bool) {}
	function getOwner(uint id) public constant returns (address) {}
	function getOrder(uint id) public constant returns (uint, ERC20, uint, ERC20) {}
}

/*
contract Exchange {

	// METHODS

	function deposit(address _token, uint _amount) payable returns (bool success) {}
	function withdraw(address _token, uint _amount) returns (bool success) {}
	function order(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns (uint id) {}
	function orderCFD(address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) returns (uint32 id) {}
	function trade(address _tokenGet, uint _amountGet, address _tokenGive, uint amountGive, uint expires, address user, uint amount) {}
	function cancelOrder(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) {}
	function cancel(address _cfd, uint32 _id) {}
	function finalize(address _cfd, uint24 _id) {}

	function balanceOf(address token, address user) constant returns (uint) {}
	function balanceOf(address _who) constant returns (uint) {}
	function marginOf(address _who) constant returns (uint) {}
	function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user) constant returns(uint) {}
	function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user) constant returns(uint) {}
	function getLastOrderId() constant returns (uint) {}
	function isActive(uint id) constant returns (bool) {}
	function getOwner(uint id) constant returns (address) {}
	function getOrder(uint id) constant returns (uint, ERC20, uint, ERC20) {}
}*/

contract Authority {

    // METHODS

    function setAuthority(address _authority, bool _isWhitelisted) public {}
    function setWhitelister(address _whitelister, bool _isWhitelisted) public {}
    function whitelistUser(address _target, bool _isWhitelisted) public {}
    function whitelistAsset(address _asset, bool _isWhitelisted) public {}
    function whitelistExchange(address _exchange, bool _isWhitelisted) public {}
    function whitelistDrago(address _drago, bool _isWhitelisted) public {}
    function whitelistGabcoin(address _gabcoin, bool _isWhitelisted) public {}
    function whitelistRegistry(address _registry, bool _isWhitelisted) public {}
    function whitelistFactory(address _factory, bool _isWhitelisted) public {}
    function setEventful(address _eventful) public {}
    function setGabcoinEventful(address _gabcoinEventful) public {}
    function setExchangeEventful(address _exchangeEventful) public {}
    function setCasper(address _casper) public {}
    //TODO: implement the below
    function setAdapter(address _exchange) public {}

    function isWhitelistedUser(address _target) public constant returns (bool) {}
    function isWhitelister(address _whitelister) public constant returns (bool) {}
    function isAuthority(address _authority) public constant returns (bool) {}
    function isWhitelistedAsset(address _asset) public constant returns (bool) {}
    function isWhitelistedExchange(address _exchange) public constant returns (bool) {}
    function isWhitelistedRegistry(address _registry) public constant returns (bool) {}
    function isWhitelistedDrago(address _drago) public constant returns (bool) {}
    function isWhitelistedGabcoin(address _gabcoin) public constant returns (bool) {} 
    function isWhitelistedFactory(address _factory) public constant returns (bool) {}
    function getEventful() public constant returns (address) {}
    function getGabcoinEventful() public constant returns (address) {}
    function getExchangeEventful() public constant returns (address) {}
    function getCasper() public constant returns (address) {}
    function getOwner() public constant returns (address) {}
    //TODO: below function does not return correct group
    function getListsByGroups(string _group) public constant returns (address[]) {}
    //TODO: implement below function
    function getAdapter(address _exchange) public constant returns (address) {}
    
}

contract Eventful {

    // METHODS

    function buyDrago(address _who, address _targetDrago, uint _value, uint _amount) external returns (bool success) {}
    function sellDrago(address _who, address _targetDrago, uint _amount, uint _revenue) external returns(bool success) {}
    function setDragoPrice(address _who, address _targetDrago, uint _sellPrice, uint _buyPrice) external returns(bool success) {}
    function changeRatio(address _who, address _targetDrago, uint256 _ratio) external returns(bool success) {}
    function setTransactionFee(address _who, address _targetDrago, uint _transactionFee) external returns(bool success) {}
    function changeFeeCollector(address _who, address _targetDrago, address _feeCollector) external returns(bool success) {}
    function changeDragoDAO(address _who, address _targetDrago, address _dragoDAO) external returns(bool success) {}
    function depositToExchange(address _who, address _targetDrago, address _exchange, address _token, uint256 _value) external returns(bool success) {}
    function withdrawFromExchange(address _who, address _targetDrago, address _exchange, address _token, uint256 _value) external returns(bool success) {}
    function placeOrderExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) external returns(bool success) {}
    function placeTradeExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, address _user, uint _amount) external returns(bool success) {}
    function placeOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) external returns(bool success) {}
    function cancelOrderExchange(address _who, address _targetDrago, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) external returns(bool success) {}
    function cancelOrderCFDExchange(address _who, address _targetDrago, address _cfdExchange, address _cfd, uint32 _id) external returns(bool success) {}
    function finalizedDealExchange(address _who, address _targetDrago, address _exchange, address _cfd, uint24 _id) external returns(bool success) {}
    function createDrago(address _who, address _dragoFactory, address _newDrago, string _name, string _symbol, uint _dragoId, address _owner) external returns(bool success) {}
}

contract DragoFace {

	// METHODS

	function buyDrago() public payable returns (bool success) {}
	function sellDrago(uint _amount) public returns (uint revenue, bool success) {}
	function setPrices(uint _newSellPrice, uint _newBuyPrice) public {}
	function changeMinPeriod(uint32 _minPeriod) public {}
	function changeRatio(uint _ratio) public {}
	function setTransactionFee(uint _transactionFee) public {}
	function changeFeeCollector(address _feeCollector) public {}
	function changeDragoDAO(address _dragoDAO) public {}
	function depositToExchange(address _exchange, address _token, uint _value) public {}
	function withdrawFromExchange(address _exchange, address _token, uint _value) public {}
	function placeOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) public {}
	function placeTradeExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, address _user, uint _amount) public {}
	//function placeOrderCFDExchange(address _exchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) public {}
	function cancelOrderExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) public {}
	//function cancelOrderCFDExchange(address _exchange, address _cfd, uint32 _id) public {}
	function finalizeDealCFDExchange(address _exchange, address _cfd, uint24 _id) public {}
	function setOwner(address _new) public {}
	function() public payable {}   // only_approved_exchange(msg.sender)

	function balanceOf(address _who) public constant returns (uint) {}
	function getEventful() public constant returns (address) {}
	function getData() public constant returns (string name, string symbol, uint sellPrice, uint buyPrice) {}
	function getAdminData() public constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {}
	function getOwner() public constant returns (address) {}
	function totalSupply() public constant returns (uint256) {}
}

contract Drago is Owned, ERC20, SafeMath, DragoFace {
    
	struct Receipt {
		uint units;
		uint32 activation;
	}
	
	struct Account {
		uint balance;
		//mapping (uint => Receipt) receipt;
		Receipt receipt;
		//mapping (address => uint) allowanceOf;
		mapping(address => address[]) approvedAccount;
	}

	struct DragoData {
		//address drago;
		string name;
		string symbol;
		uint dragoID;
		uint totalSupply;
		uint sellPrice;
		uint buyPrice;
		uint transactionFee;
		uint32 minPeriod;
	}

	struct Admin {
	    address authority;
		address dragoDAO;
		address feeCollector;
		uint minOrder; // minimum stake to avoid dust clogging things up
		uint ratio; //ratio is 80%
	}

	modifier only_dragoDAO { if (msg.sender != admin.dragoDAO) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	modifier when_approved_exchange(address _exchange) { Authority auth = Authority(admin.authority); if (auth.isWhitelistedExchange(_exchange)) _; }
	modifier minimum_stake(uint amount) { require (amount >= admin.minOrder); _; }
    modifier minimum_period_past { if (block.timestamp < accounts[msg.sender].receipt.activation) return; _; }
    //modifier minimum_period_past(uint buyPrice, uint amount) { if (now < accounts[msg.sender].receipt[buyPrice].activation) return; _; }

	event Buy(address indexed from, address indexed to, uint indexed _amount, uint _revenue);
	event Sell(address indexed from, address indexed to, uint indexed _amount, uint _revenue);

    // function Drago is internal in order to avoi resetting of parameters
 	function Drago(string _dragoName,  string _dragoSymbol, uint _dragoID, address _owner, address _authority) internal {
		data.name = _dragoName;
		data.symbol = _dragoSymbol;
		data.dragoID = _dragoID;
		data.sellPrice = 1 ether;
		data.buyPrice = 1 ether;
		owner = _owner;
		admin.authority = _authority;
		admin.dragoDAO = msg.sender;
		admin.minOrder = 100 finney;
		admin.feeCollector = _owner;
		admin.ratio = 80;
	}

	function buyDrago() payable minimum_stake(msg.value) public returns (bool success) {
		uint gross_amount = safeDiv(msg.value * base, data.buyPrice);
		uint fee = safeMul(gross_amount, data.transactionFee);
		uint fee_drago = safeMul(fee, admin.ratio) / 100;
 		uint fee_dragoDAO = safeSub(fee, fee_drago);
		uint amount = safeSub(gross_amount, fee);
		Eventful events = Eventful(getEventful());
		require (events.buyDrago(msg.sender, this, msg.value, amount));
		accounts[msg.sender].balance = safeAdd(accounts[msg.sender].balance, amount);
		accounts[admin.feeCollector].balance = safeAdd(accounts[admin.feeCollector].balance, fee_drago);
		accounts[admin.dragoDAO].balance = safeAdd(accounts[admin.dragoDAO].balance, fee_dragoDAO);
 		accounts[msg.sender].receipt.activation = uint32(block.timestamp) + data.minPeriod;
		data.totalSupply = safeAdd(data.totalSupply, gross_amount);
		return (true);
	}

	function sellDrago(uint _amount) minimum_period_past public returns (uint net_revenue, bool success) {
		require (accounts[msg.sender].balance >= _amount && accounts[msg.sender].balance + _amount > accounts[msg.sender].balance);
		uint fee = safeMul (_amount, data.transactionFee);
		uint fee_drago = safeMul(fee, admin.ratio) / 100;
		uint fee_dragoDAO = safeSub(fee, fee_drago);
		uint net_amount = safeSub(_amount, fee);
		Eventful events = Eventful(getEventful());
		net_revenue = safeMul(net_amount, data.sellPrice) / base;
		if (!events.sellDrago(msg.sender, this, _amount, net_revenue)) return;
		accounts[msg.sender].balance = safeSub(accounts[msg.sender].balance, _amount);
		accounts[admin.feeCollector].balance = safeAdd(accounts[admin.feeCollector].balance, fee_drago);
		accounts[admin.dragoDAO].balance = safeAdd(accounts[admin.dragoDAO].balance, fee_dragoDAO);
		data.totalSupply = safeSub(data.totalSupply, net_amount);
		msg.sender.transfer(net_revenue);
		return (net_revenue, true);
	}
	
	function setPrices(uint _newSellPrice, uint _newBuyPrice) public only_owner {
		Eventful events = Eventful(getEventful());
		if (!events.setDragoPrice(msg.sender, this, _newSellPrice, _newBuyPrice)) return;
		data.sellPrice = _newSellPrice;
		data.buyPrice = _newBuyPrice;
	}
	
	function changeMinPeriod(uint32 _minPeriod) public only_dragoDAO {
		data.minPeriod = _minPeriod;
	}
	
	function changeRatio(uint _ratio) public only_dragoDAO {
		admin.ratio = safeDiv(_ratio, 100);
	}

	function setTransactionFee(uint _transactionFee) public only_owner {
	    //Eventful events = Eventful(getEventful());
	    //if (!events.setTransactionFee(msg.sender, this, _transactionFee)) return;
		data.transactionFee = safeDiv(_transactionFee, 10000); //fee is in basis points (1bps=0.01%)
	}

	function changeFeeCollector(address _feeCollector) public only_owner {	
		admin.feeCollector = _feeCollector;
		//events.changeFeeCollector(msg.sender, this, _feeCollector);
	}

	function changeDragoDAO(address _dragoDAO) public only_dragoDAO {
		admin.dragoDAO = _dragoDAO;
	}

	function depositToExchange(address _exchange, address _token, uint _value) 
	    public 
	    only_owner 
	    when_approved_exchange(_exchange) 
	{
		Eventful events = Eventful(getEventful());
		if (!events.depositToExchange(msg.sender, this, _exchange,  _token, _value)) return;
		//Exchange adapter = Exchange(_exchange);
		//require (exchange.deposit.value(_value)(_token, _value));
		//require(_exchange.delegatecall.gas(50000)(bytes4(keccak256("deposit.value(_value)(_token, _value)")), this));
        Authority auth = Authority(admin.authority);
        address adapter = auth.getAdapter(_exchange); //substitute _exchange with adapter when f implemented
        
        uint size = msg.data.length;
        bytes32 m_data = _malloc(size);

        assembly {
            calldatacopy(m_data, 0x0, size)
        }

        bytes32 m_result = _call(m_data, size, adapter);

        assembly {
            return(m_result, 0x20)
        }
	}

	function withdrawFromExchange(address _exchange, address _token, uint _value) 
	    public 
	    only_owner 
	    when_approved_exchange(_exchange) 
	{
		Eventful events = Eventful(getEventful());
	    if (!events.withdrawFromExchange(msg.sender, this, _exchange, _token, _value)) return;
		//Exchange exchange = Exchange(_exchange);
		//if (!exchange.withdraw(_token, _value)) throw; //for ETH token: _token = 0
		//if (!exchange.withdraw(_token, _value)) return; will work only by adding return true; to the exchange
	
	    Authority auth = Authority(admin.authority);
        address adapter = auth.getAdapter(_exchange); //substitute _exchange with adapter when f implemented
        
        uint size = msg.data.length;
        bytes32 m_data = _malloc(size);

        assembly {
            calldatacopy(m_data, 0x0, size)
        }

        bytes32 m_result = _call(m_data, size, adapter);

        assembly {
            return(m_result, 0x20)
        }
	}

	function placeOrderExchange(address _exchange, address[5] orderAddresses, uint[6] orderValues, uint fillTakerTokenAmount, bool shouldThrowOnInsufficientBalanceOrAllowance, bool _is_stable, uint8 v, bytes32 r, bytes32 s) 
	    public
	    only_owner 
	    when_approved_exchange(_exchange) 
	{
		Eventful events = Eventful(getEventful());
		//the below condition in eventful has to be checked to send the correct values, or all of the values received from the call
		//TODO: add _is_stable as further input for events (so we completely merge CFD exchange)
		if (!events.placeOrderExchange(msg.sender, this, _exchange, orderAddresses[1], orderValues[1], orderAddresses[2], orderValues[2], orderValues[3])) return;
		//Exchange exchange = Exchange(_exchange);
		//exchange.order(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires);
		////events.placeOrderExchange(msg.sender, this, _exchange, _token, _value);
		Authority auth = Authority(admin.authority);
        address adapter = auth.getAdapter(_exchange); //substitute _exchange with adapter when f implemented
        
        uint size = msg.data.length;
        bytes32 m_data = _malloc(size);

        assembly {
            calldatacopy(m_data, 0x0, size)
        }

        bytes32 m_result = _call(m_data, size, adapter);

        assembly {
            return(m_result, 0x20)
        }
	}

    //this might be merged into placeOrderExchange as well
	function placeTradeExchange(address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires, address _user, uint _amount) 
	    public
	    only_owner 
	    when_approved_exchange(_exchange) 
	{
		Eventful events = Eventful(getEventful());
	    events.placeTradeExchange(msg.sender, this, _exchange, _tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _user, _amount);
		//Exchange exchange = Exchange(_exchange);
		//exchange.trade(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires, _user, _amount);
	
	    Authority auth = Authority(admin.authority);
        address adapter = auth.getAdapter(_exchange); //substitute _exchange with adapter when f implemented
        
        uint size = msg.data.length;
        bytes32 m_data = _malloc(size);

        assembly {
            calldatacopy(m_data, 0x0, size)
        }

        bytes32 m_result = _call(m_data, size, adapter);

        assembly {
            return(m_result, 0x20)
        }
	}
	
	function cancelOrderExchange(address _exchange, address[5] orderAddresses, uint[6] orderValues, uint cancelTakerTokenAmount)
	    public
	    only_owner 
	    when_approved_exchange(_exchange) 
	{
        Eventful events = Eventful(getEventful());
		require (events.cancelOrderCFDExchange(msg.sender, this, _exchange, orderAddresses[1], uint32(orderValues[1])));
		//Exchange exchange = Exchange(_exchange);
		//exchange.cancelOrder(_tokenGet, _amountGet, _tokenGive, _amountGive, _expires);
	
	    Authority auth = Authority(admin.authority);
        address adapter = auth.getAdapter(_exchange); //substitute _exchange with adapter when f implemented
        
        uint size = msg.data.length;
        bytes32 m_data = _malloc(size);

        assembly {
            calldatacopy(m_data, 0x0, size)
        }

        bytes32 m_result = _call(m_data, size, adapter);

        assembly {
            return(m_result, 0x20)
        }
	}

	function finalizeDealCFDExchange(address _exchange, address _cfd, uint24 _id) 
	    public 
	    only_owner
	    when_approved_exchange(_exchange) 
	{
		Eventful events = Eventful(getEventful());
		require (events.finalizedDealExchange(msg.sender, this, _exchange, _cfd, _id));
		//Exchange exchange = Exchange(_exchange);
		//exchange.finalize(_cfd, _id);
		Authority auth = Authority(admin.authority);
        address adapter = auth.getAdapter(_exchange); //substitute _exchange with adapter when f implemented
        
        uint size = msg.data.length;
        bytes32 m_data = _malloc(size);

        assembly {
            calldatacopy(m_data, 0x0, size)
        }

        bytes32 m_result = _call(m_data, size, adapter);

        assembly {
            return(m_result, 0x20)
        }
	}
	
	//WE ARE MOVING EXECUTION LOGIC TO EXCHANGE CONTRACT PROXIES

    // allocate the given size in memory and return
    // the pointer
    function _malloc(uint size) private returns(bytes32) {
        bytes32 m_data;

        assembly {
            // Get free memory pointer and update it
            m_data := mload(0x40)
            mstore(0x40, add(m_data, size))
        }

        return m_data;
    }

    // make a delegatecall to the target contract, given the
    // data located at m_data, that has the given size
    //
    // @returns A pointer to memory which contain the 32 first bytes
    //          of the delegatecall output
    function _call(bytes32 m_data, uint size, address adapter) private returns(bytes32) {
        address target = adapter;
        bytes32 m_result = _malloc(32);
        bool failed;

        assembly {
            failed := iszero(delegatecall(sub(gas, 10000), target, m_data, size, m_result, 0x20))
        }

        require(!failed);
        return m_result;
    }

	function balanceOf(address _who) public constant returns (uint256) {
		return accounts[_who].balance;
	}

	function getEventful() public constant returns (address) {
	    Authority auth = Authority(admin.authority);
	    return auth.getEventful();
	}
	
	function getData() public constant returns (string name, string symbol, uint sellPrice, uint buyPrice) {
		name = data.name;
		symbol = data.symbol;
		sellPrice = data.sellPrice;
		buyPrice = data.buyPrice;
	}

	function getAdminData() public constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {
		return (admin.feeCollector, admin.dragoDAO, admin.ratio, data.transactionFee, data.minPeriod);
	}

	function totalSupply() public constant returns (uint256) {
	    return data.totalSupply;
	}

	function() public payable when_approved_exchange(msg.sender) {}

	DragoData data;
	Admin admin;
	
	mapping (address => Account) accounts;
	
	string constant version = 'HF 0.3.1';
	uint constant base = 1000000; // tokens are divisible by 1 million
}
