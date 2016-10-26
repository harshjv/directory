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
import "Cluster.sol";

/// @title NB0
/// @author Physes
/// @dev an action-oriented contract whereby governance decisions can be made and implemented

contract Own {

/// @dev the address of the cluster
    address public cluster;
/// @dev the curator of the cluster, has the ability to enact governance 
    address[] public curators;
/// @dev a one-way counter of ordinances in the cluster
    uint public ordinances;

/// @dev a proposal struct which 
    struct ordinance {
    // the title of the ordinance
        string title;
    // every ordinance is numbered from 1
        uint number;
    // the quorum is unanimous- i.e. the number of curators for the cluster  
        uint quorum;
    // when a curator votes their address is added to ensure no repeats
        address[] voted;
    // the method the ordinance will enact when ratified
        bytes32 method;
    // a boolean, whether the ordinance was accepted or not
        bool ratified;
    }

/// @dev only a single proposal can be tabled at any one time
    ordinance public todo;

/// @dev the history of successful proposals
    mapping(uint => ordinance) public history;

/// @dev a modifier to ensure that only a curator can implement a particular function
    modifier checkIfCurator {
        bool found;
        for(uint i = 0; i < curators.length; i++) {
            if(msg.sender = curators[i])
                found = true;
                break;
        }
        if(!found) throw;
        _;
    }

/// @dev the constructor
/// @param _curators | an address array of curators
    function Curated(address[] _curators, address _child) {
        for(uint i = 0; i < _curators.length; i++) {
            curators[].push(_curators[i]);
        }

        cluster = msg.sender;
    }

/// @dev a method whereby a curator can table an ordinance
/// @param _title | the name of the ordinance
/// @param _method | the 
    function tableOrdinance(string _title, string _method) checkIfCurator returns(bool) {
//  check first to make sure there are not any ordinances already tabled
        if(todo.number != 0) throw;

//  increment the ordinances count
        ordinances += 1;

//  fill out struct fields
        todo.title = _title;
        todo.number = ordinances;
        todo.quorum = curators.length;
        todo.voted.push(msg.sender);
        todo.method = _method;
        todo.ratified = false;

        return true;
    }

/// @param _vote | true or false vote on the tabled ordinance

    function ratifyOrdinance(bool _vote) checkIfCurator returns(bool) {
//  check that the curator hasn't already voted
        for(uint i = 0; i < curators.length; i++) {
            if(todo.voted[i] = msg.sender)
                throw;
        }
    if(_vote == true) {
        too.voted.push(msg.sender);

        if(todo.quorum == todo.voted) {
            todo.ratified = true;
        }
    } else {
// if the vote is false, then the ordinance is automatically binned
        history[ordinance] = todo;
// clear the todo fields, simply reset the number to zero which allows another ordinance to be tabled
        todo.number = 0;
    }
        return true;
    }

/// @dev enactOrdinance only works if the todo.ratified bool is set to true
/// @params params | the number of parameters for the method to be deployed
    function enactOrdinance(uint _params, 
                            string _one, 
                            string _two,
                            string _three) checkIfCurator returns(bool) {
//  ensure that the ordinance has been ratified
        if(todo.ratified != true)
            throw;

        if(params = 1)
            return bytes4(sha3(todo.method), _one); 
        if(params = 2)
            return bytes4(sha3(todo.method), _one, _two);
        if(params = 3)
            return bytes4(sha3(todo.method), _one, _two, _three);

        history[ordinances] = todo;
        todo.number = 0;
    }

/// @dev private function to add a curator to the curators array
//  both addcurator and removecurator can only be implemented via a 
    function addCurator(address _curator) private returns(address[]) {
        curators.push(_curator);
        return curators;
    }

/// @dev private function to remove a curator
    function removeCurator(address _curator) private returns(bool) {
        for(uint i = 0; i < curators.length; i++) {
            if(_curator = _curators[i]) {
                delete curators[i];
                for(uint j = i; j < curators.length-1; j++) {
                    curators[j] = curators[j+1];
                }
                curators.length--;
                break;
            } else {
                return false;
            }
        }
        return true;
    }
}
