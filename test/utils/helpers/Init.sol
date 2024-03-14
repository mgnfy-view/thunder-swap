// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test } from "forge-std/Test.sol";
import { ThunderSwapPoolFactory } from "@src/ThunderSwapPoolFactory.sol";
import { ThunderSwapPool } from "@src/ThunderSwapPool.sol";
import { TokenA } from "../mocks/TokenA.sol";
import { TokenB } from "../mocks/TokenB.sol";

contract Init is Test {
    address public deployer;
    TokenA public tokenA;
    TokenB public tokenB;
    ThunderSwapPoolFactory public thunderSwapPoolFactory;
    ThunderSwapPool public thunderSwapPool;

    function setUp() public {
        deployer = makeAddr("deployer");

        vm.startPrank(deployer);
        tokenA = new TokenA(100e18);
        tokenB = new TokenB(100e18);
        thunderSwapPoolFactory = new ThunderSwapPoolFactory();
        thunderSwapPoolFactory.setSupportedToken(address(tokenA));
        thunderSwapPoolFactory.setSupportedToken(address(tokenB));
        thunderSwapPool = thunderSwapPoolFactory.deployThunderSwapPool(address(tokenA), address(tokenB));
        vm.stopPrank();
    }
}