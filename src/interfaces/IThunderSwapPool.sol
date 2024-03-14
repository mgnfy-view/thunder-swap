// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IThunderSwapPool {
    function addLiquidity(
        uint256 _poolToken1Amount,
        uint256 _poolToken2Amount,
        uint256 _maximumPoolToken2ToDeposit,
        uint256 _minimumLPTokensToMint,
        uint256 _deadline
    )
        external;
}
