// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IThunderSwapReceiver } from "@src/ThunderSwapReceiver/interfaces/IThunderSwapReceiver.sol";

contract ThunderSwapper is IThunderSwapReceiver {
    IERC20 private immutable i_poolToken1;
    IERC20 private immutable i_poolToken2;
    address private immutable i_thunderSwap;

    bool public isBeforeThunderSwapReceivedHookCalled;
    bool public isAfterThunderSwapReceivedHookCalled;

    modifier onlyThunderSwapContract() {
        if (i_thunderSwap != msg.sender) revert();
        _;
    }

    constructor(address _poolToken1, address _poolToken2, address _thunderSwap) {
        i_poolToken1 = IERC20(_poolToken1);
        i_poolToken2 = IERC20(_poolToken2);
        i_thunderSwap = _thunderSwap;
    }

    function beforeThunderSwapReceived(
        IERC20,
        uint256,
        IERC20,
        uint256
    )
        external
        onlyThunderSwapContract
    {
        isBeforeThunderSwapReceivedHookCalled = true;
    }

    function afterThunderSwapReceived(
        IERC20,
        uint256,
        IERC20,
        uint256
    )
        external
        onlyThunderSwapContract
    {
        isAfterThunderSwapReceivedHookCalled = true;
    }

    function onThunderSwapReceived(
        IERC20 _inputToken,
        uint256 _inputAmount,
        IERC20, /* _outputToken */
        uint256 /* _outputAmount */
    )
        external
        onlyThunderSwapContract
    {
        _inputToken.approve(msg.sender, _inputAmount);
    }
}
