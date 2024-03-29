# IThunderSwapHooks
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/65d96eb516be89fd9526025068582cb68137dd6f/src/ThunderSwapReceiver/interfaces/IThunderSwapHooks.sol)


## Functions
### beforeThunderSwapReceived

Called by the ThunderSwapPool before your swap


```solidity
function beforeThunderSwapReceived(
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


### afterThunderSwapReceived

Called by the ThunderSwapPool after your swap


```solidity
function afterThunderSwapReceived(
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


