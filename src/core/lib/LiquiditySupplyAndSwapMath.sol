// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title LiquiditySupplyAndSwapMath
 * @author mgnfy-view
 * @notice A library to aid in calcultion for supplying liquidity and swapping tokens
 */
library LiquiditySupplyAndSwapMath {
    function getPoolToken2LiquidityToAddBasedOnPoolToken1Amount(
        uint256 _poolToken1Amount,
        uint256 _poolToken1Reserves,
        uint256 _poolToken2Reserves
    )
        internal
        pure
        returns (uint256)
    {
        // p1: pool token 1 reserves, dp1: pool token 1 amount to deposit
        // p2: pool token 2 reserves, dp2: pool token 2 amount to deposit
        // (p1 + dp1) / (p2 + dp2) = p1 / p2
        // (p1 * p2) + (p2 * dp1) = (p1 * p2) + (p1 * dp2)
        // (p2 * dp1) = (p1 * dp2)
        // dp2 = (p2 * dp1) / p1
        return ((_poolToken2Reserves * _poolToken1Amount) / _poolToken1Reserves);
    }

    function getPoolToken1LiquidityToAddBasedOnPoolToken2Amount(
        uint256 _poolToken2Amount,
        uint256 _poolToken1Reserves,
        uint256 _poolToken2Reserves
    )
        internal
        pure
        returns (uint256)
    {
        // p1: pool token 1 reserves, dp1: pool token 1 amount to deposit
        // p2: pool token 2 reserves, dp2: pool token 2 amount to deposit
        // (p1 + dp1) / (p2 + dp2) = p1 / p2
        // (p1 * p2) + (p2 * dp1) = (p1 * p2) + (p1 * dp2)
        // (p2 * dp1) = (p1 * dp2)
        // dp1 = (p1 * dp2) / p2
        return ((_poolToken1Reserves * _poolToken2Amount) / _poolToken2Reserves);
    }

    function getLiquidityProviderTokensToMint(
        uint256 _poolToken1AmountToDeposit,
        uint256 _totalLiquidityProviderTokenSupply,
        uint256 _poolToken1reserves
    )
        public
        pure
        returns (uint256)
    {
        // p: pool token 1 reserves, dp: pool token 1 amount to deposit
        // lp: total liquidity provider token supply
        // dlp: amount of liquidity provider token to mint to the liquidity provider
        // (p + dp) / (lp + dlp) = p / lp
        // (p * dp) + (dp * lp) = (p * lp) + (p * dlp)
        // dlp = (dp * lp) / p
        return
            (_poolToken1AmountToDeposit * _totalLiquidityProviderTokenSupply) / _poolToken1reserves;
    }

    function getInputBasedOnOuput(
        uint256 _outputAmount,
        uint256 _inputReserves,
        uint256 _outputReserves,
        uint256 _feeNumerator,
        uint256 _feeDenominator
    )
        public
        pure
        returns (uint256)
    {
        return (
            (_feeDenominator * _inputReserves * _outputAmount)
                / (_feeNumerator * (_outputReserves - _outputAmount))
        );
    }

    function getOutputBasedOnInput(
        uint256 _inputAmount,
        uint256 _inputReserves,
        uint256 _outputReserves,
        uint256 _feeNumerator,
        uint256 _feeDenominator
    )
        public
        pure
        returns (uint256)
    {
        return (_feeNumerator * _inputAmount * _outputReserves)
            / ((_feeNumerator * _inputAmount) + (_feeDenominator * _inputReserves));
    }
}
