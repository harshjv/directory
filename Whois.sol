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
import "Parser.sol";
import "Who.sol";
import "Root.sol";
import "Cluster.sol";
import "Node.sol";

 contract Whois {
    
    using Parser for *;
    
    address public nebulis;
    
    /// @dev "density" counts the number of who accounts
    uint public density;
    
    function Whois(address _nebulis) {
        nebulis = _nebulis;
    }
     
    modifier checkWho(address _who) {
        if(_who != accounts[msg.sender]) throw;
        _;
    }
    mapping(address => address) public accounts;
    
    function Genesis(string _name, string _email, string _company) returns(address) {
        if(accounts[msg.sender != address(0x0)]) throw;
        
        address _who = new Who(_name, _email, _company, this, nebulis);
        accounts[msg.sender] = _who;
        density += 1;
        Gen(2, "genesis/user", 0,0, now, msg.sender, _who, 0x0);
        return _who;
    }
    
    function Void(address _who) checkWho(_who) return(bool) {
        if(Who(_who).domains > 0)
            return false;
        address _owner = Who()
        delete accounts[msg.sender];
        density -= 1;
        Void(4, "void/who", now, msg.sender, _who);
        return true;
    }
    
    function whoOwns(bytes16[] _ipa) constant returns(address) {
            address _cluster;
            address _sub1;
            address _sub2;
            address _root;
            address _node;
            address _who;
            
        if(_ipa.length > 1) {
            _cluster = nebulis.clusters[_ipa[1]];
        } else {
            throw;
        }
        
        if (_ipa.length > 2) {
            sub1 = Cluster(_cluster).subclusters[_ipa[2]];
            if(sub1 = address(0x0)) throw;
        } else {
            _root = Cluster(_sub1).root;
            _node = Root(_root).getBranch(_ipa[2][0]);
            _who = Node(_node).getOrigin(_ipa[2]);
            return _who;
        }
        
        if (_ipa.length > 3) {
            sub2 = Cluster(_cluster).subclusters[_ipa[3]];
            if(sub2 = address(0x0)) throw;
            _root = Cluster(_sub2).root;
            _node = Root(_root).getBranch(_ipa[4][0]);
            _who = Node(_node).getOrigin(_ipa[4]);
            return who;
        }
        
        if(_ipa.length > 4) {
            throw;
        }
    }
    
    function whoInfo(address _who) returns(string, string, string) {
        string _name = Who(_who).global.name;
        string _email = Who(_who).global.email;
        string _company = Who(_who).global.company;
        return(_name, _email, _company);
    } 
                
 }