// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { UniversalHelper } from "../../utils/helpers/UniversalHelper.sol";

// tests for view functions of ThunderSwapPool and ThunderSwapPoolFactory
contract MiscellaneousTest is UniversalHelper {
    function testGetPoolTokenAddresses() public view {
        assertEq(address(thunderSwapPool.getPoolToken1()), address(tokenA));
        assertEq(address(thunderSwapPool.getPoolToken2()), address(tokenB));
    }

    function testGetMinimumPoolToken1ToSupply() public view {
        assertEq(thunderSwapPool.getMinimumPoolToken1ToSupply(), 1e9);
    }

    function testGetTotalLiquidityProviderTokenSupply()
        public
        distributeTokensToUsers(1e18, 2e18)
        addInitialLiquidity(1e18, 2e18)
    {
        assertEq(thunderSwapPool.getTotalLiquidityProviderTokenSupply(), 1e18);
    }

    function testGetPoolToken1Reserves()
        public
        distributeTokensToUsers(1e18, 2e18)
        addInitialLiquidity(1e18, 2e18)
    {
        assertEq(thunderSwapPool.getPoolToken1Reserves(), 1e18);
    }

    function testGetPoolToken2Reserves()
        public
        distributeTokensToUsers(1e18, 2e18)
        addInitialLiquidity(1e18, 2e18)
    {
        assertEq(thunderSwapPool.getPoolToken2Reserves(), 2e18);
    }

    function testGetPoolToken2LiquidityToAddBasedOnPoolToken1Amount()
        public
        distributeTokensToUsers(1e18, 2e18)
        addInitialLiquidity(1e18, 2e18)
    {
        uint256 poolToken1Amount = 1e18;
        uint256 expectedPoolToken2AmountToDeposit = 2e18;

        assertEq(
            thunderSwapPool.getPoolToken2LiquidityToAddBasedOnPoolToken1Amount(poolToken1Amount),
            expectedPoolToken2AmountToDeposit
        );
    }

    function getPoolToken1LiquidityToAddBasedOnPoolToken2Amount()
        public
        distributeTokensToUsers(1e18, 2e18)
        addInitialLiquidity(1e18, 2e18)
    {
        uint256 poolToken2Amount = 2e18;
        uint256 expectedPoolToken1AmountToDeposit = 1e18;

        assertEq(
            thunderSwapPool.getPoolToken1LiquidityToAddBasedOnPoolToken2Amount(poolToken2Amount),
            expectedPoolToken1AmountToDeposit
        );
    }

    function testGetLiquidityProviderTokensToMint()
        public
        distributeTokensToUsers(1e18, 2e18)
        addInitialLiquidity(1e18, 2e18)
    {
        uint256 poolToken1AmountToAddAsLiquidity = 1e18;
        uint256 expectedLiquidityProviderTokensToMint = 1e18;

        assertEq(
            thunderSwapPool.getLiquidityProviderTokensToMint(poolToken1AmountToAddAsLiquidity),
            expectedLiquidityProviderTokensToMint
        );
    }

    function testGetInputBasedOnOuput() public view {
        uint256 inputReserves = 1e18;
        uint256 outputReserves = 2e18;

        uint256 outputAmount = 1e18;
        uint256 minimumInputAmount = 1e18;
        uint256 inputAmountWithFees =
            thunderSwapPool.getInputBasedOnOuput(outputAmount, inputReserves, outputReserves);
        assert(inputAmountWithFees > minimumInputAmount);
    }

    function testGetOutputBasedOnInput() public view {
        uint256 inputReserves = 1e18;
        uint256 outputReserves = 2e18;

        uint256 inputAmount = 1004e15;
        uint256 minimumOutputAmount = 1e18;
        uint256 outputAmount =
            thunderSwapPool.getOutputBasedOnInput(inputAmount, inputReserves, outputReserves);
        assert(outputAmount > minimumOutputAmount);
    }

    function testIsTokenSupported() public view {
        assert(thunderSwapPoolFactory.isTokenSupported(address(tokenA)));
        assert(thunderSwapPoolFactory.isTokenSupported(address(tokenB)));
    }

    function testSetSupportedToken() public {
        address supportToken = makeAddr("supportToken");

        vm.prank(deployer);
        thunderSwapPoolFactory.setSupportedToken(supportToken);

        assert(thunderSwapPoolFactory.isTokenSupported(supportToken));
    }

    function testGetPoolsFromToken() public view {
        assertEq(
            thunderSwapPoolFactory.getPoolsFromToken(address(tokenA))[0], address(thunderSwapPool)
        );
        assertEq(
            thunderSwapPoolFactory.getPoolsFromToken(address(tokenB))[0], address(thunderSwapPool)
        );
    }

    function testGetPoolTokensFromThunderSwapPool() public view {
        address[] memory poolTokens = thunderSwapPoolFactory.getPoolTokens(address(thunderSwapPool));

        assertEq(poolTokens[0], address(tokenA));
        assertEq(poolTokens[1], address(tokenB));
    }

    function testGetPoolFromPairings() public view {
        assertEq(
            thunderSwapPoolFactory.getPoolFromPairing(address(tokenA), address(tokenB)),
            address(thunderSwapPool)
        );
        assertEq(
            thunderSwapPoolFactory.getPoolFromPairing(address(tokenA), address(tokenB)),
            address(thunderSwapPool)
        );
    }
}
