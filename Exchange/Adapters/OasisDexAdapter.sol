pragma solidity ^0.4.19;

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

    function isActive(uint id) public constant returns (bool active) {}
    function getOwner(uint id) public constant returns (address owner) {}
    function getOffer(uint id) public constant returns (uint, ERC20, uint, ERC20) {}

    // ---- Public entrypoints ---- //

    function bump(bytes32 id_) public {}

    // Accept given `quantity` of an offer. Transfers funds from caller to
    // offer maker, and from market to caller.
    function buy(uint id, uint quantity)
        public
        returns (bool)
    {}

    // Cancel an offer. Refunds offer maker.
    function cancel(uint id)
        public
        returns (bool success)
    {}

    function kill(bytes32 id)
        public
    {}

    function make(
        ERC20    pay_gem,
        ERC20    buy_gem,
        uint128  pay_amt,
        uint128  buy_amt
    )
        public
        returns (bytes32 id)
    {}

    // Make a new offer. Takes funds from the caller into market escrow.
    function offer(uint pay_amt, ERC20 pay_gem, uint buy_amt, ERC20 buy_gem)
        public
        returns (uint id)
    {}

    function take(bytes32 id, uint128 maxTakeAmount) public {}
}

contract OasisDexAdapter {
    
    function fillOrder(
        address _exchange,
        address[5] orderAddresses,
        uint[6] orderValues,
        uint fillTakerTokenAmount,
        bool shouldThrowOnInsufficientBalanceOrAllowance,
        uint8 v,
        bytes32 r,
        bytes32 s)
        public
    {
        Exchange exchange = Exchange(_exchange);
        ERC20 tokenA = ERC20(orderAddresses[0]);
        ERC20 tokenB = ERC20(orderAddresses[1]);
        exchange.make(
            tokenA,
            tokenB,
            uint128(orderValues[0]),
            uint128(orderValues[1])
        );
    }
    
    function fillOrKill(
        address _exchange,
        address[5] orderAddresses,
        uint[6] orderValues,
        uint fillTakerTokenAmount,
        uint8 v,
        bytes32 r,
        bytes32 s)
        public
    {
        Exchange exchange = Exchange(_exchange);
        ERC20 tokenA = ERC20(orderAddresses[0]);
        ERC20 tokenB = ERC20(orderAddresses[1]);
        exchange.offer(
            orderValues[0],
            tokenA,
            orderValues[1],
            tokenB
        );
    }
    
    function buy(
        address _exchange,
        address[5] orderAddresses,
        uint[6] orderValues,
        uint fillTakerTokenAmount,
        uint8 v,
        bytes32 r,
        bytes32 s) 
    {
        Exchange exchange = Exchange(_exchange);
        exchange.buy(
            orderValues[0],
            orderValues[1]
        );
    }
    
    function take(
        address _exchange,
        address[5] orderAddresses,
        uint[6] orderValues,
        uint fillTakerTokenAmount,
        uint8 v,
        bytes32 r,
        bytes32 s)
        public
    {
        Exchange exchange = Exchange(_exchange);
        exchange.take(
            r,
            uint128(fillTakerTokenAmount)
        );
    }    
    
    function cancelOrder(
        address _exchange, 
        address[5] orderAddresses,
        uint[6] orderValues,
        uint cancelTakerTokenAmount
        )
        public
    {
        Exchange exchange = Exchange(_exchange);
        exchange.cancel(
        orderValues[0]);
    }
    
}
