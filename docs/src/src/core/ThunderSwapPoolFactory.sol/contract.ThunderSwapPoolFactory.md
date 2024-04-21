# ThunderSwapPoolFactory
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/538bce28778223301347f4273ff464e4ab8e7382/src/core/ThunderSwapPoolFactory.sol)

**Inherits:**
Ownable

**Author:**
Sahil Gujrati aka mgnfy.view

This factory can be used to deploy Thunder Swap pools for various
token combinations


## State Variables
### s_supportedTokens

```solidity
mapping(address token => bool supported) private s_supportedTokens;
```


### s_pairings

```solidity
mapping(address token1 => mapping(address token2 => address pool)) private s_pairings;
```


### s_tokenToPools

```solidity
mapping(address token => address[] pools) private s_tokenToPools;
```


### s_poolToTokens

```solidity
mapping(address pool => address[] tokens) private s_poolToTokens;
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


### getPoolsFromToken

Gets the thunder swap pool for the specified token


```solidity
function getPoolsFromToken(address _token) external view returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|The token to find a pool for|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|The thunder swap pool address for the given token|


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


### getPoolFromPairing

Gets the address of the pool that two tokens have


```solidity
function getPoolFromPairing(address _token1, address _token2) external view returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token1`|`address`|The address of the first token|
|`_token2`|`address`|The address of the second token|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The address of the pool for _token1 and _token2|


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

