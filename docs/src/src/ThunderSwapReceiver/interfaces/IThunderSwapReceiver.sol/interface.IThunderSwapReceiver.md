# IThunderSwapReceiver
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/c5928651e4c994aae9565d571bef4170237837f3/src/ThunderSwapReceiver/interfaces/IThunderSwapReceiver.sol)

**Inherits:**
[IThunderSwapHooks](/src/ThunderSwapReceiver/interfaces/IThunderSwapHooks.sol/interface.IThunderSwapHooks.md)


## Functions
### onThunderSwapReceived

This function is invoked on each flash swap if `_callContract` was set to true


```solidity
function onThunderSwapReceived(
    IERC20 _inputToken,
    uint256 _inputAmount,
    IERC20 _outputToken,
    uint256 _outputAmount
)
    external
    returns (string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_inputToken`|`IERC20`|The input token|
|`_inputAmount`|`uint256`|The input token amount|
|`_outputToken`|`IERC20`|The output token|
|`_outputAmount`|`uint256`|The output token amount|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`string`|Return the string "Thunder Swap" for security concerns|


