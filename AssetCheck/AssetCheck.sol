//! Asset approved contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.
//! Single assets can be limited.

pragma solidity ^0.4.10;

contract AssetCheck is Owned, AssetCheckFace {

      event ApprovedAsset(address indexed asset, bool approved);

      modifier only_owner { assert(msg.sender == owner); _; }

      function setApproval(address _asset, bool _status) only_owner {
            approved[_asset].status = _status;
      }
      
      function assetCheck(address _asset) public constant returns (bool) {
            return approved[_asset].status;
      }

      mapping(address => bool) public approved;
}
