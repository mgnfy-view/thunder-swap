# IThunderSwapPool
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/65d96eb516be89fd9526025068582cb68137dd6f/src/core/interfaces/IThunderSwapPool.sol)


## Functions
### addLiquidity


```solidity
function addLiquidity(
    uint256 _poolToken1Amount,
    uint256 _poolToken2Amount,
    uint256 _maximumPoolToken2ToDeposit,
    uint256 _minimumLPTokensToMint,
    uint256 _deadline
)
    external;
```

### withdrawLiquidity


```solidity
function withdrawLiquidity(
    uint256 _liquidityProviderTokensToBurn,
    uint256 _minimumPoolToken1ToWithdraw,
    uint256 _minimumPoolToken2ToWithdraw,
    uint256 _deadline
)
    external;
```

### flashSwapExactInput


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

### flashSwapExactOutput


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

