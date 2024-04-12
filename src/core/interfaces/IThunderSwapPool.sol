// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IThunderSwapPool {
    /**
     * @notice Allows users to become liquidity providers by supplying the protocol with liquidity
     * @dev Pool token 2 to supply is calculated based on pool token 1 amount. However, at inception
     * the first LP can decide on the ratio of his/her deposit
     * @param _poolToken1Amount The amount of pool token 1 to add as liquidity
     * @param _poolToken2Amount The amount of pool token 2 to add as liquidity
     * @param _maximumPoolToken2ToDeposit (slippage protection) The maximum amount of pool token
     * 2 to deposit based on pool token 1 amount
     * @param _minimumLiquidityProviderTokensToMint (slippage protection) The minimum share of the
     * pool the liquidity provider is expecting to own
     * @param _deadline Deadline before which the liquidity should be added
     */
    function addLiquidity(
        uint256 _poolToken1Amount,
        uint256 _poolToken2Amount,
        uint256 _maximumPoolToken2ToDeposit,
        uint256 _minimumLiquidityProviderTokensToMint,
        uint256 _deadline
    )
        external;

    /**
     * @notice Allows liquidity providers to exit the protocol by withdrawing their deposited
     * liquidity
     * @param _liquidityProviderTokensToBurn The amount of LP tokens the LP wants to burn to
     * claim his/her liquidity
     * @param _minimumPoolToken1ToWithdraw (slippage protection) The minimum pool token 1
     * amount the LP is expecting to withdraw
     * @param _minimumPoolToken2ToWithdraw (slippage protection) The minimum pool token 2
     * amount the LP is expecting to withdraw
     * @param _deadline Deadline before which the liquidity should be withdrawn
     */
    function withdrawLiquidity(
        uint256 _liquidityProviderTokensToBurn,
        uint256 _minimumPoolToken1ToWithdraw,
        uint256 _minimumPoolToken2ToWithdraw,
        uint256 _deadline
    )
        external;

    /**
     * @notice Flash swaps exact amount of input token for output token
     * @param _inputToken The input token (supported by the pool)
     * @param _inputAmount The amount of input token to send
     * @param _minimumOutputTokenToReceive (slippage protection) The minimum amount of output token
     * to receive
     * @param _receiver Receiver of the output token amount (contract, or a wallet)
     * @param _callContract If true, call the `onThunderSwapReceived()` function on the receiver
     * contract
     * @param _callBeforeHook if true, calls the `beforeThunderSwapReceived` hook on the receiver
     * contract
     * @param _callAfterHook if true, calls the `afterThunderSwapReceived` hook on the receiver
     * contract
     * @param _deadline Deadline before which the flash swap should occur
     */
    function flashSwapExactInput(
        IERC20 _inputToken,
        uint256 _inputAmount,
        uint256 _minimumOutputTokenToReceive,
        address _receiver,
        bool _callContract,
        bool _callBeforeHook,
        bool _callAfterHook,
        uint256 _deadline
    )
        external;

    /**
     * @notice Flash swaps a certain amount of input token for an exact amount of output token
     * @param _outputToken The output token (supported by the pool)
     * @param _outputAmount The amount of output token to receive
     * @param _maximumInputTokensToSend (slippage protection) The maximum amount of input token
     * to send
     * @param _receiver Receiver of the output token amount (contract, or a wallet)
     * @param _callContract If true, call the `onThunderSwapReceived()` function on the receiver
     * contract
     * @param _callBeforeHook if true, calls the `beforeThunderSwapReceived` hook on the receiver
     * contract
     * @param _callAfterHook if true, calls the `afterThunderSwapReceived` hook on the receiver
     * contract
     * @param _deadline Deadline before which the flash swap should occur
     */
    function flashSwapExactOutput(
        IERC20 _outputToken,
        uint256 _outputAmount,
        uint256 _maximumInputTokensToSend,
        address _receiver,
        bool _callContract,
        bool _callBeforeHook,
        bool _callAfterHook,
        uint256 _deadline
    )
        external;
}
