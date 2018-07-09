pragma solidity ^0.4.21;

import "./StringUtils.sol";

// @title HomeListing
contract HomeListing {

    struct Home {
        uint id;
        string physicalAddress;
        address owner;
        uint rent;
        bool available;
    }
    Home[] public homes;
    mapping (uint => Home) idToHome;
    event HomeEvent(uint _id);
    uint[]  results;

    modifier onlyHost(uint _id) {
        require(msg.sender == idToHome[_id].owner);
        _;
    }

    // @param physicalAddress - the actual address of the home a host wants to list (not the ethereum address)
    function addHome(string _physicalAddress, uint rent) public {
        uint _id = uint(keccak256(_physicalAddress, msg.sender));
        Home memory home = Home(_id, _physicalAddress, msg.sender, rent, true);
        idToHome[_id] = home;
        homes.push(home);
    }

    // @param _id - id of the home being edited
    // @param _price - new price of the home
    function updateRent(uint _id, uint _rent)  public onlyHost(_id) {
        // update home
        Home storage home =  idToHome[_id];
        home.rent = _rent;

        for(uint i = 0 ; i<homes.length; i++) {
            if(i == _id) {
                homes[i].rent =  _rent;
            }
        }
    }

    // @param physicalAddress - the actual address of the home a host wants to list (not the ethereum address)
    // @return _id - list of ids for homes
    function listHomesByAddress(string _physicalAddress) public view returns(uint[] ) {
        for(uint i = 0 ; i<homes.length; i++) {
            string location = homes[i].physicalAddress;
            if(StringUtils.equal(location, _physicalAddress )) {
                results.push(homes[i].id);
            }
        }
        return results;
    }

    function bookHome(uint _id) public  payable{
        require(msg.value>=idToHome[_id].rent);
        if (idToHome[_id].available) {
            idToHome[_id].owner.transfer(idToHome[_id].rent);
            idToHome[_id].available = false;
        }
    }
}
