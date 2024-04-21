# LiquiditySupplyAndSwapMath
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/538bce28778223301347f4273ff464e4ab8e7382/src/core/lib/LiquiditySupplyAndSwapMath.sol)


## Functions
### getPoolToken2LiquidityToAddBasedOnPoolToken1Amount


```solidity
function getPoolToken2LiquidityToAddBasedOnPoolToken1Amount(
    uint256 _poolToken1Amount,
    uint256 _poolToken1Reserves,
    uint256 _poolToken2Reserves
)
    internal
    pure
    returns (uint256);
```

### getPoolToken1LiquidityToAddBasedOnPoolToken2Amount


```solidity
function getPoolToken1LiquidityToAddBasedOnPoolToken2Amount(
    uint256 _poolToken2Amount,
    uint256 _poolToken1Reserves,
    uint256 _poolToken2Reserves
)
    internal
    pure
    returns (uint256);
```

### getLiquidityProviderTokensToMint


```solidity
function getLiquidityProviderTokensToMint(
    uint256 _poolToken1AmountToDeposit,
    uint256 _totalLiquidityProviderTokenSupply,
    uint256 _poolToken1reserves
)
    public
    pure
    returns (uint256);
```

### getInputBasedOnOuput


```solidity
function getInputBasedOnOuput(
    uint256 _outputAmount,
    uint256 _inputReserves,
    uint256 _outputReserves,
    uint256 _feeNumerator,
    uint256 _feeDenominator
)
    public
    pure
    returns (uint256);
```

### getOutputBasedOnInput


```solidity
function getOutputBasedOnInput(
    uint256 _inputAmount,
    uint256 _inputReserves,
    uint256 _outputReserves,
    uint256 _feeNumerator,
    uint256 _feeDenominator
)
    public
    pure
    returns (uint256);
```

