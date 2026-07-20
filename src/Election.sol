// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Election {
    address public owner;
    bool public electionOpen;

    constructor(string[] memory /* names */) {
        owner = msg.sender;
        electionOpen = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function startElection() public onlyOwner {
        require(!electionOpen, "Election already started");
        electionOpen = true;
    }

    function endElection() public onlyOwner {
        require(electionOpen, "Election already ended");
        electionOpen = false;
    }
}