// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { AirdropManager } from "@src/auxiliary/AirdropManager.sol";

import { Thud } from "@src/governance/Thud.sol";
import { Test } from "forge-std/Test.sol";

contract AirdropManagerHelper is Test {
    address public owner;
    address public user1;
    address public user2;
    address[] public supportedTokens;
    address[] public recipients;
    uint256[] public amounts;
    uint256 public initialThudSupply;
    AirdropManager public airdropManager;
    Thud public thud;

    error LimitBreached(uint256 numberOfRecepients, uint256 allowedNumberOfRecepients);
    error TokenAlreadySupported();
    error InsufficientTokenBalance();

    event TokenSupported(address token);
    event TokensAirdropped(address token, uint256 totalAmount);

    function setUp() public {
        owner = makeAddr("owner");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        initialThudSupply = 1000e18;

        vm.startPrank(owner);
        thud = new Thud(initialThudSupply);
        supportedTokens.push(address(thud));
        airdropManager = new AirdropManager(supportedTokens);
        vm.stopPrank();
    }
}
