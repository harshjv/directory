/***************************************************************************
    
    Copyright (c) 2016-2018  |  Nebulis Foundation

    Released under The MIT Licence.

    All rights reserved. This software is subject to updates, and is provided 
    without warranty of any kind, express or implied. Use at own risk.

    Permission is hereby granted to any person obtaining copy of this software 
    and associated documentation to use, copy, merge, publish and distribute 
    this software without restriction or charge.

 **************************************************************************/
 
pragma solidity ^0.4.2;

import "Nebulis.sol";


contract Dust is Simulacra {
    
    Nebulis public nebulis;
    
    string public ticker = "DTC";
    uint public denom = 1024;
    
    uint public overBal;
    
    mapping(address => uint) public userBal;
    
    mapping(address => bytes32) public clouds;

    /**
     * The original supply will be 8388608 microns (8192 dust) so that
     * Nebulis can create the first 8 clusters
     **/ 
    
    function Dust(uint _initial, address _nebulis, 
                    uint initSupply, uint initDemand) {
        
        
        address _first = new Cloud(_initial, _nebulis);
        
        clouds[_first] = "nebulis";
        overBal += _initial;
        userBal[_nebulis] = _initial;
    }
    
    modifier onlyCloud {
        if(cloudInfo[msg.sender].clusterdomain = 0) throw;
        _;
    }
    
    modifier onlyNebulis {
        if(msg.sender != nebulis) throw;
        _;
    }
    
    modifier onlyCluster(bytes32 _cluster) {
        if(msg.sender != nebulis.clusters[_cluster]) throw;
        _;
    }

/// @dev when domains are created, 1 unit of dust is milled into existence
    function mill(address _cluster, address _for) onlyCluster(_cluster) returns(bool) {
        overBal += 1024;
        userBal[_for] += 1024;
        Gen(5, "dust/genesis", 0, 0, now, _for, this, _cluster);
        return true;
    }

/// @when a domain is ejected or deleted, the uniform cost is 1 dust.
    function void(address _cluster, address _for) onlyCluster(_cluster) returns(bool) {
        overBal -= 1024;
        userBal[_for] -= 1024;
        Void(2, "void/dust",now,_for, 0, _cluster);
        return true;
    }

/// @dev allows users to transfer dust from one user to another
    function transfer(address _from, address _to, uint _amount) returns(bool){
        if(msg.sender != userBal[_from]) 
            throw;
        if(userBal[_from] < _amount) 
            throw;
        userBal[_from] -= _amount;
        userBal[_to] += _amount;
        Alt(2, "dust/transaction", _amount, now, _from, _to, this, 0, 0);
        return true;
    }

/// @dev allows nebulis to create new Cloud contracts
    function genesis(address _cluster, bytes32 _clusterdomain) onlyNebulis returns(address) {
            address _cloud = new Cloud(0, _cluster);
            clouds[_cloud] = _clusterdomain;
            Gen(6, "cloud/genesis", _clusterdomain, 0,now, _cluster, this, _cluster);
            return true;
    }
    
    
}

 