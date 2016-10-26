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

contract ox {

    address nebulis;
    uint heap; // where spare dust is stored

    mapping(uint => address) Queue;
    mapping(address => uint) BalanceOf;

    function Ox(address _nebulis) {
        nebulis = _nebulis;
    }


    function addToHeap(uint _amount) internal {
        heap += _amount;
    }

    function claimHeap() {
        if(heap > 0 && rewards[block.number] == 0) {
            BalanceOf[block.coinbase] += heap;
            heap = 0;
            Queue[block.number] = block.coinbase;
        }
    }

    function Withdraw(address _who, uint _zone) returns(bool) {
        if(BalanceOf[msg.sender] > 0) {
            if(Nebulis(nebulis).checkWho(_zone, _who) == true) {
                Who(_who).deposit(BalanceOf[msg.sender]);
                delete BalanceOf[msg.sender];
                return true;
            } else {
                return false;
            }
        }
    }

}
}