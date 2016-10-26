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

 import "Node.sol";
 import "Whois.sol";
 import "Nebulis.sol";

 contract Who {

/// @dev the central nebulis contract
    Nebulis public nebulis;
    
/// @dev the account directory  
    Whois public whois;

/// @dev the owner of the account
    address public owner;

/// @dev the number of deeds
    uint public domains;

/// @dev a singular deed object
    struct Deed {
        address owner;
        address node;
        bytes32 ipa;
        bool publicity;
        bool delegated;
        Contacts contact;
    }

/// @notice contact fields are optional. 
    struct Contact {
        string name;
        string email;
        string company;
    }

/// @dev the global contact field
    Contact public global;

/// @dev the storage mapping which contains all records associated with an account
    mapping(bytes32 => Deed) public deeds;

/// @dev a guardrail to check which denies access to private deeds
    modifier checkIfPublic(_ipa) {
        if(!deeds[_ipa].publicity) throw;
        _;
    }

/// @dev checks that only the owner of a deed can access
    modifier checkOnlyOwner(_ipa) {
        if(msg.sender != deeds[_ipa].owner) throw;
        _;
    }

/// @dev The constructor
    function Who(address _nebulis, 
                string _name,
                string _email,
                string _company,
                address _whois,
                address _nebulis) {
                    
        global.name = _name;
        global.email = _email;
        global.company = _company;
        
        nebulis = Nebulis(_nebulis);
        whois = Whois(_whois);
    }

/// @dev method to add a deed to the record
    function add(address _node,
                address _owner,
                bytes32 _ipa,
                bool _public,
                string _name,
                string _email,
                string _company) returns(bool) {

// instead of a modifier, 
        if(nebulis.clusters[_clusters] != msg.sender 
        || (!whois.valid[msg.sender])) {
            throw;
        }

            Deed deed;

            deed.owner = _owner;
            deed.node = _node;
            deed.ipa = _ipa;
            deed.publicity = _public;
            if(_delegated == true) {
                deed.contact.name = _name;
                deed.contact.email = _email;
                deed.contact.company = _company;
            }
            deed.contact.name = global.name;
            deed.contact.email = global.email;
            deed.contact.company = global.company;

            deeds[_ipa] = deed;
            domains += 1;
        }

    function transfer(bytes32 _ipa, bytes32 _domain, address _to) checkOnlyOwner returns(bool) {
        address _owner = deeds[_ipa].owner;
        address _node = deeds[_ipa].node;
        bytes32 _ipa = deeds[_ipa].ipa;
        bool _publicity = deeds[_ipa].publicity;
        bool _delegated = deeds[_ipa].delegated;

        delete deeds[_ipa];

        domains -= 1;
    
        if(!Node(_node).setOrigin(_domain, _to)) 
            throw;

        if(!Who(_to).add(_node, _owner, _ipa, _publicity, _delegated, "", "","")) 
            throw;

        return true;
    }

    function eject(bytes32 _ipa) checkOnlyOwner(_ipa) returns(bool) {
        address _node = deeds[_ipa].node;
        delete deed[_ipa];
        domains -= 1;
        if(!Node(_node).voidInventory(_ipa)) 
            throw;
            
        return true;

    }

    function setCredentials(bool _global, bytes32 _ipa, string _name, 
                                string _email, string _company) checkOnlyOwner(_ipa) {
        if(_global) {
            global.name = _name;
            global.email = _email;
            global.company = _company;
        } else {
            Contact contact;
            contact.name = _name;
            contact.email = _email;
            contact.company = _company;
            deeds[_ipa].contact = contact;
        }
    }

    function getCredentials(bytes32 _ipa) checkIfPublic(_ipa) returns(string,string,string) {
        return(deeds[_ipa].contact.name,
                deeds[_ipa].contact.email,
                deeds[_ipa].contact.company);
    }

 }