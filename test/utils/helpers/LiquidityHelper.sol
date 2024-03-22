// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LiquidityHelper {
    event LiquidityAdded(
        address indexed liquidityProvider,
        uint256 indexed poolToken1Amount,
        uint256 indexed poolToken2Amount
    );
    event LiquidityWithdrawn(
        address liquidityProvider,
        uint256 indexed liquidityProviderTokensBurnt,
        uint256 indexed poolToken1AmountWithdrawn,
        uint256 indexed poolToken2AmountWithdrawn
    );

    error LiquidityToAddTooLow(uint256 liquidityToAdd, uint256 MINIMUM_POOL_TOKEN_1_TO_DEPOSIT);
    error LiquidityProviderTokensToMintTooLow(
        uint256 liquidityProviderTokensToMint, uint256 minimumLiquidityProviderTokensToMint
    );
    error PoolTokensToDepositGreaterThanMaximumPoolTokensToDeposit(
        IERC20 poolToken, uint256 poolTokensToDeposit, uint256 maximumPoolTokensToDeposit
    );
    error PoolTokensToWithdrawLessThanMinimumPoolTokensToWithdraw(
        IERC20 poolToken, uint256 poolTokensToWithdraw, uint256 minimumPoolTokensToWithdraw
    );
}
