//! Drago contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

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

	address public owner = msg.sender;
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

contract ERC20 {

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  
	function transfer(address _to, uint256 _value) returns (bool success) {}
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
	function approve(address _spender, uint256 _value) returns (bool success) {}

	function totalSupply() constant returns (uint256) {}
	function balanceOf(address _who) constant returns (uint256) {}
	function allowance(address _owner, address _spender) constant returns (uint256) {}
}

contract Exchange {
    
	// EVENTS

	event Deposit(address token, address user, uint amount, uint balance);
	event Withdraw(address token, address user, uint amount, uint balance);
	event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
	event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
	event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);

	// METHODS

	function deposit(address token, uint256 amount) payable {}
	function withdraw(address token, uint256 amount) {}
	function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {}
	function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {}
	function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {}
	
	function balanceOf(address _who) constant returns (uint256) {}
	function balanceOf(address token, address user) constant returns (uint256) {}
	function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {}
	function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {}
	function getLastOrderId() constant returns (uint) {}
	function isActive(uint id) constant returns (bool) {}
	function getOwner(uint id) constant returns (address) {}
	function getOrder(uint id) constant returns (uint, ERC20, uint, ERC20) {}
}

contract CFDExchange {

	// EVENTS
	
	event Deposit(address token, address user, uint amount, uint balance);
  	event Withdraw(address token, address user, uint amount, uint balance);
	event OrderPlaced(address indexed cfd, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	event OrderMatched(address indexed cfd, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(address indexed cfd, uint32 indexed id, address indexed who, uint128 stake);
	event DealFinalized(address indexed cfd, address indexed stable, address indexed leveraged, uint64 price);

	// METHODS

	function deposit() payable /*returns (bool success)*/ {}
	function withdraw(uint256 amount) {}
	function orderCFD(address _cfd, bool is_stable, uint32 adjustment, uint128 stake) {}	//returns(uint id)
	function cancel(address _cfd, uint32 id) {}	//function cancel(uint id) returns (bool) {}
	function finalize(address _cfd, uint24 id) {}
	function moveOrder(address _cfd, uint24 id, bool is_stable, uint32 adjustment) returns (bool) {}

	function balanceOf(address _who) constant returns (uint) {}
	function marginOf(address _who) constant returns (uint) {}
	function balanceOf(address token, address _who) constant returns (uint) {}
	function getLastOrderId() constant returns (uint) {}
	function isActive(uint id) constant returns (bool) {}
	function getOwner(uint id) constant returns (address) {}
	function getBestAdjustment(address _cfd, bool _is_stable) constant returns (uint32) {}
	function getBestAdjustmentFor(address _cfd, bool _is_stable, uint128 _stake) constant returns (uint32) {}
}

contract DragoFace {
    
	// METHODS

 	function Drago(string _dragoName,  string _dragoSymbol, uint _dragoID) {}
	function() payable {}
	function buyDrago() payable returns (bool success) {}
	function sellDrago(uint256 _amount) returns (uint revenue, bool success) {}
	function setPrices(uint256 _newSellPrice, uint256 _newBuyPrice) {}
	function changeMinPeriod(uint32 _minPeriod) {}
	function changeRatio(uint256 _ratio) {}
	function setTransactionFee(uint _transactionFee) {}
	function changeFeeCollector(address _feeCollector) {}
	function changeDragator(address _dragoDAO) {}
	function depositToExchange(address _exchange, address _token, uint256 _value) payable returns(bool success) {}
	function depositToCFDExchange(address _cfdExchange, uint256 _value) payable returns(bool success) {}
	function withdrawFromExchange(address _exchange, address _token, uint256 _value) returns (bool success) {}
	function withdrawFromCFDExchange(address _cfdExchange, uint _amount) returns(bool success) {}
	function placeOrderExchange() {}
	function placeTradeExchange() {}
	function placeOrderCFDExchange(address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) {}
	function cancelOrderExchange() {}
	function cancelOrderCFDExchange(address _cfdExchange, address _cfd, uint32 _id) {}	
	function finalizeDealCFDExchange(address _cfdExchange, address _cfd, uint24 _id) {}

	function balanceOf(address _who) constant returns (uint256) {}
	function getData() constant returns (string name, string symbol, uint sellPrice, uint buyPrice, uint totalSupply) {}
	function getAdminData() constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {}
	function getOwner() constant returns (address) {}
}

contract Drago is Owned, ERC20, SafeMath, DragoFace {
    
	struct Receipt {
		uint units;
		uint32 activation;
	}
	
	struct Account {
		uint balance;
		mapping (uint => Receipt) receipt;
		mapping (address => uint) allowanceOf;
	}
	
	struct DragoData {
		address drago;
		address owner;
		string name;
		string symbol;
		uint dragoID;
		uint totalSupply;
		uint sellPrice;
		uint buyPrice;
		//mapping (bytes32 => bytes32) meta;
	}
	
	modifier only_dragoDAO { if (msg.sender != dragoDAO) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	//modifier when_approved_exchange { if (exchange != approved) return; _; }
	modifier minimum_period_past(uint buyPrice, uint amount) { if (now < accounts[msg.sender].receipt[buyPrice].activation) return; _; }
	modifier minimum_stake(uint amount) { if (amount < min_order) throw; _; }

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	event Buy(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed _amount, uint256 _revenue);
	event NAV(uint sellPrice, uint buyPrice);
	event DepositExchange(uint value, uint256 indexed _amount, address indexed who, address token , address indexed _exchange);
	event DepositCFDExchange(uint , uint256 indexed _amount, address indexed who, address , address indexed _cfdExchange);
	event WithdrawExchange(uint , uint256 indexed _amount, address indexed who, address , address indexed _cfdExchange);
	event WithdrawCFDExchange(uint , uint256 indexed _amount, address indexed who, address , address indexed _cfdExchange);
	event OrderCFD(address indexed _cfdExchange, address indexed _cfd);
	event CancelCFD(address indexed _cfdExchange, address indexed _cfd);
	event FinalizeCFD(address indexed _cfdExchange, address indexed _cfd);

 	function Drago(string _dragoName,  string _dragoSymbol, uint _dragoID) {
		data.name = _dragoName;
		data.symbol = _dragoSymbol;
		data.dragoID = _dragoID;
		data.sellPrice = 1 ether;
		data.buyPrice = 1 ether;
	}
    
	function() payable {
		buyDrago();
	}

	function buyDrago() payable minimum_stake(msg.value) returns (bool success) {
		//if (!approvedAccount[msg.sender]) throw; //or separate whitelisted
		uint gross_amount = safeDiv(msg.value, data.buyPrice) * base;
        uint fee = safeMul(gross_amount, transactionFee);
        uint fee_drago = safeMul(fee, ratio);
        uint fee_dragoDAO = safeSub(fee, fee_drago);
        uint amount = safeSub(gross_amount, fee);
        balances[msg.sender] = safeAdd(balances[msg.sender], amount);
        balances[feeCollector] = safeAdd(balances[feeCollector], fee_drago);
        balances[dragoDAO] = safeAdd(balances[dragoDAO], fee_dragoDAO);
        accounts[msg.sender].receipt[data.buyPrice].activation = uint32(now) + minPeriod;
        data.totalSupply = safeAdd(data.totalSupply, gross_amount);
        Buy(msg.sender, this, msg.value, amount);
    	return (true);
	}

	function sellDrago(uint256 _amount) minimum_period_past(data.buyPrice, _amount) minimum_stake(net_revenue) returns (uint net_revenue, bool success) {
		//if (!approvedAccount[msg.sender]) throw;
		if (balances[msg.sender] < _amount && balances[msg.sender] + _amount <= balances[msg.sender]) throw;
		uint gross_amount = _amount;
		uint fee = safeMul (gross_amount, transactionFee);
		uint fee_drago = safeMul(fee, ratio);
        uint fee_dragoDAO = safeSub(fee, fee_drago);
		uint net_amount = safeSub(gross_amount, fee);
		net_revenue = safeMul(net_amount, data.sellPrice) / base;
        balances[msg.sender] = safeSub(balances[msg.sender], _amount);
        balances[feeCollector] = safeAdd(balances[feeCollector], fee_drago);
        balances[dragoDAO] = safeAdd(balances[dragoDAO], fee_dragoDAO);
        data.totalSupply = safeSub(data.totalSupply, _amount);
		if (!msg.sender.send(net_revenue)) throw;
		Sell(this, msg.sender, _amount, net_revenue);
		return (net_revenue, true);
	}
	
	function setPrices(uint256 _newSellPrice, uint256 _newBuyPrice) only_owner {
        	data.sellPrice = _newSellPrice;
            data.buyPrice = _newBuyPrice;
	}
	
	function changeMinPeriod(uint32 _minPeriod) only_dragoDAO {
		minPeriod = _minPeriod;
	}
	
	function changeRatio(uint256 _ratio) only_dragoDAO {
		ratio = safeDiv(_ratio, 100);
	}
	
	function setTransactionFee(uint _transactionFee) only_owner {
		transactionFee = safeDiv(_transactionFee, 10000); //fee is in basis points
	}
	
	function changeFeeCollector(address _feeCollector) only_owner {	
		feeCollector = _feeCollector; 
	}
	
	function changeDragoDAO(address _dragoDAO) only_dragoDAO {
    	dragoDAO = _dragoDAO;
	}

	function depositToExchange(address _exchange, address _token, uint256 _value) /*when_approved_exchange*/ only_owner payable returns(bool success) {
		Exchange exchange = Exchange(_exchange);
		exchange.deposit.value(_value)(_token, _value);
	}

	function depositToCFDExchange(address _cfdExchange, uint256 _value) /*when_approved_exchange*/ only_owner payable returns(bool success) {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		cfds.deposit.value(_value)();
		return true;
	}

	function withdrawFromExchange(address _exchange, address _token, uint256 _value) only_owner returns (bool success) {
		Exchange exchange = Exchange(_exchange);
		//if(!exchange.withdraw(value)) throw;
		exchange.withdraw(_token, _value); //for ETH token = 0
	}

	function withdrawFromCFDExchange(address _cfdExchange, uint _amount) /*when_approved_exchange*/ only_owner returns(bool success) {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		cfds.withdraw(_amount);
	}

	function placeOrderCFDExchange(address _cfdExchange, address _cfd, bool _is_stable, uint32 _adjustment, uint128 _stake) only_owner {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		cfds.orderCFD(_cfd, _is_stable, _adjustment, _stake);
	}

	function cancelOrderCFDExchange(address _cfdExchange, address _cfd, uint32 _id) only_owner {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		cfds.cancel(_cfd, _id);
	}

	function finalizeDealCFDExchange(address _cfdExchange, address _cfd, uint24 _id) only_owner {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		cfds.finalize(_cfd, _id);
	}

	function balanceOf(address _who) constant returns (uint256) {
		return balances[_who];
	}
	
	function getData() constant returns (string name, string symbol, uint sellPrice, uint buyPrice, uint totalSupply) {
		name = data.name;
		symbol = data.symbol;
		sellPrice = sellPrice;
		buyPrice = buyPrice;
		totalSupply = totalSupply;
	}
	
	function getAdminData() constant returns (address feeCollector, address dragodAO, uint ratio, uint transactionFee, uint32 minPeriod) {
	    return (feeCollector, dragoDAO, ratio, transactionFee, minPeriod);
	}
	
	function getOwner() constant returns (address) {
        return owner;
	}
	
	DragoData data;
	
	string public version = 'H0.2';
	
	uint public base = 1000000;    // tokens are divisible
	uint256 public transactionFee = 0; //in basis points (1bps=0.01%)
	uint min_order = 100 finney; // minimum stake to avoid dust clogging things up
	uint256 public ratio = safeDiv(80, 100) ; //ratio is 80%
	uint32 public minPeriod = 0 days; //can be amended
	address public feeCollector = msg.sender;
	address public dragoDAO;
	address public owner = msg.sender;
	//address[] cfdExchange; //array of exchanges
	mapping (address => uint256) public balances;
	mapping(address => address[]) public approvedAccount;
	mapping (address => Account) accounts;
}

contract DragoRegistry {

	//EVENTS

	event Registered(string indexed symbol, uint indexed id, address drago, string name);
	event Unregistered(string indexed symbol, uint indexed id);
	event MetaChanged(uint indexed id, bytes32 indexed key, bytes32 value);
	
	// METHODS
        
	function register(address _drago, string _name, string _symbol, uint _dragoID) payable returns (bool) {}
	function registerAs(address _drago, string _name, string _symbol, uint _dragoID, address _owner) payable returns (bool) {}
	function unregister(uint _id) {}
	function setMeta(uint _id, bytes32 _key, bytes32 _value) {}
	function setFee(uint _fee) {}
	function drain() {}
	
	function dragoCount() constant returns (uint) {}
	function drago(uint _id) constant returns (address drago, string name, string symbol, uint dragoID, address owner) {}
	function fromAddress(address _drago) constant returns (uint id, string name, string symbol, uint dragoID, address owner) {}
	function fromSymbol(string _symbol) constant returns (uint id, address drago, string name, uint dragoID, address owner) {}
	function fromName(string _name) constant returns (uint id, address drago, string symbol, uint dragoID, address owner) {}
	function meta(uint _id, bytes32 _key) constant returns (bytes32) {}
}
