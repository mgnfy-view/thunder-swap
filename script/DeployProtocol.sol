// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { AirdropManager } from "@src/auxiliary/AirdropManager.sol";
import { ThunderSwapPoolFactory } from "@src/core/ThunderSwapPoolFactory.sol";
import { Thud } from "@src/governance/Thud.sol";
import { ThunderGovernor } from "@src/governance/ThunderGovernor.sol";
import { ThunderTimeLock } from "@src/governance/ThunderTimelock.sol";
import { Script } from "forge-std/Script.sol";

contract DeployProtocol is Script {
    address[] public supportedTokens;
    Thud public thud;
    AirdropManager public airdropManager;
    ThunderTimeLock public timelock;
    ThunderGovernor public governor;
    ThunderSwapPoolFactory public thunderSwapPoolFactory;
    uint256 constant INITIAL_SUPPLY = 1000e18;
    uint256 public constant MIN_DELAY = 3600; // 1 hour - after a vote passes, you have 1 hour before you can enact
    uint256 public constant QUORUM_PERCENTAGE = 4; // Need 4% of voters to pass
    uint256 public constant VOTING_PERIOD = 50400; // This is how long voting lasts
    uint256 public constant VOTING_DELAY = 7200; // How many blocks till a proposal vote becomes active
    address[] proposers;
    address[] executors;

    function run()
        external
        returns (ThunderSwapPoolFactory, Thud, AirdropManager, ThunderTimeLock, ThunderGovernor)
    {
        vm.startBroadcast();
        thunderSwapPoolFactory = new ThunderSwapPoolFactory();
        thud = new Thud(INITIAL_SUPPLY);
        supportedTokens.push(address(thud));
        airdropManager = new AirdropManager(supportedTokens);
        timelock = new ThunderTimeLock(MIN_DELAY, proposers, executors);
        governor = new ThunderGovernor(thud, timelock);

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();

        timelock.grantRole(proposerRole, address(governor));
        timelock.grantRole(executorRole, address(0));

        thunderSwapPoolFactory.transferOwnership(address(timelock));
        vm.stopBroadcast();

        return (thunderSwapPoolFactory, thud, airdropManager, timelock, governor);
    }
}
