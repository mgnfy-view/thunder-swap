// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { ThunderSwapPoolFactory } from "@src/core/ThunderSwapPoolFactory.sol";
import { Script } from "forge-std/Script.sol";

contract DeployThunderSwapPoolFactory is Script {
    function run() external {
        vm.startBroadcast();
        ThunderSwapPoolFactory thunderSwapPoolFactory = new ThunderSwapPoolFactory();
        vm.stopBroadcast();
    }
}
