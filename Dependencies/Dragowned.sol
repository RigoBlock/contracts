//! Dragowned contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

contract Dragowned {
    
    modifier onlyDragowner { if (msg.sender != dragowner) return; _; }
    
    event NewDragowner(address indexed old, address indexed current);

    function transferDragownership(address newDragowner) onlyDragowner {
        dragowner = newDragowner;
        NewDragowner(dragowner, newDragowner);
    }
    
    address public dragowner = msg.sender;
}
