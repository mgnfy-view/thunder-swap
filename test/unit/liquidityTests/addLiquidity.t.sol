// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test } from "forge-std/Test.sol";
import { Init } from "../../utils/helpers/Init.sol";

contract TestAddingLiquidity is Test, Init {
    function testAddInitialLiquidity() public distributeTokensToUsers(1e18, 2e18) addInitialLiquidity(1e18, 2e18) {
        uint256 poolToken1Amount = 1e18;
        uint256 poolToken2Amount = 2e18;

        assertEq(thunderSwapPool.getTotalLiquidityProviderTokenSupply(), poolToken1Amount);
        assertEq(thunderSwapPool.getLiquidityProviderToken().balanceOf(deployer), poolToken1Amount);
        assertEq(tokenA.balanceOf(address(thunderSwapPool)), poolToken1Amount);
        assertEq(tokenB.balanceOf(address(thunderSwapPool)), poolToken2Amount);
    }

    function testaddingLiquidityFailsIfInputTokenAmountIsZero() public {
        vm.startPrank(user1);
        vm.expectRevert(InputValueZeroNotAllowed.selector);
        thunderSwapPool.addLiquidity(0, 0, 0, 0, uint256(block.timestamp) - 1);
        vm.stopPrank();
    }

    function testAddingLiquidityFailsIfDeadlineHasPassed() public distributeTokensToUsers(1e18, 2e18) {
        uint256 poolToken1Amount = 1e18;
        uint256 poolToken2Amount = 1e18;

        vm.startPrank(user1);
        tokenA.approve(address(thunderSwapPool), poolToken1Amount);
        tokenB.approve(address(thunderSwapPool), poolToken2Amount);
        vm.warp(1 days);
        uint256 deadline = uint256(block.timestamp) - 10;
        vm.expectRevert(abi.encodeWithSelector(DeadlinePassed.selector, deadline));
        thunderSwapPool.addLiquidity(poolToken1Amount, poolToken2Amount, poolToken2Amount, 0, deadline);
        vm.stopPrank();
    }

    function testAddingLiquidityFailsIfAmountTooLow() public distributeTokensToUsers(1e18, 2e18) {
        uint256 poolToken1Amount = 1e8;
        uint256 poolToken2Amount = 2e8;
        uint256 minimumLiquidtyToSupply = thunderSwapPool.getMinimumPoolToken1ToSupply();

        vm.startPrank(user1);
        tokenA.approve(address(thunderSwapPool), poolToken1Amount);
        tokenB.approve(address(thunderSwapPool), poolToken2Amount);
        vm.expectRevert(
            abi.encodeWithSelector(LiquidityToAddTooLow.selector, poolToken1Amount, minimumLiquidtyToSupply)
        );
        thunderSwapPool.addLiquidity(poolToken1Amount, poolToken2Amount, poolToken2Amount, 0, uint256(block.timestamp));
        vm.stopPrank();
    }

    function testAddingLiquidityRevertsIfPoolToken2ToDepositGreaterThanMaximumPoolToken2ToDeposit()
        public
        distributeTokensToUsers(1e18, 2e18)
        addInitialLiquidity(1e18, 2e18)
    {
        uint256 poolToken1Amount = 1e18;
        uint256 poolToken2Amount = 1e18;
        uint256 poolToken1Reserves = tokenA.balanceOf(address(thunderSwapPool));
        uint256 poolToken2Reserves = tokenB.balanceOf(address(thunderSwapPool));
        uint256 expectedPoolTokensToDeposit =
            thunderSwapPool.getOutputAmountBasedOnInput(poolToken1Amount, poolToken1Reserves, poolToken2Reserves);
        uint256 maximumPoolToken2AmountToDeposit = 15e17;

        vm.startPrank(user1);
        tokenA.approve(address(thunderSwapPool), poolToken1Amount);
        tokenB.approve(address(thunderSwapPool), poolToken2Amount);
        vm.expectRevert(
            abi.encodeWithSelector(
                PoolTokensToDepositGreaterThanMaximumPoolTokensToDeposit.selector,
                thunderSwapPool.getPoolToken2(),
                expectedPoolTokensToDeposit,
                maximumPoolToken2AmountToDeposit
            )
        );
        thunderSwapPool.addLiquidity(
            poolToken1Amount, poolToken2Amount, maximumPoolToken2AmountToDeposit, 0, uint256(block.timestamp)
        );
        vm.stopPrank();
    }

    function testAddingLiquidtyRevertsIfMinimumLiquidityProviderTokensToMintTooLow()
        public
        distributeTokensToUsers(1e18, 2e18)
        addInitialLiquidity(1e18, 2e18)
    {
        uint256 poolToken1Amount = 1e18;
        uint256 poolToken2Amount = 2e18;
        uint256 minimumLiquidityProviderTokensToMint = 1e19;

        vm.startPrank(user1);
        tokenA.approve(address(thunderSwapPool), poolToken1Amount);
        tokenB.approve(address(thunderSwapPool), poolToken2Amount);
        vm.expectRevert(
            abi.encodeWithSelector(
                LiquidityProviderTokensToMintTooLow.selector, poolToken1Amount, minimumLiquidityProviderTokensToMint
            )
        );
        thunderSwapPool.addLiquidity(
            poolToken1Amount,
            poolToken2Amount,
            poolToken2Amount,
            minimumLiquidityProviderTokensToMint,
            uint256(block.timestamp)
        );
        vm.stopPrank();
    }

    function testAddingLiquidityEmitsEvent() public distributeTokensToUsers(1e18, 2e18) {
        uint256 poolToken1Amount = 1e18;
        uint256 poolToken2Amount = 2e18;

        vm.startPrank(deployer);
        tokenA.approve(address(thunderSwapPool), poolToken1Amount);
        tokenB.approve(address(thunderSwapPool), poolToken2Amount);
        vm.expectEmit(true, true, true, false);
        emit LiquidityAdded(deployer, poolToken1Amount, poolToken2Amount);
        thunderSwapPool.addLiquidity(
            poolToken1Amount, poolToken2Amount, poolToken2Amount, poolToken1Amount, uint256(block.timestamp)
        );
        vm.stopPrank();
    }
}
