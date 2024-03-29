// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IThunderSwapHooks {
    /**
     * @notice Called by the ThunderSwapPool before your swap
     * @param _inputToken The input token
     * @param _inputAmount The input token amount
     * @param _outputToken The output token
     * @param _outputAmount The output token amount
     */
    function beforeThunderSwapReceived(
        IERC20 _inputToken,
        uint256 _inputAmount,
        IERC20 _outputToken,
        uint256 _outputAmount
    )
        external;

    /**
     * @notice Called by the ThunderSwapPool after your swap
     * @param _inputToken The input token
     * @param _inputAmount The input token amount
     * @param _outputToken The output token
     * @param _outputAmount The output token amount
     */
    function afterThunderSwapReceived(
        IERC20 _inputToken,
        uint256 _inputAmount,
        IERC20 _outputToken,
        uint256 _outputAmount
    )
        external;
}
