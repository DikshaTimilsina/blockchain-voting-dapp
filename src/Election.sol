// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Election.sol
 *
 * Ownership split (per team plan):
 *  - FRIEND writes: owner, electionOpen, onlyOwner modifier, constructor,
 *                    startElection(), endElection()
 *  - YOU write:      Candidate struct, candidates array, hasVoted mapping,
 *                    vote(), getCandidates(), winner(), VoteCast event
 *
 * WORKFLOW: Friend implements + commits their section FIRST (it defines the
 * state variables everyone else needs). You `git pull`, then add your section.
 */
contract Election {

    // ============================================================
    // FRIEND: election management / access control
    // ============================================================

    address public owner;
    bool public electionOpen;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    event ElectionStateChanged(bool open);

    /// @param candidateNames initial list of candidate names, set at deploy time
    constructor(string[] memory candidateNames) {
        owner = msg.sender;

        // NOTE: this loop pushes into `candidates`, which is YOUR array below.
        // Because Solidity doesn't care about "who owns" a variable, this is
        // the one place where the two sections are coupled — keep it here so
        // it's obvious at a glance, and mention this coupling when you two
        // explain the contract to each other.
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate(candidateNames[i], 0));
        }
    }

    function startElection() external onlyOwner {
        require(!electionOpen, "Already open");
        electionOpen = true;
        emit ElectionStateChanged(true);
    }

    function endElection() external onlyOwner {
        require(electionOpen, "Already closed");
        electionOpen = false;
        emit ElectionStateChanged(false);
    }

    // ============================================================
    // YOU: voting logic
    // ============================================================

    struct Candidate {
        string name;
        uint voteCount;
    }

    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    event VoteCast(address indexed voter, uint candidateIndex);

    /// @notice Cast a vote for a candidate by index.
    function vote(uint candidateIndex) external {
        require(electionOpen, "Election not open");
        require(!hasVoted[msg.sender], "Already voted");
        require(candidateIndex < candidates.length, "Invalid candidate");

        hasVoted[msg.sender] = true;
        candidates[candidateIndex].voteCount++;

        emit VoteCast(msg.sender, candidateIndex);
    }

    /// @notice Returns all candidates and their current vote counts.
    function getCandidates() external view returns (Candidate[] memory) {
        return candidates;
    }

    /// @notice Returns the name of the candidate with the most votes.
    /// KNOWN LIMITATION (mention this in your README): ties are broken by
    /// picking the lowest index, i.e. whoever was added first wins a tie.
    function winner() external view returns (string memory) {
        require(candidates.length > 0, "No candidates");

        uint winningIndex = 0;
        for (uint i = 1; i < candidates.length; i++) {
            if (candidates[i].voteCount > candidates[winningIndex].voteCount) {
                winningIndex = i;
            }
        }
        return candidates[winningIndex].name;
    }
}
