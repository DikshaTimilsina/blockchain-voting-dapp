// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Election} from "../src/Election.sol";

/**
 * Election.t.sol
 *
 * YOU write this file (per the plan) since it exercises your voting logic,
 * but a couple of admin-flow tests are included too since vote() depends on
 * electionOpen being true — that's the coupling point, same as in the contract.
 *
 * Run with: forge test -vv
 */
contract ElectionTest is Test {
    Election election;

    address owner = address(this); // the test contract deploys, so it's the owner
    address voter1 = address(0x1);
    address voter2 = address(0x2);

    function setUp() public {
        string[] memory names = new string[](2);
        names[0] = "Alice";
        names[1] = "Bob";
        election = new Election(names);
    }

    // ============================================================
    // FRIEND: tests for admin logic (owner / startElection / endElection)
    // ============================================================

    function test_OnlyOwnerCanStartElection() public {
        vm.prank(voter1); // pretend voter1 is calling, not the owner
        vm.expectRevert("Not owner");
        election.startElection();
    }

    function test_OwnerCanStartAndEndElection() public {
        election.startElection();
        assertTrue(election.electionOpen());

        election.endElection();
        assertFalse(election.electionOpen());
    }

    // TODO (FRIEND): test that starting an already-open election reverts
    // TODO (FRIEND): test that ending an already-closed election reverts

    // ============================================================
    // YOU: tests for voting logic
    // ============================================================

    function test_VoteWorks() public {
        election.startElection();

        vm.prank(voter1);
        election.vote(0); // vote for Alice

        Election.Candidate[] memory candidates = election.getCandidates();
        assertEq(candidates[0].voteCount, 1);
    }

    function test_CannotVoteTwice() public {
        election.startElection();

        vm.prank(voter1);
        election.vote(0);

        vm.prank(voter1);
        vm.expectRevert("Already voted");
        election.vote(1);
    }

    function test_CannotVoteForInvalidCandidate() public {
        election.startElection();

        vm.prank(voter1);
        vm.expectRevert("Invalid candidate");
        election.vote(99);
    }

    function test_CannotVoteBeforeElectionStarts() public {
        vm.prank(voter1);
        vm.expectRevert("Election not open");
        election.vote(0);
    }

    function test_WinnerIsCorrect() public {
        election.startElection();

        vm.prank(voter1);
        election.vote(1); // Bob

        vm.prank(voter2);
        election.vote(1); // Bob

        assertEq(election.winner(), "Bob");
    }

    // TODO (YOU): test that vote() reverts once electionOpen is false again
    //             (i.e. voting after endElection() was called)
}
