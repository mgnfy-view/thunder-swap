// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {ThunderSwapPoolFactory} from "@src/ThunderSwapPoolFactory.sol";

contract DeployThunderSwapPoolFactory is Script {
    function run() external {
        vm.startBroadcast();
        ThunderSwapPoolFactory thunderSwapPoolFactory = new ThunderSwapPoolFactory();
        vm.stopBroadcast();
    }

}