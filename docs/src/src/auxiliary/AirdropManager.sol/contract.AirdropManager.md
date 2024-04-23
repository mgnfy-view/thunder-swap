# AirdropManager
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/48c2541b51225b6140f6383b56ab80046ea60c03/src/auxiliary/AirdropManager.sol)

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


### getAirdropLimit


```solidity
function getAirdropLimit() external pure returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The max number of receiver's for a single airdrop session|


## Events
### TokenSupported

```solidity
event TokenSupported(address token);
```

### TokensAirdropped

```solidity
event TokensAirdropped(address token, uint256 totalAmount);
```

## Errors
### LimitBreached

```solidity
error LimitBreached(uint256 numberOfRecepients, uint256 allowedNumberOfRecepients);
```

### TokenAlreadySupported

```solidity
error TokenAlreadySupported();
```

### InsufficientTokenBalance

```solidity
error InsufficientTokenBalance();
```

