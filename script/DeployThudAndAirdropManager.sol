// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { AirdropManager } from "@src/auxiliary/AirdropManager.sol";
import { Thud } from "@src/governance/Thud.sol";
import { Script } from "forge-std/Script.sol";

contract DeployThudAndAirdropManager is Script {
    address[] public supportedTokens;

    function run() external {
        uint256 initialSupply = 1000e18;

        vm.startBroadcast();
        Thud thud = new Thud(initialSupply);
        supportedTokens.push(address(thud));
        AirdropManager airdropManager = new AirdropManager(supportedTokens);
        vm.stopBroadcast();
    }
}
