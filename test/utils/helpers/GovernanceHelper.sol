// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { AirdropManager } from "@src/auxiliary/AirdropManager.sol";
import { ThunderSwapPoolFactory } from "@src/core/ThunderSwapPoolFactory.sol";
import { Thud } from "@src/governance/Thud.sol";
import { ThunderGovernor } from "@src/governance/ThunderGovernor.sol";
import { ThunderTimeLock } from "@src/governance/ThunderTimelock.sol";
import { Test } from "forge-std/Test.sol";

contract GovernanceHelper is Test {
    Thud public thud;
    ThunderTimeLock public timelock;
    ThunderGovernor public governor;
    ThunderSwapPoolFactory public thunderSwapPoolFactory;
    AirdropManager public airdropManager;
    uint256 constant INITIAL_SUPPLY = 1000e18;
    uint256 public constant MIN_DELAY = 3600;
    uint256 public constant QUORUM_PERCENTAGE = 4;
    uint256 public constant VOTING_PERIOD = 50400;
    uint256 public constant VOTING_DELAY = 7200;
    address[] public supportedTokens;
    address[] proposers;
    address[] executors;
    bytes[] functionCalls;
    address[] addressesToCall;
    uint256[] values;
    address[] airdropUsers;
    uint256[] airdropAmounts;
    address public deployer;
    address public user1;

    function setUp() public {
        deployer = makeAddr("deployer");
        user1 = makeAddr("user1");

        vm.startPrank(deployer);
        thunderSwapPoolFactory = new ThunderSwapPoolFactory();
        thud = new Thud(INITIAL_SUPPLY);
        supportedTokens.push(address(thud));
        airdropManager = new AirdropManager(supportedTokens);
        thud.transfer(address(airdropManager), INITIAL_SUPPLY);
        timelock = new ThunderTimeLock(MIN_DELAY, proposers, executors);
        governor = new ThunderGovernor(thud, timelock);

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();

        timelock.grantRole(proposerRole, address(governor));
        timelock.grantRole(executorRole, address(0));

        thunderSwapPoolFactory.transferOwnership(address(timelock));
        vm.stopPrank();
    }

    modifier airdrop(address _user, uint256 _amount) {
        airdropUsers.push(_user);
        airdropAmounts.push(_amount);
        vm.prank(deployer);
        airdropManager.airdrop(airdropUsers, airdropAmounts, 0);
        _;
    }
}
