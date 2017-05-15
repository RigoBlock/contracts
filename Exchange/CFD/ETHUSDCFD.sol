//! CFD contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.
//! This contract is a hybrid CFD/Option contract that allows for leveraged ETHUSDtrading
//! STILL NEEDS IMPROVEMENT ON PRICE INPUT, SETTLEMENT AND ROLLOVER PROCESS

pragma solidity ^0.4.11;

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

contract Exchange {
    // contract only needs to know these 2 functions to send user-credits to exchange

    function addCredits(address stable, uint stable_gets, address leveraged, uint leveraged_gets, uint24 id) returns (bool success) {}

    function getExchangeEventful() constant returns (address) {}
}

contract ExchangeEventful {
    
	// EVENTS

	event Deposit(address exchange, address token, address user, uint amount, uint balance);
	event Withdraw(address exchange, address token, address user, uint amount, uint balance);
	event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, address user);
	event OrderPlaced(address exchange, address indexed cfd, uint32 id, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
    	event OrderMatched(address exchange, address indexed cfd, address indexed stable, address indexed leveraged, bool is_stable, uint32 id, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(address exchange, address indexed cfd, uint32 indexed id, address indexed who, uint128 stake);
	event Cancel(address exchange, address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user);
	event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
	event DealFinalized(address exchange, address indexed cfd, address indexed stable, address indexed leveraged, uint64 price);

	// METHODS

	function deposit(address _who, address _exchange, address _token, uint _amount, uint _balance) payable returns (bool success) {}
	function withdraw(address _who, address _exchange, address _token, uint _amount, uint _balance) returns (bool success) {}
	function order(address _who, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns (bool success) {}
	function orderCFD(address _who, address _exchange, address _cfd, uint32 id, bool _is_stable, uint32 _adjustment, uint128 _stake) returns (bool success) {}
	function dealCFD(address _who, address _exchange, address _cfd, uint32 order, address stable, address leveraged, bool _is_stable, uint32 id, uint64 strike, uint128 _stake) returns (bool success) {}
	function trade(address _who, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint amountGive, uint expires, address user, uint amount) returns (bool success) {}
	function cancelOrder(address _who, address _exchange, address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires) returns (bool success) {}
	function cancel(address _who, address _exchange, address _cfd, uint32 _id, uint128 _stake) returns (bool success) {}
	function finalize(address _who, address _exchange, address _cfd, uint24 _id, address _stable, address _leveraged, uint64 _price) returns (bool success) {}
	function addCredits(address _who, address _exchange, address _stable, uint _stable_gets, address _leveraged, uint _leveraged_gets, uint24 id) returns (bool success) {}
}

contract Oracle {

    event Changed(uint224 current);

    function get() constant returns (uint) {}
    function getPrice() constant returns (uint224) {}
    function getTimestamp() constant returns (uint32) {}
}

contract CFDFace {

  	// EVENTS
	
	event Deposit(address indexed who, uint value);
	event Withdraw(address indexed who, uint value);
	event OrderPlaced(uint32 indexed id, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	event OrderMatched(uint32 indexed id, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(uint32 indexed id, address indexed who, uint128 stake);
	event DealFinalized(uint32 indexed id, address indexed stable, address indexed leveraged, uint64 price);

	// METHODS

	function orderExchange(bool is_stable, uint32 adjustment, uint128 stake, address who) returns (bool success) {}
	function cancelExchange(uint32 id, address who) returns (bool success) {}
	function finalizeExchange(uint24 id, address who) returns (bool success) {}
	function setMaxLeverage(uint maxLeverage) {}
	function setExchange (address _exchange) {}

	function bestAdjustment(bool _is_stable) constant returns (uint32) {}
	function bestAdjustmentFor(bool _is_stable, uint128 _stake) constant returns (uint32) {}
	function dealDetails(uint32 _id) constant returns (address stable, address leveraged, uint64 strike, uint128 stake, uint32 end_time, uint VAR) {}
	function orderDetails(uint32 _id) constant returns (uint128) {}
	function balanceOf(address _who) constant returns (uint) {}
	function getMaxLeverage() constant returns (uint) {}
	function getLastOrderId() constant returns (uint) {}
	function getOrderOwner(uint32 _id) constant returns (address) {}
	function getStable(uint32 _id) constant returns (address) {}
	function getLeveraged(uint32 _id) constant returns (address) {}
	function getDealStake(uint32 _id) constant returns (uint128) {}
	function getDealLev(uint32 _id) constant returns (uint) {}
	function getPrice() constant returns (uint) {}
}

contract CFD is SafeMath, CFDFace {
    
    event Deposit(address indexed who, uint value);
	event Withdraw(address indexed who, uint value);
	event OrderPlaced(uint32 indexed id, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	event OrderMatched(uint32 indexed id, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	event OrderCancelled(uint32 indexed id, address indexed who, uint128 stake);
	event DealFinalized(uint32 indexed id, address indexed stable, address indexed leveraged, uint64 price);

	struct Order {
		address who;
		bool is_stable;
		uint32 adjustment;	// billionths by which to adjust start-price
		uint128 stake;

		uint32 prev_id;		// a linked ring
		uint32 next_id;		// a linked ring
	}

	struct Deal {
		address stable;		// fixed to the alternative asset, and tracking the price feed of oracle
		address leveraged;	// aka volatile (what's left from stable)
		uint64 strike;
		uint128 stake;
		uint32 end_time;

		uint32 prev_id;		// a linked ring
		uint32 next_id;		// a linked ring
		
		uint lev;
	}
	
	modifier is_exchange { if (msg.sender != exchange) return; _; }

	function CFD(address _oracle, address _exchange) {
		oracle = Oracle(_oracle);
		period = 10 minutes;
		exchange = _exchange;
	}

	function deposit(address _who) payable {
		accounts[_who] += msg.value;
		Deposit(_who, msg.value);
	}
	
	function withdraw(uint value) returns (bool success) {
	    if (accounts[msg.sender] >= value && accounts[msg.sender] + value > accounts[msg.sender] && value >= min_order) {
		accounts[msg.sender] -= value;
		if (!msg.sender.send(value)) {
		        throw;
		    } else {
		        Withdraw(msg.sender, value);
		       //Withdraw(this, tx.origin, value);
		    }
		    return true;
        	} else { return (false); }
	}

	function orderExchange(bool is_stable, uint32 adjustment, uint128 stake, address who) is_exchange returns (bool success) {
	    is_stable = !!is_stable;
	    order(is_stable, adjustment, stake, who);
	    return true;
	}

	function order(bool is_stable, uint32 adjustment, uint128 stake, address who) internal {
		if (stake < min_stake) return;

		// sanitize is_stable due to broken web3.js passing it as 'true'
		is_stable = !!is_stable;
		
		// while there's an acceptable opposing order
		while (stake > 0) {
			var head = is_stable ? leveraged : stable;
			if (head == 0)
				break;
			var hadj = orders[head].adjustment;
			if (hadj != adjustment && (hadj < adjustment) == is_stable)
				break;

			// order matches; make a deal.
			var this_stake = orders[head].stake < stake ? orders[head].stake : stake;
		
			var strike = findStrike(uint64(oracle.get()), is_stable ? adjustment : hadj, is_stable ? hadj : adjustment);
			insertDeal(is_stable ? who : orders[head].who, is_stable ? orders[head].who : who, strike, this_stake, head, who);

			stake -= this_stake;
			if (this_stake == orders[head].stake)
				removeOrder(head);
		}

		// if still unfulfilled place what's left in orderbook
		if (stake > 0)
			insertOrder(who, is_stable == true, adjustment, stake);
	}
	
	function cancelExchange(uint32 id, address who) is_exchange returns (bool success) {
	    cancel(id, who);
	    return true;
	}

	/// withdraw an unfulfilled order, or part thereof.
	function cancel(uint32 id, address who) internal {
		if (orders[id].who == who) {
			OrderCancelled(id, who, orders[id].stake);
			removeOrder(id);
		}
	}
	
	function finalizeExchange(uint24 id, address who) is_exchange returns (bool success) {
	    if (deals[id].stable == who || deals[id].leveraged == who) {
	        finalize(id, who);
	    }
	    return true;
	}

	/// lock the current price into a now-ended or out-of-bounds deal.
	function finalize(uint24 id, address who) internal {
	    if (deals[id].stable == who || deals[id].leveraged == who) {
		var price = uint64(oracle.get());
		var strike = deals[id].strike;
		var thisLev = deals[id].lev; //refactor P&L by exposure

		// can't handle the price dropping by over 50%.
		//var early_exit = price < strike / 2; //allow for leverage
		var early_exit = price < strike - (strike / (2 * thisLev));
		if (early_exit)
			//price = strike / 2;
			price = strike - (strike / (2 * uint64(thisLev)));

		if (now >= deals[id].end_time || early_exit) {
			var stake = deals[id].stake;
			//var stable_gets = stake * strike / price;
			var stable_gets = stake / thisLev * strike / price;
			//var leveraged_gets = stake * 2 - stable_gets;
			var leveraged_gets = stake * 2 / thisLev - stable_gets;
			
		    //THIS CALLBACK TO EXCHANGE IS IMPORTANT TO PROPERLY CREDIT P&L	
			Exchange exch = Exchange(exchange);
	        if (!exch.addCredits(deals[id].stable, stable_gets, deals[id].leveraged, leveraged_gets, id)) return;
	      
			DealFinalized(id, deals[id].stable, deals[id].leveraged, price);
			removeDeal(id);
		}
	    }
	}

	// inserts the order into one of the two lists, ordered according to adjustment.
	function insertOrder(address who, bool is_stable, uint32 adjustment, uint128 stake) internal returns (uint32 id) {
		id = next_id;
		++next_id;

		orders[id].who = who;
		orders[id].is_stable = is_stable;
		orders[id].adjustment = adjustment;
		orders[id].stake = stake;

		var head = is_stable ? stable : leveraged;

		var adjust_head = true;
		if (head != 0) {
			// find place to insert
			var i = head;
			for (; (i != head || adjust_head) && (orders[i].adjustment == adjustment || ((orders[i].adjustment < adjustment) == is_stable)); i = orders[i].next_id)
				adjust_head = false;

			// we insert directly before i, and point head to there iff adjust_head.
			orders[id].prev_id = orders[i].prev_id;
			orders[id].next_id = i;
			orders[orders[i].prev_id].next_id = id;
			orders[i].prev_id = id;
		} else {
			// nothing in queue yet, so just place the head
			orders[id].next_id = id;
			orders[id].prev_id = id;
		}
		if (adjust_head) {
			if (is_stable)
				stable = id;
			else
				leveraged = id;
		}

		OrderPlaced(id, who, is_stable, adjustment, stake);

		ExchangeEventful eventful = ExchangeEventful(exchange);
		require(eventful.orderCFD(who, msg.sender, this, id, is_stable, adjustment, stake));
	}

	// removes an order from one of the two lists
	function removeOrder(uint32 id) internal {
		// knit out
		if (orders[id].prev_id != id) {
			// if there's at least another deal in the list, reknit.
			if (stable == id)
				stable = orders[id].next_id;
			else if (leveraged == id)
				leveraged = orders[id].next_id;
			orders[orders[id].prev_id].next_id = orders[id].next_id;
			orders[orders[id].next_id].prev_id = orders[id].prev_id;
		}
		else 
			if (stable == id)
				stable = 0;
			else if (leveraged == id)
				leveraged = 0;

		delete orders[id];
	}

	// inserts the deal into deals at the end of the list.
	function insertDeal(address stable, address leveraged, uint64 strike, uint128 stake, uint32 order, address who) internal returns (uint32 id) {
		// knit in at the end
		id = next_id;
		++next_id;

		deals[id].stable = stable;
		deals[id].leveraged = leveraged;
		deals[id].strike = strike;
		deals[id].stake = stake;
		deals[id].end_time = uint32(now) + period;
		deals[id].lev = maxLev;

		if (head != 0) {
			deals[id].prev_id = deals[head].prev_id;
			deals[id].next_id = head;
			deals[deals[head].prev_id].next_id = id;
			deals[head].prev_id = id;
		} else {
			deals[id].prev_id = id;
			deals[id].next_id = id;
		}

		OrderMatched(order, stable, leveraged, who == stable, id, strike, stake);
	
	    ExchangeEventful eventful = ExchangeEventful(exchange);
		require(eventful.dealCFD(who, msg.sender, this, order, stable, leveraged, who == stable, id, strike, stake));    
	    
	}

	// removes the deal id from deals.
	function removeDeal(uint32 id) internal {
		// knit out
		if (deals[id].prev_id != id) {
			// if there's at least another deal in the list, reknit.
			if (head == id)
				head = deals[id].next_id;
			deals[deals[id].prev_id].next_id = deals[id].next_id;
			deals[deals[id].next_id].prev_id = deals[id].prev_id;
		}
		else 
			if (head == id)
				head = 0;
		delete deals[id];
	}
	
	function setMaxLeverage(uint128 _maxLev) is_exchange {
	    maxLev = _maxLev;
	}
	
	function setExchange (address _exchange) is_exchange {
	    exchange = _exchange;
	}

	// return price * the stake v which is closest to 1000000000 fullfilling (v >= min(stable, leveraged), v <= max(stable, leveraged)) / 1000000000
	function findStrike(uint64 price, uint32 stable, uint32 leveraged) internal returns (uint64) {
		var stable_is_pos = stable > 1000000000;
		var leveraged_is_pos = leveraged > 1000000000;
		if (stable_is_pos != leveraged_is_pos)
			return price;
		else
			return price * ((stable_is_pos == (leveraged < stable)) ? leveraged : stable) / 1000000000;
	}
	
	function bestAdjustment(bool _is_stable) constant returns (uint32) {
		_is_stable = !!_is_stable;
		var head = _is_stable ? stable : leveraged;
		return head == 0 ? 0 : orders[head].adjustment;
	}

	function bestAdjustmentFor(bool _is_stable, uint128 _stake) constant returns (uint32) {
		_is_stable = !!_is_stable;
		var head = _is_stable ? stable : leveraged;
		if (head == 0)
			return 0;
		var i = head;
		uint128 accrued = 0;
		for (; orders[i].next_id != head && accrued + orders[i].stake < _stake; i = orders[i].next_id)
			accrued += orders[i].stake;
		return accrued + orders[i].stake >= _stake ? orders[i].adjustment : 0;
	}
	
	function dealDetails(uint32 _id) constant returns (address stable, address leveraged, uint64 strike, uint128 stake, uint32 end_time, uint VAR) {
		stable = deals[_id].stable;
		leveraged = deals[_id].leveraged;
		strike = deals[_id].strike;
		stake = deals[_id].stake;
		end_time = deals[_id].end_time;
		VAR = deals[_id].stake / deals[_id].lev;
	}
	
	function getLastOrderId() constant returns (uint) {
	    return next_id;
	}
	
	function getMaxLeverage() constant returns (uint) {
	    return maxLev;
	}
	
	function getDealLev(uint32 _id) constant returns (uint) {
	    return deals[_id].lev;
	}
	

	function orderDetails(uint32 _id) constant returns (uint128) {
		return orders[_id].stake;
	}

	function balanceOf(address _who) constant returns (uint) {
		return accounts[_who];
	}
	
	function getOrderOwner(uint32 _id) constant returns (address) {
	    return orders[_id].who;
	}
	
	function getDealStake(uint32 _id) constant returns (uint128) {
	    return orders[_id].stake;
	}

	function getStable(uint32 _id) constant returns (address) {
	    return deals[_id].stable;
	}
	
	function getLeveraged(uint32 _id) constant returns (address) {
	    return deals[_id].leveraged;
	}
	
	function getPrice() constant returns (uint) {
	    return oracle.get();
	}

	Oracle public oracle;
	uint32 public period;
	
	address public exchange;

    	uint min_order = 100 finney; // minimum stake to avoid dust clogging things up
	uint32 public next_id = 1;

	mapping (uint32 => Order) public orders;
	uint32 public leveraged;		// insert into linked ring, ordered ASCENDING by adjustment.
	uint32 public stable;			// insert into linked ring, ordered DESCENDING by adjustment.

	mapping (uint32 => Deal) public deals;
	uint32 public head;			// insert into linked ring; no order.
	
	uint128 min_stake = 100 finney;	// minimum stake to avoid dust clogging things up.
    	uint public maxLev = 1;
    
	mapping (address => uint) public accounts;
}
