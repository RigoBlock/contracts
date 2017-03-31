//! Drago Registry contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract DragooRegistry {
    
    //separate registry, present here only abstract registry
    
    //modifier when_address_free(address _addr) { if (mapFromAddress[_addr] != 0) return; _; }
	//modifier when_name_free(bytes32 _name) { if (mapFromName[_name] != 0) return; _; }
	//modifier when_has_name(bytes32 _name) { if (mapFromName[_name] == 0) return; _; }
	//modifier only_badge_owner(uint _id) { if (badges[_id].owner != msg.sender) return; _; }
    
    mapping(uint => address) public dragos;
    mapping(address => uint) public toDrago;
    mapping(address => address[]) public created;
    address public _drago;
//  uint public _dragoID;
    uint public nextDragoID;
    
    function accountOf(uint _dragoID) constant returns (address) {
        return dragos[_dragoID];
    }
    
    function dragoOf(address _drago) constant returns (uint) {
        return toDrago[_drago];
    }
    
    function register(address _drago, uint _dragoID) {
        dragos[_dragoID] = _drago;
        toDrago[_drago] = _dragoID;
    }
}
