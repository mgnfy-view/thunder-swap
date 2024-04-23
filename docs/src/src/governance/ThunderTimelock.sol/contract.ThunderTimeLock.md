# ThunderTimeLock
[Git Source](https://github.com/Sahil-Gujrati/thunder-swap/blob/48c2541b51225b6140f6383b56ab80046ea60c03/src/governance/ThunderTimelock.sol)

**Inherits:**
TimelockController


## Functions
### constructor


```solidity
constructor(
    uint256 minDelay,
    address[] memory proposers,
    address[] memory executors
)
    TimelockController(minDelay, proposers, executors, msg.sender);
```

