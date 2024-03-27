// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { ThunderSwapper } from "../../utils/ThunderSwapper.sol";
import { FlashSwapHelper } from "../../utils/helpers/FlashSwapHelper.sol";
import { UniversalHelper } from "../../utils/helpers/UniversalHelper.sol";

contract FlashSwap is UniversalHelper, FlashSwapHelper {
    ThunderSwapper private thunderSwapper;

    modifier deployThunderSwapper() {
        vm.startPrank(user1);
        thunderSwapper =
            new ThunderSwapper(address(tokenA), address(tokenB), address(thunderSwapPool));
        vm.stopPrank();
        _;
    }

    function flashSwappingRevertsIfInputOrOutputAmountsAreZero() public deployThunderSwapper {
        vm.expectRevert(InputValueZeroNotAllowed.selector);
        thunderSwapPool.flashSwapExactInput(
            tokenA, 0, 0, address(thunderSwapper), true, uint256(block.timestamp)
        );

        vm.expectRevert(InputValueZeroNotAllowed.selector);
        thunderSwapPool.flashSwapExactOutput(
            tokenA, 0, 0, address(thunderSwapper), true, uint256(block.timestamp)
        );
    }

    function flashSwappingRevertsIfDeadlineHasPassed() public deployThunderSwapper {
        uint256 dummyValue1 = 1e18;
        uint256 dummyValue2 = 2e18;

        vm.warp(1 days);
        uint256 deadline = uint256(block.timestamp - 1);
        vm.expectRevert(abi.encodeWithSelector(DeadlinePassed.selector, deadline));
        thunderSwapPool.flashSwapExactInput(
            tokenA, dummyValue1, dummyValue2, address(thunderSwapper), true, deadline
        );

        vm.expectRevert(abi.encodeWithSelector(DeadlinePassed.selector, deadline));
        thunderSwapPool.flashSwapExactOutput(
            tokenA, dummyValue1, dummyValue2, address(thunderSwapper), true, deadline
        );
    }

    function flashSwappingRevertsIfReceiverAddressIsZero() public {
        uint256 dummyValue1 = 1e18;
        uint256 dummyValue2 = 2e18;

        vm.expectRevert(ReceiverZeroAddress.selector);
        thunderSwapPool.flashSwapExactInput(
            tokenA, dummyValue1, dummyValue2, address(0), true, uint256(block.timestamp)
        );

        vm.expectRevert(ReceiverZeroAddress.selector);
        thunderSwapPool.flashSwapExactOutput(
            tokenA, dummyValue1, dummyValue2, address(0), true, uint256(block.timestamp)
        );
    }

    function flashSwappingExactInputRevertsIfOutputAmountisLessThanMinimumOutputAmountToReceive()
        public
        distributeTokensToUsers(1e18, 2e18)
        addInitialLiquidity(1e18, 2e18)
    {
        uint256 inputAmount = 1e18;
        uint256 minimumOutputTokensToReceive = 5e18;
        uint256 calculatedOutputAmount = thunderSwapPool.getOutputBasedOnInput(
            inputAmount,
            tokenA.balanceOf(address(thunderSwapPool)),
            tokenB.balanceOf(address(thunderSwapPool))
        );

        vm.startPrank(user1);
        tokenA.transfer(address(thunderSwapper), tokenA.balanceOf(user1));
        vm.expectRevert(
            abi.encodeWithSelector(
                PoolTokenToReceiveLessThanMinimumPoolTokenToReceive.selector,
                tokenB,
                calculatedOutputAmount,
                minimumOutputTokensToReceive
            )
        );
        thunderSwapPool.flashSwapExactInput(
            tokenA,
            inputAmount,
            minimumOutputTokensToReceive,
            address(thunderSwapper),
            true,
            uint256(block.timestamp)
        );
        vm.stopPrank();
    }

    function testFlashSwappingExactOutputRevertsIfInputAmountisGreaterThanMaximumInputAmountToSend()
        public
        distributeTokensToUsers(2e18, 4e18)
        addInitialLiquidity(1e18, 2e18)
        deployThunderSwapper
    {
        uint256 outputAmount = 5e17;
        uint256 maximumInputTokensToSend = 1e18;
        uint256 calculatedInputAmount = thunderSwapPool.getInputBasedOnOuput(
            outputAmount,
            tokenB.balanceOf(address(thunderSwapPool)),
            tokenA.balanceOf(address(thunderSwapPool))
        );

        vm.startPrank(user1);
        tokenB.transfer(address(thunderSwapper), tokenB.balanceOf(user1));
        vm.expectRevert(
            abi.encodeWithSelector(
                PoolTokenToSendMoreThanMaximumPoolTokenToSend.selector,
                tokenB,
                calculatedInputAmount,
                maximumInputTokensToSend
            )
        );
        thunderSwapPool.flashSwapExactOutput(
            tokenA,
            outputAmount,
            maximumInputTokensToSend,
            address(thunderSwapper),
            true,
            uint256(block.timestamp)
        );
        vm.stopPrank();
    }

    function testFlashSwappingExactInputDoesNotBreakInvariant()
        public
        distributeTokensToUsers(2e18, 4e18)
        addInitialLiquidity(1e18, 2e18)
        deployThunderSwapper
    {
        uint256 inputAmount = 1e18;
        uint256 minimumOutputTokensToReceive = 5e17;
        uint256 initialInvariantValue =
            tokenA.balanceOf(address(thunderSwapPool)) * tokenB.balanceOf(address(thunderSwapPool));

        vm.startPrank(user1);
        tokenA.transfer(address(thunderSwapper), tokenA.balanceOf(user1));
        thunderSwapPool.flashSwapExactInput(
            tokenA,
            inputAmount,
            minimumOutputTokensToReceive,
            address(thunderSwapper),
            true,
            uint256(block.timestamp)
        );
        vm.stopPrank();

        uint256 finalInvariantValue =
            tokenA.balanceOf(address(thunderSwapPool)) * tokenB.balanceOf(address(thunderSwapPool));
        assert(finalInvariantValue > initialInvariantValue);
    }

    function testFlashSwappingExactOutputDoesNotBreakInvariant()
        public
        distributeTokensToUsers(2e18, 4e18)
        addInitialLiquidity(1e18, 2e18)
        deployThunderSwapper
    {
        uint256 outputAmount = 5e17;
        uint256 maximumInputTokensToSend = 3e18;
        uint256 initialInvariantValue =
            tokenA.balanceOf(address(thunderSwapPool)) * tokenB.balanceOf(address(thunderSwapPool));

        vm.startPrank(user1);
        tokenB.transfer(address(thunderSwapper), tokenB.balanceOf(user1));
        thunderSwapPool.flashSwapExactOutput(
            tokenA,
            outputAmount,
            maximumInputTokensToSend,
            address(thunderSwapper),
            true,
            uint256(block.timestamp)
        );
        vm.stopPrank();

        uint256 finalInvariantValue =
            tokenA.balanceOf(address(thunderSwapPool)) * tokenB.balanceOf(address(thunderSwapPool));
        assert(finalInvariantValue > initialInvariantValue);
    }

    function flashSwappingEmitsEvent()
        public
        distributeTokensToUsers(2e18, 4e18)
        addInitialLiquidity(1e18, 2e18)
        deployThunderSwapper
    {
        uint256 inputAmount = 1e18;
        uint256 minimumOutputTokensToReceive = 5e17;

        vm.startPrank(user1);
        tokenA.transfer(address(thunderSwapper), tokenA.balanceOf(user1));
        vm.expectEmit(true, true, true, false, address(thunderSwapPool));
        emit FlashSwapped(
            user1,
            tokenA,
            tokenB,
            inputAmount,
            thunderSwapPool.getOutputBasedOnInput(
                inputAmount,
                tokenA.balanceOf(address(thunderSwapPool)),
                tokenB.balanceOf(address(thunderSwapPool))
            )
        );
        thunderSwapPool.flashSwapExactInput(
            tokenA,
            inputAmount,
            minimumOutputTokensToReceive,
            address(thunderSwapper),
            true,
            uint256(block.timestamp)
        );
        vm.stopPrank();
    }

    function testConductNormalSwapViaFlashSwapExactInput() public distributeTokensToUsers(1e18, 2e18) addInitialLiquidity(1e18, 2e18) {
        uint256 inputAmount = 1e18;
        uint256 minimumOutputTokensToReceive = 5e17;

        vm.startPrank(user1);
        tokenA.approve(address(thunderSwapPool), inputAmount);
        thunderSwapPool.flashSwapExactInput(
            tokenA,
            inputAmount,
            minimumOutputTokensToReceive,
            user1,
            false,
            uint256(block.timestamp)
        );
        vm.stopPrank();

        assert(tokenB.balanceOf(user1) <= 3e18);
    }

    function testConductNormalSwapViaFlashSwapExactOutput() public distributeTokensToUsers(2e18, 4e18) addInitialLiquidity(1e18, 2e18) {
        uint256 outputAmount = 5e17;
        uint256 maximumInputTokensToSend = 3e18;

        vm.startPrank(user1);
        tokenB.approve(address(thunderSwapPool), maximumInputTokensToSend);
        thunderSwapPool.flashSwapExactOutput(
            tokenA,
            outputAmount,
            maximumInputTokensToSend,
            user1,
            false,
            uint256(block.timestamp)
        );
        vm.stopPrank();

        assert(tokenA.balanceOf(user1) == 25e17);
    }
}
