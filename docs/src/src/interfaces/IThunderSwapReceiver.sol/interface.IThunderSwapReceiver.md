# IThunderSwapReceiver
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/3fd7cb494e239f3a5cfc07b6750a10fc84968ecc/src/interfaces/IThunderSwapReceiver.sol)


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
    external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_inputToken`|`IERC20`|The input token|
|`_inputAmount`|`uint256`|The input token amount|
|`_outputToken`|`IERC20`|The output token|
|`_outputAmount`|`uint256`|The output token amount|


