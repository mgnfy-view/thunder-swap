# LiquidityProviderToken
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/48c2541b51225b6140f6383b56ab80046ea60c03/src/core/LiquidityProviderToken.sol)

**Inherits:**
ERC20, Ownable

**Author:**
mgnfy-view

This is the ERC20 token that each `ThunderSwaPool` uses to keep track of the liquidity
supplied by LPs


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


