// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Election} from "../src/Election.sol";

contract DeployElection is Script {
    function run() external {
        string[] memory names = new string[](2);
        names[0] = "Alice";
        names[1] = "Bob";

        vm.startBroadcast();

        new Election(names);

        vm.stopBroadcast();
    }
}