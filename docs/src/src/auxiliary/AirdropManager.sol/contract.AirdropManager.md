# AirdropManager
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/538bce28778223301347f4273ff464e4ab8e7382/src/auxiliary/AirdropManager.sol)

**Inherits:**
Ownable

**Author:**
Sahil Gujrati aka mgnfy.view

This contract serves as a manager to drop various supported tokens to users


## State Variables
### s_tokens

```solidity
address[] private s_tokens;
```


### s_supportedTokens

```solidity
mapping(address token => bool isSupported) private s_supportedTokens;
```


### AIRDROP_LIMIT

```solidity
uint256 constant AIRDROP_LIMIT = 150;
```


## Functions
### constructor


```solidity
constructor(address[] memory _tokens) Ownable(msg.sender);
```

### airdrop

Airdrops specified amounts of a token to sepcified recipients


```solidity
function airdrop(
    address[] memory _recipients,
    uint256[] memory _amounts,
    uint256 _tokenIndex
)
    external
    onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_recipients`|`address[]`|Beneficiaries of the airdrop|
|`_amounts`|`uint256[]`|The exact amounts to airdrop to recipients|
|`_tokenIndex`|`uint256`|Gets the token to airdrop from the supported tokens list|


### addToken

Support a new token for airdrop


```solidity
function addToken(address _token) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_token`|`address`|The token to support|


### withdrawAmount

Withdraws a specific amount of the given token from this contract


```solidity
function withdrawAmount(uint256 _amount, uint256 _tokenIndex) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_amount`|`uint256`|The amount to withdraw|
|`_tokenIndex`|`uint256`|Gets the token to airdrop from the supported tokens list|


### withdrawAllBalance

Withdraws all amount of the given token held by this contract


```solidity
function withdrawAllBalance(uint256 _tokenIndex) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_tokenIndex`|`uint256`|Gets the token to airdrop from the supported tokens list|


### checkTokenBalanceHeld

Gets the balance of the given token held by this contract


```solidity
function checkTokenBalanceHeld(uint256 _tokenIndex) external view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_tokenIndex`|`uint256`|Gets the token to airdrop from the supported tokens list|


### getToken

Gets the token to airdrop from the supported tokens list


```solidity
function getToken(uint256 _tokenIndex) external view returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_tokenIndex`|`uint256`|The index of the token in the supported tokens list|


## Events
### AirdropManager__TokenSupported

```solidity
event AirdropManager__TokenSupported(address token);
```

### AirdropManager__TokensAirdropped

```solidity
event AirdropManager__TokensAirdropped(address token, uint256 totalAmount);
```

## Errors
### AirdropManager__LimitBreached

```solidity
error AirdropManager__LimitBreached(uint256 numberOfRecepients, uint256 allowedNumberOfRecepients);
```

### AirdropManager__TokenAlreadySupported

```solidity
error AirdropManager__TokenAlreadySupported();
```

### AirdropManager__InsufficientTokenBalance

```solidity
error AirdropManager__InsufficientTokenBalance();
```

