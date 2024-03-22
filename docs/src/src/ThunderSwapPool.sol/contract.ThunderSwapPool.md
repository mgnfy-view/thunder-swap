# ThunderSwapPool
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/997ceda25caa399aceddccd5cec1898cfe55e38c/src/ThunderSwapPool.sol)

**Inherits:**
[IThunderSwapPool](/src/interfaces/IThunderSwapPool.sol/interface.IThunderSwapPool.md)


## State Variables
### i_poolToken1

```solidity
IERC20 private immutable i_poolToken1;
```


### i_poolToken2

```solidity
IERC20 private immutable i_poolToken2;
```


### i_liquidityProviderToken

```solidity
LiquidityProviderToken private immutable i_liquidityProviderToken;
```


### MINIMUM_POOL_TOKEN_1_TO_DEPOSIT

```solidity
uint256 private constant MINIMUM_POOL_TOKEN_1_TO_DEPOSIT = 1e9;
```


### FEE_NUMERATOR

```solidity
uint256 private constant FEE_NUMERATOR = 997;
```


### FEE_DENOMINATOR

```solidity
uint256 private constant FEE_DENOMINATOR = 1000;
```


## Functions
### notZero


```solidity
modifier notZero(uint256 _inputValue);
```

### beforeDeadline


```solidity
modifier beforeDeadline(uint256 _deadline);
```

### constructor


```solidity
constructor(
    address _poolToken1,
    address _poolToken2,
    string memory _liquidityProviderTokenName,
    string memory _liquidityProviderTokenSymbol
);
```

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
    external
    notZero(_poolToken1Amount)
    notZero(_poolToken2Amount)
    notZero(_maximumPoolToken2ToDeposit)
    beforeDeadline(_deadline);
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

Allows liquidity providers to exit the protocol by withdrawing their deposited liquidity


```solidity
function withdrawLiquidity(
    uint256 _liquidityProviderTokensToBurn,
    uint256 _minimumPoolToken1ToWithdraw,
    uint256 _minimumPoolToken2ToWithdraw,
    uint256 _deadline
)
    external
    notZero(_liquidityProviderTokensToBurn)
    notZero(_minimumPoolToken1ToWithdraw)
    notZero(_minimumPoolToken2ToWithdraw)
    beforeDeadline(_deadline);
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
    uint256 _deadline
)
    external
    notZero(_inputAmount)
    notZero(_minimumOutputTokenToReceive)
    beforeDeadline(_deadline);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_inputToken`|`IERC20`|The input token (supported by the pool)|
|`_inputAmount`|`uint256`|The amount of input token to send|
|`_minimumOutputTokenToReceive`|`uint256`|(slippage protection) The minimum amount of output token to receive|
|`_receiver`|`address`|Receiver of the output token amount (contract, or a wallet)|
|`_callContract`|`bool`|If true, call the `onThunderSwapReceived()` function on the receiver contract|
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
    uint256 _deadline
)
    external
    notZero(_outputAmount)
    notZero(_maximumInputTokensToSend)
    beforeDeadline(_deadline);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_outputToken`|`IERC20`|The output token (supported by the pool)|
|`_outputAmount`|`uint256`|The amount of output token to receive|
|`_maximumInputTokensToSend`|`uint256`|(slippage protection) The maximum amount of input token to send|
|`_receiver`|`address`|Receiver of the output token amount (contract, or a wallet)|
|`_callContract`|`bool`|If true, call the `onThunderSwapReceived()` function on the receiver contract|
|`_deadline`|`uint256`|Deadline before which the flash swap should occur|


### getPoolToken1


```solidity
function getPoolToken1() external view returns (IERC20);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`IERC20`|The pool token 1 contract|


### getPoolToken2


```solidity
function getPoolToken2() external view returns (IERC20);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`IERC20`|The pool token 2 contract|


### getLiquidityProviderToken


```solidity
function getLiquidityProviderToken() external view returns (IERC20);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`IERC20`|The liquidity provider token contract|


### getMinimumPoolToken1ToSupply


```solidity
function getMinimumPoolToken1ToSupply() external pure returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The minimum pool token 1 amount to add as liquidity|


### getTotalLiquidityProviderTokenSupply


```solidity
function getTotalLiquidityProviderTokenSupply() public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The total LP token supply|


### getPoolToken1Reserves


```solidity
function getPoolToken1Reserves() public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The total amount of pool token 1 held by this protocol|


### getPoolToken2Reserves


```solidity
function getPoolToken2Reserves() public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The total amount of pool token 2 held by this protocol|


### isPoolToken

Checks if the specified token is used by this pool


```solidity
function isPoolToken(IERC20 _token) public view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`IERC20`|The token to check|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True or false depending on whether it is a pool token or not|


### getPoolToken2LiquidityToAddBasedOnPoolToken1Amount

Calculates the amount of pool token 2 to supply as liquidity for a specified
pool token 1 amount


```solidity
function getPoolToken2LiquidityToAddBasedOnPoolToken1Amount(uint256 _poolToken1Amount)
    public
    view
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_poolToken1Amount`|`uint256`|The amount of pool token 1 liquidity you want to add|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The amount of pool token 2 to supply as liquidity|


### getPoolToken1LiquidityToAddBasedOnPoolToken2Amount

Calculates the amount of pool token 1 to supply as liquidity for a specified
pool token 2 amount


```solidity
function getPoolToken1LiquidityToAddBasedOnPoolToken2Amount(uint256 _poolToken2Amount)
    external
    view
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_poolToken2Amount`|`uint256`|The amount of pool token 2 liquidity you want to add|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The amount of pool token 1 to supply as liquidity|


### getLiquidityProviderTokensToMint

Calculates the amount of LP tokens to mint based on the amount of pool token 1
to supply as liquidity


```solidity
function getLiquidityProviderTokensToMint(uint256 _poolToken1AmountToDeposit)
    public
    view
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_poolToken1AmountToDeposit`|`uint256`|The amount of pool token 1 liquidity you want to add|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The amount of LP tokens to mint|


### getInputBasedOnOuput

Calculates the amount of input pool token to send based on the amount of output
pool token you want to receive as output


```solidity
function getInputBasedOnOuput(
    uint256 _outputAmount,
    uint256 _inputReserves,
    uint256 _outputReserves
)
    public
    pure
    notZero(_outputAmount)
    notZero(_inputReserves)
    notZero(_outputReserves)
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_outputAmount`|`uint256`|The amount of output pool token you want to receive|
|`_inputReserves`|`uint256`|The total amount of input pool token supply held by this protocol|
|`_outputReserves`|`uint256`|The total amount of output pool token supply held by this protocol|


### getOutputBasedOnInput

Calculates the amount of output pool token to receive based on the amount of input
pool token you want to send


```solidity
function getOutputBasedOnInput(
    uint256 _inputAmount,
    uint256 _inputReserves,
    uint256 _outputReserves
)
    public
    pure
    notZero(_inputAmount)
    notZero(_outputReserves)
    notZero(_inputReserves)
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_inputAmount`|`uint256`|The amount of output pool token you want to receive|
|`_inputReserves`|`uint256`|The total amount of input pool token supply held by this protocol|
|`_outputReserves`|`uint256`|The total amount of output pool token supply held by this protocol|


### _addLiquidity

Transfers pool token 1 and pool token 2 amounts from the user to the protocol. Helper
for the `addLiquidity` function


```solidity
function _addLiquidity(
    uint256 _poolToken1Amount,
    uint256 _poolToken2Amount,
    uint256 _liquidityProviderTokensToMint
)
    internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_poolToken1Amount`|`uint256`|The amount of pool token 1 to supply|
|`_poolToken2Amount`|`uint256`|The amount of pool token 2 to supply|
|`_liquidityProviderTokensToMint`|`uint256`|The amount of LP tokens to mint to the LP|


### _withdrawLiquidity

Sends pool token 1 and pool token 2 amount to the LP. Helper for the `withdrawLiquidity`
function


```solidity
function _withdrawLiquidity(
    uint256 _liquidityProviderTokensToBurn,
    uint256 _poolToken1AmountToWithdraw,
    uint256 _poolToken2AmountToWithdraw
)
    internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_liquidityProviderTokensToBurn`|`uint256`|The amount of LP tokens to burn|
|`_poolToken1AmountToWithdraw`|`uint256`|The amount of pool token 1 to withdraw|
|`_poolToken2AmountToWithdraw`|`uint256`|The amount of pool token 2 to withdraw|


### _flashSwap

Flash swaps input token amount for the output token amount. The output token is first
sent to the receiver, and the `onThunderSwapReceived()` function is called if `_callContract`
is set to true. Then, in the same transaction, the receiver contract approves the amount of input
token to send, and this function transfers the amount to the protocol. There can be no intermediate
contract, and wallets can directly swap tokens as well by setting `_callContract` to false, and
`receiver` to the wallet address


```solidity
function _flashSwap(
    IERC20 _inputToken,
    uint256 _inputAmount,
    IERC20 _outputToken,
    uint256 _outputAmount,
    address _receiver,
    bool _callContract
)
    internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_inputToken`|`IERC20`|The input token|
|`_inputAmount`|`uint256`|The input token amount|
|`_outputToken`|`IERC20`|The output token|
|`_outputAmount`|`uint256`|The output token amount|
|`_receiver`|`address`|The receiver of the flash swap|
|`_callContract`|`bool`|If true, call the `onThunderSwapReceived()` function on the receiver contract|


## Events
### LiquidityProviderTokenDeployed

```solidity
event LiquidityProviderTokenDeployed(address indexed liquidityProviderToken);
```

### LiquidityAdded

```solidity
event LiquidityAdded(
    address indexed liquidityProvider,
    uint256 indexed poolToken1Amount,
    uint256 indexed poolToken2Amount
);
```

### LiquidityWithdrawn

```solidity
event LiquidityWithdrawn(
    address liquidityProvider,
    uint256 indexed liquidityProviderTokensBurnt,
    uint256 indexed poolToken1AmountWithdrawn,
    uint256 indexed poolToken2AmountWithdrawn
);
```

### FlashSwapped

```solidity
event FlashSwapped(
    address user,
    IERC20 inputToken,
    IERC20 outputToken,
    uint256 indexed inputAmount,
    uint256 indexed outputAmount
);
```

## Errors
### InputValueZeroNotAllowed

```solidity
error InputValueZeroNotAllowed();
```

### DeadlinePassed

```solidity
error DeadlinePassed(uint256 _deadline);
```

### LiquidityToAddTooLow

```solidity
error LiquidityToAddTooLow(uint256 liquidityToAdd, uint256 minimumPoolToken1ToDeposit);
```

### LiquidityProviderTokensToMintTooLow

```solidity
error LiquidityProviderTokensToMintTooLow(
    uint256 liquidityProviderTokensToMint, uint256 minimumLiquidityProviderTokensToMint
);
```

### NotAPoolToken

```solidity
error NotAPoolToken(IERC20 poolToken);
```

### PoolTokensToDepositGreaterThanMaximumPoolTokensToDeposit

```solidity
error PoolTokensToDepositGreaterThanMaximumPoolTokensToDeposit(
    IERC20 poolToken, uint256 poolTokensToDeposit, uint256 maximumPoolTokensToDeposit
);
```

### PoolTokensToWithdrawLessThanMinimumPoolTokensToWithdraw

```solidity
error PoolTokensToWithdrawLessThanMinimumPoolTokensToWithdraw(
    IERC20 poolToken, uint256 poolTokensToWithdraw, uint256 minimumPoolTokensToWithdraw
);
```

### ReceiverZeroAddress

```solidity
error ReceiverZeroAddress();
```

### PoolTokenToReceiveLessThanMinimumPoolTokenToReceive

```solidity
error PoolTokenToReceiveLessThanMinimumPoolTokenToReceive(
    IERC20 outputToken, uint256 outputAmount, uint256 minimumOutputAmount
);
```

### PoolTokenToSendMoreThanMaximumPoolTokenToSend

```solidity
error PoolTokenToSendMoreThanMaximumPoolTokenToSend(
    IERC20 inputToken, uint256 inputAmount, uint256 maximumInputAmount
);
```

