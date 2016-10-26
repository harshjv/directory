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
 
contract simulacra {

/// @dev triggered on element creation. See GEN DOCS
 	event Gen(int typecode,
 			string description,
			bytes32 name,
			bytes32 content,
			uint64 timestamp,
			address owner,
			address location,
			address parent);

/// @dev triggered on permissions change or passing of ownership. See ALT DOCS
 	event Alt(int typecode,
			string description,
			uint64 amount,
			uint64 timestamp,
			address from,
			address to,
			address location,
			bytes32 prev,
			bytes32 overwrite);

/// @dev triggered when content-hashes or blocks are swapped. See SWAP DOCS
 	event Swap(int typecode,
 			uint depth,
 			string description,
 			address from,
 			address to,
 			uint64 blocks,
 			uint64 timestamp,
 			bytes32 prev,
 			bytes32 overwrite);

/// @dev triggered when an element is deleted. See VOID DOCS
 	event Void(int typecode,
			string description,
			uint64 timestamp,
			address owner,
			address location);

}

 		 /**
	 * @dev GEN DOCS.
	 *	Typecodes (int typecode), 1-4, representing: 
	 *		1 = New Domain, 2 = New User, 3 = New Cluster, 4 = New Zone, 5 = New Dust
	 * 
	 * 	if type = 1: id = domain name | content = the content hash | timestamp = (unix time) |
	 *		  owner = who address | location = storage address | parent = cluster address.
	 *
	 *  if type = 2: id = [blank] | content = [blank] |  timestamp = (unix time) |
	 * 		  owner = ethereum account | location = who address | parent = zone address
	 *
	 *  if type = 3: id = cluster domain name | content = content hash | timestamp = (unix time) |
	 * 		  owner = [blank] | location = cluster address | parent = nebulis address
	 *
	 *	if type = 4: id = zone name | content = [blank] | timestamp = (unix time) |
	 * 		  owner = [blank] | location = zone address | parent = nebulis address
	 *
	 *  if type = 5: id = [blank] | content = [blank] | timestamp = (unix time) |
	 * 		  owner = ethereum account | location = [blank] | parent = [blank]
 	 **/



 	 /**
	 * @dev ALT DOCS.
	 *	Typecodes (int typecode) representing:
	 *		1 = Domain transfer, 2 = Dust transaction, 4 = Add guardian, 5 = Remove guardian, 6 = Function fiat
	 *	
	 *	Description (string description) in the format "x/y" where x is the object and y is an action. 
	 *		x(object): domain | cluster | library | zone | nebulis | user
	 *		y(action): transfer | transaction | swap | add | remove | fiat
	 *				EXAMPLES: domain/transfer; user/transaction; zone/add; cluster/fiat.
	 *
	 *  if type = 1 (Domain transfer): description = "x/y" | amount = [blank] | timestamp = (unix time) | 
	 *		from = sending who address | to = recieving who address | location = cluster address | 
	 *		before = domain name | after = [blank]
	 *
	 *	if type = 2 (Dust transaction): description = "x/y" | amount = dust | timestamp = (unix time) |
	 *		from = sending account | to = recieving account | location = [blank] |
	 *		before = [blank] | after = [blank]
	 *
	 *	if type = 3 (Add guardian): description = "x/y" | amount = [blank] | timestamp = (unix time) | 
	 *		from = ethereum account | to = [blank] | location = object address |
	 *		before = [blank] | after = [blank]
	 *
	 *	if type = 4 (Remove guardian): description = "x/y" | amount = [blank] | timestamp = (unix time) |
	 *		from = ethereum account | to = [blank] | location = object address |
	 *		before = [blank] | after = [blank]
	 *
	 *	if type = 5 (Function fiat): description = "x/y" | amount = [blank] | timestamp = (unix time) |
	 *		from = guardian address | to = object address | location = [blank] | 
	 *		before = [blank] | after = [blank]
 	 **/



 	  	/**
	 * @dev SWAP DOCS.
	 *	Typecodes (int typecode) representing:
	 *		1 = Content-hash swap, 2 = Block swap
	 *
	 *  if type = 1 (Content-hash (CH) swap): depth = domain-depth | description = "swap/content" |
	 *		from = who address | to = [blank] | blocks = [blank] | timestamp = (unix time) | before = previous CH | 
	 *		after = new CH
	 *
	 *	if type = 2 (Block swap): from = who address | to = who address | depth = [blank] | description = "swap/block" |
	 * 	 	blocks = number of blocks swapped | timestamp = (unix time) | before = [blank] | after = [blank]
	 *
 	 **/
 
 	 	/**
	 * 	@dev VOID DOCS.
	 *	Typecodes (int typecode) representing:
	 *		1 = Void domain | 2 = Void dust | 3 = Void cluster | 4 = Void account
	 *
	 *	Description (string description) in the format "void/x".
	 *		x(object): domain | dust | cluster | zone
	 *
	 *  if type = 1 (Void domain): description = "void/domain" | timestamp = (unix time) |
	 *	  	owner = who contract | location = storage node
	 *
	 *	if type = 2 (Void dust): description = "void/dust" | timestamp = (unix time) |
	 *		owner = ethereum account | location = [blank]
	 *
	 *	if type = 3 (Void cluster): description = "void/cluster" | timestamp = (unix time) |
	 *		owner = [blank] | location = cluster address
	 *
	 *	if type = 4 (Void account): description = "void/who" | timestamp = (unix time) |
	 *		owner = who owner | location = who address
	 *
 	 **/