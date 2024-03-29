# IThunderSwapReceiver
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/65d96eb516be89fd9526025068582cb68137dd6f/src/ThunderSwapReceiver/interfaces/IThunderSwapReceiver.sol)

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
    external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_inputToken`|`IERC20`|The input token|
|`_inputAmount`|`uint256`|The input token amount|
|`_outputToken`|`IERC20`|The output token|
|`_outputAmount`|`uint256`|The output token amount|


