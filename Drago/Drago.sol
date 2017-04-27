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

	function deposit() payable {}
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
	function sellDrago(uint256 amount) returns (uint revenue, bool success) {}
	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) {}
	function changeRefundActivationPeriod(uint32 _refundActivationPeriod) {}
	function changeRatio(uint256 _ratio) {}
	function setTransactionFee(uint _transactionFee) {}
	function changeFeeCollector(address _feeCollector) {}
	function changeDragator(address _dragator) {}
	function depositToExchange(address exchange, address token, uint256 value) payable returns(bool success) {}
	function depositToCFDExchange(address _cfdExchange) payable returns(bool success) {}
	function withdrawFromExchange(address exchange, address token, uint256 value) returns (bool success) {}
	function withdrawFromCFDExchange(address _cfdExchange, uint amount) returns(bool success) {}
	function placeOrderExchange() {}
    function placeTradeExchange() {}
	function placeOrderCFDExchange(address _cfdExchange, address _cfd, bool is_stable, uint32 adjustment, uint128 stake) {}
	function cancelOrderExchange() {}
	function cancelOrderCFDExchange(address _cfdExchange, address _cfd, uint32 id) {}	
	function finalizeDealCFDExchange(address _cfdExchange, address _cfd, uint24 id) {}

	function balanceOf(address _from) constant returns (uint256) {}
	function getName() constant returns (string) {}
	function getSymbol() constant returns (string) {}
	function getPrice() constant returns (uint256 sellPrice, uint256 buyPrice) {}
	function getSupply() constant returns (uint256) {}
	function getTransactionFee() constant returns (uint256) {}
	function getFeeCollector() constant returns (address) {}
	function getRefundActivationPeriod() constant returns (uint32) {}
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
	
	//struct Drago (to save gas)
	
	modifier only_dragator { if (msg.sender != dragator) return; _; }
	modifier only_owner { if (msg.sender != owner) return; _; }
	//modifier when_approved_exchange { if (exchange != approved) return; _; }
	modifier minimum_period_past(uint buyPrice, uint amount) { if (now < accounts[msg.sender].receipt[buyPrice].activation) return; _; }

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
        name = _dragoName;
        symbol = _dragoSymbol;
        dragoID = _dragoID;
	}
    
	function() payable {
		buyDrago();
	}

	function buyDrago() payable returns (bool success) {
		//if (!approvedAccount[msg.sender]) throw; //or separate whitelisted
		if (msg.value < min_order) throw;
        var gross_amount = safeDiv(msg.value, buyPrice);
        var fee = safeMul(gross_amount, transactionFee) / (100 ether);
        var fee_drago = safeMul(fee, ratio);
        var fee_dragator = safeSub(fee, fee_drago);
        var amount = safeSub(gross_amount, fee);
        balances[msg.sender] = safeAdd(balances[msg.sender], amount);
        balances[feeCollector] = safeAdd(balances[feeCollector], fee_drago);
        balances[dragator] = safeAdd(balances[dragator], fee_dragator);
        accounts[msg.sender].receipt[buyPrice].activation = uint32(now) + refundActivationPeriod;
        totalSupply = safeAdd(totalSupply, gross_amount);
        Buy(msg.sender, this, msg.value, amount);
    	return (true);
	}

	function sellDrago(uint256 amount) minimum_period_past(buyPrice, amount) returns (uint revenue, bool success) {
		//if (!approvedAccount[msg.sender]) throw;
		revenue = safeMul(amount, sellPrice);
        	if (balances[msg.sender] >= amount && balances[msg.sender] + amount > balances[msg.sender] && revenue >= min_order) {
            	balances[msg.sender] = safeSub(balances[msg.sender], amount);
            	totalSupply = safeSub(totalSupply, amount);
		if (!msg.sender.send(revenue)) {
			throw;
			} else { 
				Sell(this, msg.sender, amount, revenue);
			}
			return (revenue, true);
		} else { return (revenue, false); }
	}
	
	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) /*only_owner*/ {  //proxy modifier
        sellPrice = newSellPrice*(10**(18 - 4)); //in wei ALT:newSellPrice*(10**(18 - 4))
        buyPrice = newBuyPrice*(10**(18 - 4));
	}
	
	function changeRefundActivationPeriod(uint32 _refundActivationPeriod) only_dragator {
		refundActivationPeriod = _refundActivationPeriod;
	}
	
	function changeRatio(uint256 _ratio) only_dragator {
		ratio = safeDiv(_ratio, 100);
	}
	
	function setTransactionFee(uint _transactionFee) only_owner {   // 1 ==> 1 bps = 0.01%
		transactionFee = _transactionFee * (10 ** 18) / (1 ether);	//fee in basis points
	}
	
	function changeFeeCollector(address _feeCollector) only_owner {	
	    feeCollector = _feeCollector; 
	}
	
	function changeDragator(address _dragator) only_dragator {
        dragator = _dragator;
	}

	function depositToExchange(address _exchange, address token, uint256 value) /*when_approved_exchange*/ only_owner payable returns(bool success) {
		//address who used to determine from which account _who is the drago contract
		Exchange exchange = Exchange(_exchange);
		exchange.deposit.value(msg.value)(token, value); //exchange.deposit.value(msg.value)(token, value, _who);
	}

	function depositToCFDExchange(address _cfdExchange) /*when_approved_exchange*/ /*only_drago_owner*/ payable returns(bool success) {
	    CFDExchange cfds = CFDExchange(_cfdExchange);
	    cfds.deposit.value(msg.value);
	}

	function withdrawFromExchange(address _exchange, address token, uint256 value) only_owner returns (bool success) {
		Exchange exchange = Exchange(_exchange);
		//if(!exchange.withdraw(value)) throw;
		exchange.withdraw(token, value); //for ETH token = 0
	}

	function withdrawFromCFDExchange(address _cfdExchange, uint amount) /*when_approved_exchange*/ /*only_drago_owner*/ returns(bool success) {
	    CFDExchange cfds = CFDExchange(_cfdExchange);
	    cfds.withdraw(amount);
	}

	function placeOrderCFDExchange(address _cfdExchange, address _cfd, bool is_stable, uint32 adjustment, uint128 stake) /*only_owner*/ {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		cfds.orderCFD(_cfd, is_stable, adjustment, stake);
	}

	function cancelOrderCFDExchange(address _cfdExchange, address _cfd, uint32 id) only_owner {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		cfds.cancel(_cfd, id);
	}

	function finalizeDealCFDExchange(address _cfdExchange, address _cfd, uint24 id) only_owner {
		CFDExchange cfds = CFDExchange(_cfdExchange);
		cfds.finalize(_cfd, id);
	}

	function balanceOf(address _who) constant returns (uint256) {
		return balances[_who];
	}
	
	function getName() constant returns (string) {
	    return name;
	}
	
	function getSymbol() constant returns (string) {
	    return symbol;
	}
	
	function getPrice() constant returns (uint256 sellPrice, uint256 buyPrice) {
	    return (sellPrice, buyPrice);
	}
	
	function getSupply() constant returns (uint256) {
	    return totalSupply;
	}
	
	function getRatio() constant returns (uint256) {
	    return ratio;
	}
	
	function getTransactionFee() constant returns (uint256) {
	    return transactionFee;   
	}
	
	function getFeeCollector() constant returns (address) {
	    return feeCollector;
	}
	
	function getDragator() constant returns (address) {
        return dragator;
	}
	
	function getOwner() constant returns (address) {
        return owner;
	}
	
	function getRefundActivationPeriod() constant returns (uint32) {
	    return refundActivationPeriod;
    }
	
	string public name;
	string public symbol;
	uint public dragoID;
	string public version = 'H0.2';
	uint256 public totalSupply = 0;
	uint256 public sellPrice = 1 ether;
	uint256 public buyPrice = 1 ether;
	uint256 public transactionFee = 0; //in basis points (1bps=0.01%)
	uint min_order = 100 finney; // minimum stake to avoid dust clogging things up
	uint256 public ratio = safeDiv(80, 100) ; //ratio is 80%
	uint32 public refundActivationPeriod = 0 days; //can be amended
	address public feeCollector = msg.sender;
	address public dragator = msg.sender;
	address public owner = msg.sender;
	//address[] cfdExchange; //array of exchanges
	mapping (address => uint256) public balances;
	mapping(address => address[]) public approvedAccount;
	mapping (address => Account) accounts;
}
