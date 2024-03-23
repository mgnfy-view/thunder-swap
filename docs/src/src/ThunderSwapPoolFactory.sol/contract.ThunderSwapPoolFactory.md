# ThunderSwapPoolFactory
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/3fd7cb494e239f3a5cfc07b6750a10fc84968ecc/src/ThunderSwapPoolFactory.sol)

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

Adds tokens for which a thunder swap pool can be deployed


```solidity
function setSupportedToken(address _token) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|The token to support|


### deployThunderSwapPool

Deploys a thunder swap pool for the two specified supported tokens


```solidity
function deployThunderSwapPool(
    address _token1,
    address _token2
)
    external
    returns (ThunderSwapPool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token1`|`address`|Pool token 1|
|`_token2`|`address`|Pool token 2|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`ThunderSwapPool`|The deployed thunder swap pool|


### isTokenSupported

Checks if the token is supported


```solidity
function isTokenSupported(address _token) public view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|The token to check|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|A bool indicating if the token is supported or not|


### getPoolFromToken

Gets the thunder swap pool for the specified token


```solidity
function getPoolFromToken(address _token) external view returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|The token to find a pool for|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The thunder swap pool address for the given token|


### getPoolTokens

Gets the pool tokens supported by a specified pool


```solidity
function getPoolTokens(address _pool) external view returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_pool`|`address`|The thunder swap pool|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|An array of the pool tokens supported by the thunder swap pool|


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

