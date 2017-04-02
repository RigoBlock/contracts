//! Asset approved contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.
//! Single assets can be limited.

pragma solidity ^0.4.10;

contract AssetCheck is Owned, AssetCheckFace {

      function assetCheck(address _asset) public constant returns (bool _approved) {}

      function setApproval(address _asset, bool _status) onlyowner {
            approved[_asset] = _status;
      }

      function transferOwnership(address _owner) onlyowner {
            owner = _owner;
      }

      mapping(address => bool) public approved;
}
