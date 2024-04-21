# IThunderSwapPool
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/538bce28778223301347f4273ff464e4ab8e7382/src/core/interfaces/IThunderSwapPool.sol)


## Functions
### addLiquidity

Allows users to become liquidity providers by supplying the protocol with liquidity

*Pool token 2 to supply is calculated based on pool token 1 amount. However, at inception
the first LP can decide on the ratio of his/her deposit*


```solidity
function addLiquidity(
    uint256 _poolToken1Amount,
    uint256 _poolToken2Amount,
    uint256 _maximumPoolToken2ToDeposit,
    uint256 _minimumLiquidityProviderTokensToMint,
    uint256 _deadline
)
    external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_poolToken1Amount`|`uint256`|The amount of pool token 1 to add as liquidity|
|`_poolToken2Amount`|`uint256`|The amount of pool token 2 to add as liquidity|
|`_maximumPoolToken2ToDeposit`|`uint256`|(slippage protection) The maximum amount of pool token 2 to deposit based on pool token 1 amount|
|`_minimumLiquidityProviderTokensToMint`|`uint256`|(slippage protection) The minimum share of the pool the liquidity provider is expecting to own|
|`_deadline`|`uint256`|Deadline before which the liquidity should be added|


### withdrawLiquidity

Allows liquidity providers to exit the protocol by withdrawing their deposited
liquidity


```solidity
function withdrawLiquidity(
    uint256 _liquidityProviderTokensToBurn,
    uint256 _minimumPoolToken1ToWithdraw,
    uint256 _minimumPoolToken2ToWithdraw,
    uint256 _deadline
)
    external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_liquidityProviderTokensToBurn`|`uint256`|The amount of LP tokens the LP wants to burn to claim his/her liquidity|
|`_minimumPoolToken1ToWithdraw`|`uint256`|(slippage protection) The minimum pool token 1 amount the LP is expecting to withdraw|
|`_minimumPoolToken2ToWithdraw`|`uint256`|(slippage protection) The minimum pool token 2 amount the LP is expecting to withdraw|
|`_deadline`|`uint256`|Deadline before which the liquidity should be withdrawn|


### flashSwapExactInput

Flash swaps exact amount of input token for output token


```solidity
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
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_inputToken`|`IERC20`|The input token (supported by the pool)|
|`_inputAmount`|`uint256`|The amount of input token to send|
|`_minimumOutputTokenToReceive`|`uint256`|(slippage protection) The minimum amount of output token to receive|
|`_receiver`|`address`|Receiver of the output token amount (contract, or a wallet)|
|`_callContract`|`bool`|If true, call the `onThunderSwapReceived()` function on the receiver contract|
|`_callBeforeHook`|`bool`|if true, calls the `beforeThunderSwapReceived` hook on the receiver contract|
|`_callAfterHook`|`bool`|if true, calls the `afterThunderSwapReceived` hook on the receiver contract|
|`_deadline`|`uint256`|Deadline before which the flash swap should occur|


### flashSwapExactOutput

Flash swaps a certain amount of input token for an exact amount of output token


```solidity
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
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_outputToken`|`IERC20`|The output token (supported by the pool)|
|`_outputAmount`|`uint256`|The amount of output token to receive|
|`_maximumInputTokensToSend`|`uint256`|(slippage protection) The maximum amount of input token to send|
|`_receiver`|`address`|Receiver of the output token amount (contract, or a wallet)|
|`_callContract`|`bool`|If true, call the `onThunderSwapReceived()` function on the receiver contract|
|`_callBeforeHook`|`bool`|if true, calls the `beforeThunderSwapReceived` hook on the receiver contract|
|`_callAfterHook`|`bool`|if true, calls the `afterThunderSwapReceived` hook on the receiver contract|
|`_deadline`|`uint256`|Deadline before which the flash swap should occur|


