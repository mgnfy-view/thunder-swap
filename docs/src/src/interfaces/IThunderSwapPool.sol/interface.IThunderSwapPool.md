# IThunderSwapPool
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/3fd7cb494e239f3a5cfc07b6750a10fc84968ecc/src/interfaces/IThunderSwapPool.sol)


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
    uint256 _deadline
)
    external;
```

