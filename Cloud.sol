/***************************************************************************
    
    Copyright (c) 2016-2018  |  Nebulis Foundation

    Released under The MIT Licence.

    All rights reserved. This software is subject to updates, and is provided 
    without warranty of any kind, express or implied. Use at own risk.

    Permission is hereby granted to any person obtaining copy of this software 
    and associated documentation to use, copy, merge, publish and distribute 
    this software without restriction or charge.

 **************************************************************************/

   /**
     * The cloud contract is owned by a cluster, and allows curators to subjectively set the supply
     * and demand prices for domain creations.
     **/

contract Cloud {
    
//  the total balance of dust available
    uint public cloudBal;

//  the available supply of Ether
    uint public etherBal;

/// @dev supplyPrice: the selling price (in wei) for 1 micron
    uint public supplyPrice;
    
/// @dev demandPrice: the asking price (in wei) for 1 micron
    uint public demandPrice;

    Dust public dust;
    
    Cluster public cluster;

    function Cloud(uint _cloudBal, address _cluster) {
        cloudBal = _cloudBal;
//  the owning cluster
        cluster = Cluster(_cluster);
        dust = Dust(msg.sender);
    }
    
    function setDemandPrice(uint _demandPrice) checkOnlyCurated {
        dust.cloudInfo[this].demandPrice;
    }
    

    function setSupplyPrice(uint _supplyPrice) checkOnlyCurated {
        dust.cloudInfo[this].supplyPrice;
    }
    
/// @dev the acquire function allows anyone to buy dust from this cloud 
//  at the specified demandPrice.

    function acquire() payable returns(bool){
        
        uint _micronsDemanded = msg.value / supplyPrice;
        
        if(_micronsDemanded >= cloudBal) 
            throw;
        
        cloudBal -= _micronsDemanded;
        etherBal += msg.value;
        
        if(!dust.transfer(this, msg.sender, _micronsDemanded)) {
            cloudBal += _micronsDemanded;
            etherBal -= _micronsDemanded;
            msg.sender.send(msg.sender);
            return false;
        };
    
        return true;
    }
    
/// @dev the dispose function allows anyone to sell dust back to a cloud and recieve ether
    
    function dispose(uint _dust) payable returns(bool) {

        if(_cloudBal < _dust) 
            throw;
        
        etherBal += msg.value;
        
        dust.transfer(msg.sender, )
        Alt(2, "dust/transaction", _dust, now, msg.sender, this, this,0,0);
        if(!msg.sender.send(_dust * demandPrice))
            throw;
    }
    
    function withdraw(uint _dust) checkOnlyCurators returns(bool) {
        if(_dust % 1024 != 0) throw;
        if(_dust >= dust.userBal[this]) throw;
        var amount = dust.userBal[this];
        if(amount > 0) {
            dust.userBal[this] -= _dust;
            if(!msg.sender.send(_dust)) {
                dust.userBal[this] = amount;
                return false;
            }
        }
        return true;
    }
    
    
}