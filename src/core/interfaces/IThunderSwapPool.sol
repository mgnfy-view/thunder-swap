// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IThunderSwapPool {
    function addLiquidity(
        uint256 _poolToken1Amount,
        uint256 _poolToken2Amount,
        uint256 _maximumPoolToken2ToDeposit,
        uint256 _minimumLPTokensToMint,
        uint256 _deadline
    )
        external;

    function withdrawLiquidity(
        uint256 _liquidityProviderTokensToBurn,
        uint256 _minimumPoolToken1ToWithdraw,
        uint256 _minimumPoolToken2ToWithdraw,
        uint256 _deadline
    )
        external;

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
