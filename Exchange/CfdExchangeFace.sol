//! CFD Exchange Interface contract.
//! By Gabriele Rigo (Rigo Investment Sagl), 2017.
//! Released under the Apache Licence 2.

contract CfdExchangeFace {

	  // EVENTS
	
	  event OrderPlaced(address indexed cfd, address indexed who, bool indexed is_stable, uint32 adjustment, uint128 stake);
	  event OrderMatched(address indexed cfd, address indexed stable, address indexed leveraged, bool is_stable, uint32 deal, uint64 strike, uint128 stake);
	  event OrderCancelled(address indexed cfd, address indexed who, uint128 stake);
	  event DealFinalized(address indexed cfd, address indexed stable, address indexed leveraged, uint64 price);

	  // METHODS

	  function deposit() payable {}
	  function withdraw(uint256 amount) {}
	  function orderCFD(bool is_stable, uint32 adjustment, uint128 stake) payable {}	//returns(uint id)
	  function cancel(uint32 id) {}	//function cancel(uint id) returns (bool) {}
	  function finalize(uint24 id) {}
	  function moveOrder(uint id, uint quantity) returns (bool) {}
	
	  function balanceOf(address _who) constant returns (uint256) {}
	  function getLastOrderId() constant returns (uint) {}
	  function isActive(uint id) constant returns (bool active) {}
	  function getOwner(uint id) constant returns (address owner) {}
}
