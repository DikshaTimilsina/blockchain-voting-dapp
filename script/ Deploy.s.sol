// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// FRIEND: this file is yours (deployment, per the plan).

import {Script, console} from "forge-std/Script.sol";
import {Election} from "../src/Election.sol";

contract DeployElection is Script {
    function run() external returns (Election) {
        // Edit these candidate names before deploying.
        string[] memory names = new string[](3);
        names[0] = "Alice";
        names[1] = "Bob";
        names[2] = "Charlie";

        vm.startBroadcast();
        Election election = new Election(names);
        vm.stopBroadcast();

        console.log("Election deployed at:", address(election));
        return election;
    }
}

/*
 * HOW TO RUN:
 *
 * Local (Anvil):
 *   1. In one terminal: anvil
 *   2. In another:
 *      forge script script/Deploy.s.sol:DeployElection \
 *        --rpc-url http://127.0.0.1:8545 \
 *        --private-key <ANVIL_PRIVATE_KEY> \
 *        --broadcast
 *
 * Sepolia:
 *   forge script script/Deploy.s.sol:DeployElection \
 *     --rpc-url $SEPOLIA_RPC_URL \
 *     --private-key $PRIVATE_KEY \
 *     --broadcast \
 *     --verify \
 *     --etherscan-api-key $ETHERSCAN_API_KEY
 *
 * After deploying:
 *   - Copy the printed contract address into frontend/src/utils/contract.js
 *   - Copy the ABI from out/Election.sol/Election.json into the same file
 */
