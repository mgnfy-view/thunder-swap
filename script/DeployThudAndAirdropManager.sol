// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { AirdropManager } from "@src/auxiliary/AirdropManager.sol";
import { Thud } from "@src/governance/Thud.sol";
import { Script } from "forge-std/Script.sol";

contract DeployThudAndAirdropManager is Script {
    function run() external {
        vm.startBroadcast();
        Thud thud = new Thud(1000e18);
        address[] memory supportedTokens;
        supportedTokens[0] = address(thud);
        AirdropManager manager = new AirdropManager(supportedTokens);
        vm.stopBroadcast();
    }
}
