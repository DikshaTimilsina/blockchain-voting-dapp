// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Election} from "../src/Election.sol";

contract ElectionTest is Test {
    Election election;

    address owner = address(this);
    address user = address(0x1);

    function setUp() public {
        string[] memory names = new string[](2);
        names[0] = "Alice";
        names[1] = "Bob";

        election = new Election(names);
    }

    // ============================================================
    // Owner Tests
    // ============================================================

    function test_OwnerIsSetCorrectly() public {
        assertEq(election.owner(), owner);
    }

    function test_OnlyOwnerCanStartElection() public {
        vm.prank(user);
        vm.expectRevert("Not owner");
        election.startElection();
    }

    function test_OwnerCanStartElection() public {
        election.startElection();
        assertTrue(election.electionOpen());
    }

    function test_OnlyOwnerCanEndElection() public {
        election.startElection();

        vm.prank(user);
        vm.expectRevert("Not owner");
        election.endElection();
    }

    function test_OwnerCanEndElection() public {
        election.startElection();
        election.endElection();

        assertFalse(election.electionOpen());
    }

    function test_CannotStartElectionTwice() public {
        election.startElection();

        vm.expectRevert("Election already started");
        election.startElection();
    }

    function test_CannotEndElectionTwice() public {
        election.startElection();
        election.endElection();

        vm.expectRevert("Election already ended");
        election.endElection();
    }
}