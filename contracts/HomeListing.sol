pragma solidity ^0.4.0;

// @title HomeListing
contract HomeListing {

    struct Home {
        uint id;
        string physicalAddress;
    }

    mapping (address => Home) hostToHome;

    constructor() {

    }


    function addHome(string physicalAddress) public {
        hostToHome[msg.sender] = Home(uint(keccak256(physicalAddress, msg.sender)), physicalAddress);
    }
}
