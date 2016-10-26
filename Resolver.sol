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

import "nebulis.sol";
import "parser.sol";
import "root.sol";
import "node.sol";

	/**
	 * This contract is a generic resolver for getting back content hashes and other information
	 **/
contract resolver {
	
	using parser for *;


	nebulis public neb;

	/**
	 * @dev a function to get back a resource if the specified domain exists in nebulis
	 * only works for three-part domains- the ox, cd, and id. Queries must be of the form
	 * <scheme>.<cluster>.<domain>. even though officially the domain format is <scheme><cluster>.<domain>
	 * For outer-domain resolution use the GetOuter() method.
	 **/

	function Get(bytes32 _domain) public returns(bytes32) {

//	first break the query into constituent parts
	var(_ox, _cd, _id) = Delimit(_domain, 3);
//  get the dex of the first index of the string
	uint _dex = Dexify(_id, 0);
	
	address _cluster = Nebulis(nebulis).getCluster(_cd);
//	check that the cluster did not return a zero address
	if(_cluster != 0x0) 
		address _root = Cluster(_cluster).getRoot();
//	check that the root did not return a zero address
	if(_root != 0x0) 
		address _node = Root(_root).getBranch(_dex); 
//  at the last step of the query, throw if _node is a zero address
	if(_node != 0x0) {
		return Node(_node).getRedirect(_domain);
		} else {
			throw;
		}
	}

/// @dev return the content for the cluster domain
/// @param clusterdomain | the string
	function GetCluster(bytes32 _clusterdomain) private returns(bytes32) {
		address _cluster = Nebulis(nebulis).getCluster(_clusterdomain);
		return Cluster(_cluster).getMaster();
	}

/// @dev the the outer-most domain available
	function GetOuter(bytes32 _domain, bytes32 _outer) public returns(bytes32) {
		var(_ox, _cd, _id) = Delimit(_domain, 3);
		uint _dex = Dexify(_id, 0);

		address _cluster = Nebulis(nebulis).cluster[_clusterdomain];
		if(_cluster != 0x0) 
			address _root = Cluster(_cluster).getRoot();
		if(_root != 0x0) 
			address _node = Root(_root).getBranch(_dex);
		if(_node != 0x0) 
			address _who = Node(_node).getOrigin(_domain);
		if(_who != 0x0) {
			return Who(_who).getOuter(_outer);
		} else {
			throw;
		}
	}
}