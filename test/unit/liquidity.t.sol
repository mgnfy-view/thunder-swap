// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test } from "forge-std/Test.sol";
import { Init } from "../utils/helpers/Init.sol";

contract TestLiquidity is Test, Init {
    function testAddInitialLiquidity() public {
        vm.startPrank(deployer);
        tokenA.approve(address(thunderSwapPool), 1e18);
        tokenB.approve(address(thunderSwapPool), 2e18);
        thunderSwapPool.addLiquidity(1e18, 2e18, 2e18, 1e18, uint256(block.timestamp));
        vm.stopPrank();

        assertEq(thunderSwapPool.getTotalLiquidityProviderTokenSupply(), 1e18);
        assertEq(thunderSwapPool.getLiquidityProviderToken().balanceOf(deployer), 1e18);
        assertEq(tokenA.balanceOf(address(thunderSwapPool)), 1e18);
        assertEq(tokenB.balanceOf(address(thunderSwapPool)), 2e18);
    }
}
