//! Asset approved Interface contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract AssetCheckFace {

      event ApprovedAsset(address indexed asset, bool approved);
      
      function setApproval(address _asset, bool _status) {}
      function assetCheck(address _asset) public constant returns (bool) {}
      
      function assetCheck(address _asset) public constant returns (bool _approved) {}
      function setApproval(address _asset, bool _status) onlyowner {}
      function transferOwnership(address _owner) onlyowner {}
}
