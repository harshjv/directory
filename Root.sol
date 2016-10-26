/***************************************************************************
    
    Copyright (c) 2016-2018  |  Nebulis Foundation

    Released under The MIT Licence.

    All rights reserved. This software is subject to updates, and is provided 
    without warranty of any kind, express or implied. Use at own risk.

    Permission is hereby granted to any person obtaining copy of this software 
    and associated documentation to use, copy, merge, publish and distribute 
    this software without restriction or charge.

 **************************************************************************/

pragma solidity ^0.4.0;

import "curated.sol";
import "node.sol";

contract root {
    
/// @dev address of the cluster
    address public cluster;

/// @dev address of the curated contract
    address public curated;
    

    modifier checkOnlyCluster {
        if(msg.sender != cluster) throw;
        _;
    }
    
/// @dev redirects a utf-8 index to a storage node
    mapping(bytes1 => address) branch;

// The constructor
    function root(address _cluster, address _curated) {
        cluster = _cluster;
        curated = _curated;
    }

/// @return address of the new storage node.
    function setBranch(bytes1 _index) checkOnlyCluster returns(address) {

        if(getBranch(_index) != 0x0) { 
            throw;
        }
            
        address _node = new node(cluster, _index);
        branch[_index] = _node;
        return _node;
    }

    function getBranch(bytes1 _index) public returns(address) {
        return branch[_index];
    }
}