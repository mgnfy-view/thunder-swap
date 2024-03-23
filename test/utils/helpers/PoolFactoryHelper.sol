// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract PoolFactoryHelper {
    event PoolCreated(address newPool, address token1, address token2);
    event SupportedToken(address supportedToken);

    error PoolAlreadyExists(address pool);
    error PoolCannotHaveTwoTokensOfTheSameType();
    error TokenNotSupported(address tokenAddress);
}
