contract ProofOfPerformanceFace {

    function setRegistry(address _dragoRegistry) {}
    function setRigoblock(address _rigoblock) {}
    function setMinimumRigo(uint256 _amount) {}
    
    function calcNetworkValue() constant returns (uint256 totalAum) {}
    function calcPoolValue(uint256 _ofPool) internal constant returns (uint256 poolAum) {}
    function proofOfPerformance(uint _ofPool) constant returns (uint256 PoP) {}
    function getPoolAddress(uint _ofPool) public constant returns (address) {}
}
