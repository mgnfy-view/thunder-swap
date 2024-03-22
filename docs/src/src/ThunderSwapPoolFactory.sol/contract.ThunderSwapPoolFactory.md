# ThunderSwapPoolFactory
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/997ceda25caa399aceddccd5cec1898cfe55e38c/src/ThunderSwapPoolFactory.sol)

**Inherits:**
Ownable


## State Variables
### s_supportedTokens

```solidity
mapping(address => bool) private s_supportedTokens;
```


### s_tokenToPool

```solidity
mapping(address => address) private s_tokenToPool;
```


### s_poolToTokens

```solidity
mapping(address => address[]) private s_poolToTokens;
```


## Functions
### constructor


```solidity
constructor() Ownable(msg.sender);
```

### setSupportedToken


```solidity
function setSupportedToken(address _token) external onlyOwner;
```

### deployThunderSwapPool


```solidity
function deployThunderSwapPool(
    address _token1,
    address _token2
)
    external
    returns (ThunderSwapPool);
```

### isTokenSupported


```solidity
function isTokenSupported(address _token) public view returns (bool);
```

### getPoolFromToken


```solidity
function getPoolFromToken(address _token) external view returns (address);
```

### getPoolTokens


```solidity
function getPoolTokens(address _pool) external view returns (address[] memory);
```

## Events
### PoolCreated

```solidity
event PoolCreated(address newPool, address token1, address token2);
```

### SupportedToken

```solidity
event SupportedToken(address supportedToken);
```

## Errors
### PoolAlreadyExists

```solidity
error PoolAlreadyExists(address pool);
```

### PoolCannotHaveTwoTokensOfTheSameType

```solidity
error PoolCannotHaveTwoTokensOfTheSameType();
```

### TokenNotSupported

```solidity
error TokenNotSupported(address tokenAddress);
```

