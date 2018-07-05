pragma solidity ^0.4.21;

// @title HomeListing
contract HomeListing {

    struct Home {
        uint id;
        string physicalAddress;
    }
    Home [] public homes;
    mapping (address => Home) hostToHome;
    event HomeEvent(uint _id, string _physicalAddress);
    constructor() {

    }

    // @param physicalAddress - the actual address of the home a host wants to list (not the ethereum address)
    function addHome(string _physicalAddress) public {
        uint _id = uint(keccak256(_physicalAddress, msg.sender));
        Home memory home = Home(_id, _physicalAddress);
        hostToHome[msg.sender] = home;
        homes.push(home);
        HomeEvent(_id, _physicalAddress);
    }

    // @param physicalAddress - the actual address of the home a host wants to list (not the ethereum address)
    // @return _id - list of ids for homes
    function listHomesByAddress(string _physicalAddress) public returns(uint [] _id ) {
        uint [] results;
        for(uint i = 0 ; i<homes.length; i++) {
            if(keccak256(homes[i].physicalAddress) == keccak256(_physicalAddress)) {
                results.push(homes[i].id);
            }
        }
        HomeEvent(results);
        return results;

    }
}
