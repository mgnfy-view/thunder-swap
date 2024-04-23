# LiquiditySupplyAndSwapMath
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/48c2541b51225b6140f6383b56ab80046ea60c03/src/core/lib/LiquiditySupplyAndSwapMath.sol)


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

