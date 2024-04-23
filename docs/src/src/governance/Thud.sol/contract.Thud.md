# Thud
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/48c2541b51225b6140f6383b56ab80046ea60c03/src/governance/Thud.sol)

**Inherits:**
ERC20, ERC20Permit, ERC20Votes, Ownable

**Author:**
Sahil Gujrati aka mgnfy.view

This is the key utility and governance token of the Thunder Swap protocol


## Functions
### constructor


```solidity
constructor(uint256 _initialSupply)
    ERC20("Thunder", "THUD")
    ERC20Permit("Thunder")
    Ownable(msg.sender);
```

### _update


```solidity
function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Votes);
```

### nonces


```solidity
function nonces(address ownerOfNonce) public view override(ERC20Permit, Nonces) returns (uint256);
```

