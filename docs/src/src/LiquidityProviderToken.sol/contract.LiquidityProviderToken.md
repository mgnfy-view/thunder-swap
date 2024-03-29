# LiquidityProviderToken
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/3fd7cb494e239f3a5cfc07b6750a10fc84968ecc/src/LiquidityProviderToken.sol)

**Inherits:**
ERC20, Ownable


## Functions
### constructor


```solidity
constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) Ownable(msg.sender);
```

### mint

Mints the specified amount of LP tokens to the specified account


```solidity
function mint(address _account, uint256 _amount) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_account`|`address`|The receiver of LP tokens|
|`_amount`|`uint256`|The amount of LP tokens to mint|


### burn

Burns the specified amount of LP tokens held by the specified account


```solidity
function burn(address _account, uint256 _amount) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_account`|`address`|The account whose LP tokens are to be burnt|
|`_amount`|`uint256`|The amount of LP tokens to burn|


