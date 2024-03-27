// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { LiquidityHelper } from "../../utils/helpers/LiquidityHelper.sol";
import { UniversalHelper } from "../../utils/helpers/UniversalHelper.sol";

contract WithdrawLiquidity is UniversalHelper, LiquidityHelper {
    function testWithdrawingLiquidityRevertsIfTokenAmountPassedIsZero() public {
        vm.startPrank(deployer);
        vm.expectRevert(InputValueZeroNotAllowed.selector);
        thunderSwapPool.withdrawLiquidity(0, 0, 0, uint256(block.timestamp));
        vm.stopPrank();
    }

    function testWithdrawingLiquidityRevertsIfDeadlineHasPassed()
        public
        distributeTokensToUsers(1e18, 2e18)
        addInitialLiquidity(1e18, 2e18)
    {
        uint256 liquidityProviderTokensToBurn = 1e18;
        uint256 minimumPoolToken1AmountToWithdraw = 1e18;
        uint256 minimumPoolToken2AmountToWithdraw = 2e18;

        vm.warp(1 days);
        uint256 deadline = uint256(block.timestamp) - 1;

        vm.startPrank(deployer);
        vm.expectRevert(abi.encodeWithSelector(DeadlinePassed.selector, deadline));
        thunderSwapPool.withdrawLiquidity(
            liquidityProviderTokensToBurn,
            minimumPoolToken1AmountToWithdraw,
            minimumPoolToken2AmountToWithdraw,
            deadline
        );
        vm.stopPrank();
    }

    function testWithdrawingLiquidityRevertsIfPoolTokensToWithdrawIsLessThanMinimumPoolTokensToWithdraw(
    )
        public
        distributeTokensToUsers(1e18, 2e18)
        addInitialLiquidity(1e18, 2e18)
    {
        uint256 liquidityProviderTokensToBurn = 1e18;
        uint256 minimumPoolToken1AmountToWithdraw = 1e19;
        uint256 minimumPoolToken2AmountToWithdraw = 2e18;

        vm.startPrank(deployer);
        vm.expectRevert(
            abi.encodeWithSelector(
                PoolTokensToWithdrawLessThanMinimumPoolTokensToWithdraw.selector,
                thunderSwapPool.getPoolToken1(),
                1e18,
                minimumPoolToken1AmountToWithdraw
            )
        );
        thunderSwapPool.withdrawLiquidity(
            liquidityProviderTokensToBurn,
            minimumPoolToken1AmountToWithdraw,
            minimumPoolToken2AmountToWithdraw,
            uint256(block.timestamp)
        );
        vm.stopPrank();

        minimumPoolToken1AmountToWithdraw = 1e18;
        minimumPoolToken2AmountToWithdraw = 2e19;

        vm.startPrank(deployer);
        vm.expectRevert(
            abi.encodeWithSelector(
                PoolTokensToWithdrawLessThanMinimumPoolTokensToWithdraw.selector,
                thunderSwapPool.getPoolToken2(),
                2e18,
                minimumPoolToken2AmountToWithdraw
            )
        );
        thunderSwapPool.withdrawLiquidity(
            liquidityProviderTokensToBurn,
            minimumPoolToken1AmountToWithdraw,
            minimumPoolToken2AmountToWithdraw,
            uint256(block.timestamp)
        );
        vm.stopPrank();
    }

    function testWithdrawLiquidity()
        public
        distributeTokensToUsers(1e18, 2e18)
        addInitialLiquidity(1e18, 2e18)
    {
        uint256 liquidityProviderTokensToBurn = 1e18;
        uint256 minimumPoolToken1AmountToWithdraw = 1e18;
        uint256 minimumPoolToken2AmountToWithdraw = 2e18;

        vm.startPrank(deployer);
        thunderSwapPool.withdrawLiquidity(
            liquidityProviderTokensToBurn,
            minimumPoolToken1AmountToWithdraw,
            minimumPoolToken2AmountToWithdraw,
            uint256(block.timestamp)
        );
        vm.stopPrank();

        assertEq(
            thunderSwapPool.getPoolToken1().balanceOf(deployer), minimumPoolToken1AmountToWithdraw
        );
        assertEq(
            thunderSwapPool.getPoolToken2().balanceOf(deployer), minimumPoolToken2AmountToWithdraw
        );
        assertEq(thunderSwapPool.getLiquidityProviderToken().balanceOf(deployer), 0);
    }

    function testWithdrawingLiquidityEmitsEvent()
        public
        distributeTokensToUsers(1e18, 2e18)
        addInitialLiquidity(1e18, 2e18)
    {
        uint256 liquidityProviderTokensToBurn = 1e18;
        uint256 minimumPoolToken1AmountToWithdraw = 1e18;
        uint256 minimumPoolToken2AmountToWithdraw = 2e18;

        vm.startPrank(deployer);
        vm.expectEmit(true, true, true, true, address(thunderSwapPool));
        emit LiquidityWithdrawn(
            deployer,
            liquidityProviderTokensToBurn,
            minimumPoolToken1AmountToWithdraw,
            minimumPoolToken2AmountToWithdraw
        );
        thunderSwapPool.withdrawLiquidity(
            liquidityProviderTokensToBurn,
            minimumPoolToken1AmountToWithdraw,
            minimumPoolToken2AmountToWithdraw,
            uint256(block.timestamp)
        );
        vm.stopPrank();
    }
}
