// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { ThunderSwapper } from "../ThunderSwapper.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashSwapHelper {
    event FlashSwapped(
        address user,
        IERC20 inputToken,
        IERC20 outputToken,
        uint256 indexed inputAmount,
        uint256 indexed outputAmount
    );

    error PoolTokenToReceiveLessThanMinimumPoolTokenToReceive(
        IERC20 outputToken, uint256 outputAmount, uint256 minimumOutputAmount
    );
    error PoolTokenToSendMoreThanMaximumPoolTokenToSend(
        IERC20 inputToken, uint256 inputAmount, uint256 maximumInputAmount
    );
}
