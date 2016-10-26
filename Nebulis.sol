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

import "Parser.sol";
import "Cluster.sol";
import "Whois.sol";
import "Own.sol";
    /**
     * This is the central contract of the Nebulis ecosystem
     * Allows users to amass Dust to create new clusters
     **/

contract Nebulis is Own {

/// @dev the epoch is the global rate of gravity loss
    uint constant epoch = 42 days;
    
/// @dev the address of the central Dust contract
    Dust public dust;
    
/// @dev the address of the whois account
    Whois public whois;
    
/// @dev the owning contract of nebulis
    Own public owner;

/// @dev "depth" keeps a count of all clusters in the network
    uint public depth = 0;

/// @dev "mass" keeps a global count of all domains registered
    uint public mass;

/// @dev when domains are created or destroyed, this method can update the record
    function domainCount(bytes16 _clusterdomain, bool add) onlyClusters(_clusterdomain) returns(bool) {
        if(add) {
            mass += 1;
        } else {
            mass -= 1;
        }
    }


    struct Deposits {
        uint opencluster;
        uint privatecluster;
        uint newkernal;
    }

/// @dev a struct which stores all the deposits
    Deposits public deposit;

/// @dev kernals are the formation phase of clusters.
    struct Kernel {
        bytes16 precluster;
        uint256 timestamp;
        uint256 amassed;
        address[] owners;
        bool open;
        bool funded;
    }

/// @dev the addresses of all existing clusters
    mapping(bytes16 => address) public clusters;

/// @dev all pending kernals, pre-clusters
    mapping(bytes16 => Kernal) public amassing;

/// @dev the address of the parser library
    address public parser;

/// @dev a guard for non-cluster access
    modifier onlyClusters(bytes32 _clusterdomain) {
        if(clusters[_clusterdomain] == address(0x0)) throw;
        _;
    }
    
/// @dev the owner contract
    modifier onlyOwner {
        if(msg.sender != address(owner)) throw;
        _;
    }

/// @dev the constructor. Creates the Dust contract and the Owner.
    function Nebulis(address _parser,
                    address _whois,
                    uint _initialsupply,
                    uint _initSupply,
                    uint _initDemand,
                    address[] _owners) {

        address _dust = new Dust(_initialSupply, this, _initSupply, _initDemand);
        address _owner = new Own(_owners[], this);
        
        dust = Dust(_dust);
        owner = Own(_owner);
        whois = Whois(_whois);
    }

/// @dev the amass function is where stakeholders can create a new kernal
//  Kernals can either become new Clusters (domains) or new Zones (account-groups)

    function Amass(bytes16 _precluster,
                bool _open,
                address[] _owners,
                uint _deposit) returns(bool) {
            
        if(_deposit != deposit.newkernal 
        || dust.userBal[msg.sender] < deposit.newkernal
        || amassing[_precluster].amassed > 0)
            throw;
        
        if(dust.delegatecall(bytes4(sha3("transfer(address, address, uint)")), msg.sender, this)){
            
            Kernel kernel;
            
            kernel.precluster = _precluster;
            kernel.timestamp = now;
            kernel.amassed = _deposit;
            kernel.owners = _owners;
            kernel.open = _open;
            
            if(_open) {
                if(_deposit > deposit.opencluster) {
                    kernel.funded = true;
                } else {
                    kernel.funded = false;
                }
            } else {
                if(_deposit > deposit.privatecluster) {
                    kernel.funded = true;
                } else {
                    kernel.funded = false;
                }
            }
            
            amassing[_precluster] = kernel;
            return true;
        } else {
            return false;
        }
    }

}

/// @dev the validate function allows people to contribute to a kernal

    function Contribute(bytes16 _name, uint _amount) payable returns(bool) {
        if(_amount < dust.userBal[msg.sender]
        || amassing[_name].amassed = 0
        || amassing[_name].funded = true)
            throw;
        
        amassing[_name].deposit += _amount;
        if(amassing[_name].open) {
            if(amassing[_name].deposit > deposits.opencluster) {
                amassing[_name].funded = true;
            } else {
               if(amassing[_name].deposit > deposits.privatecluster) {
                   amassing[_name].funded = true;
               }
            }
        }
        if(!dust.delegatecall(bytes4(sha3("transfer(address, address, uint)")), msg.sender, this, _amount))
            throw;
        return true;
    }

/// @dev the genesis function is what creates new clusters
    function Genesis(bytes16 _name) returns(bool) {
        
        if(amassing[_name].funded) {
            address _owners = amassing[_name].owners;
            address _cluster = new Cluster(_name, parser, _owners);
            if(_clusters != 0x0) {
                delete amassing[_name];
                clusters[_name] = _clusters;
                return true;
            } else {
                return false;
            }
        }
    }
    
}


