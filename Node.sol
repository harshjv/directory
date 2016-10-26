import "Simulacra.sol";

contract Node is Simulacra {

    address public cluster;
    
    bytes1 public index;

    uint public mass;
    
    uint public depth;

    struct Leaf {
        bytes32 domain;
        address who;
        bool publicity;
        uint gravity;
        uint ext;
        mapping(bytes8 => Content) redirect;
    }
    
    struct Content {
        bytes32 content;
        mapping(bytes32 => bytes32) outerdomains;
    }


    mapping(bytes32 => Leaf) inventory;

    modifier checkIfOrigin(bytes32 _domain) {
        address _who = inventory[_domain].who;
        if(msg.sender != _who) throw;
        _;
    }

    modifier checkIfPublic(bytes32 _domain) {
        if(!inventory[_domain].publicity) throw;
        _;
    }
    
    modifier checkOnlyCluster {
        if(msg.sender != cluster) throw;
        _;
    }
     
    function Node(address _cluster, bytes1 _index) {
        cluster = _cluster;
        index = _index;
    }

    function setInventory(bytes32 _domain,
                address _who, 
                bool _publicity,
                uint _gravity,
                uint _ext,
                bytes8 _ox,
                bytes32 _content) checkOnlyCluster returns(bool) {
        if(inventory[_domain].who != address(0x0)) throw;
        
        Leaf leaf = inventory[_domain];
        
        leaf.domain = _domain;
        leaf.who = _who;
        leaf.gravity = _gravity;
        leaf.ext = _ext;
        leaf.redirect[_ox].content = _content;
        
        inventory[_domain] = leaf;
        
        
        mass += 1;
        Gen(1, "new/domain", _domain, _content, uint64(now), _who, this, cluster);

        return true;
    }

    function getInventory(bytes32 _domain, bytes8 _ox) constant 
                                checkIfPublic(_domain) returns(bytes32, address, uint) {
        
        bytes32 _content = inventory[_domain].redirect[_ox].content;
        address _who = inventory[_domain].who;
        uint _gravity = inventory[_domain].gravity;

        return(_content, _who, _gravity);
    }

    function voidInventory(bytes32 _domain) checkIfOrigin(_domain) returns(bool) {
        address _who = inventory[_domain].who;
        delete inventory[_domain];
        mass -= 1;
        
        Void(1, "void/domain", uint64(now), _who, this);
        return true;
    }

    function setOuterDomain(bytes8 _ox, 
                    bytes32 _domain, 
                    bytes32 _outer, 
                    bytes32 _redirect) checkIfOrigin(_domain) returns(bool) {
        
        bytes32 _old = 0;

        if(inventory[_domain].redirect[_ox].outerdomains[_outer] != 0) {
            _old = inventory[_domain].redirect[_ox].outerdomains[_outer];
        }
        
        uint _ext = inventory[_domain].ext;

        if(parser.len(_outer) > _ext) throw;

        address _who = inventory[_domain].who;

        inventory[_domain].redirect[_ox].outerdomains[_outer] = _redirect;
        Swap(1, depth + 1, "swap/content", _who, 0x0, 0, uint64(now), _old, _outer);
        return true;
    }

    function getOuterDomain(bytes8 _ox, 
                    bytes32 _domain, 
                    bytes32 _outer) checkIfPublic(_domain) constant returns(bytes32) {
        return inventory[_domain].redirect[_ox].outerdomains[_outer];
    }

    function voidOuterDomain(bytes8 _ox, 
                    bytes32 _domain, 
                    bytes32 _outer) checkIfOrigin(_domain) returns(bool) {
        if(inventory[_domain].redirect[_ox].outerdomains[_outer] == 0) {
            return false;
        }
        address _who = inventory[_domain].who;
        delete inventory[_domain].redirect[_ox].outerdomains[_outer];
        Void(1, "void/domain", uint64(now), _who, this);
        return true;
    }

    function setRedirect(bytes8 _ox, 
                    bytes32 _domain, 
                    bytes32 _redirect) checkIfOrigin(_domain) returns(bool) {
        bytes32 _old = inventory[_domain].redirect[_ox].content;
        address _who = inventory[_domain].who;
        inventory[_domain].redirect[_ox].content = _redirect;
        Swap(1, depth, "swap/content", _who, 0x0, 0, uint64(now), _old, _redirect);
        return true;
    }

    function getRedirect(bytes8 _ox, 
                    bytes32 _domain) checkIfPublic(_domain) returns(bytes32) {
        return inventory[_domain].redirect[_ox].content;
    }

    function setOrigin(bytes8 _ox,
                    bytes32 _domain,
                    address _transfer) checkIfOrigin(_domain) returns(bool) {
        if(inventory[_domain].who == _transfer)
            return false;
        inventory[_domain].who == _transfer;
        Alt(1, "domain/transfer", 0, uint64(now), msg.sender, _transfer, cluster, _domain, 0);
        return true;
    }

    function getOrigin(bytes32 _domain) constant checkIfPublic(_domain) returns(address){
        return inventory[_domain].who;
    }
    
    function setPublicity(bytes32 _domain,
                    bool _publicity) checkIfOrigin(_domain) returns(bool) {
        if(inventory[_domain].publicity == _publicity)
            return false;
        inventory[_domain].publicity == _publicity;
        return true;
    }

    function getPublicity(bytes32 _domain) constant returns(bool) {
        return inventory[_domain].publicity;
    }
}