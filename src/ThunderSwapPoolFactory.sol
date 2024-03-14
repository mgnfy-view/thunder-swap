// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { ThunderSwapPool } from "./ThunderSwapPool.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract ThunderSwapPoolFactory is Ownable {
    mapping(address => bool) private s_supportedTokens;
    mapping(address => address) private s_tokenToPool;
    mapping(address => address[]) private s_poolToTokens;

    event PoolCreated(address newPool, address token1, address token2);
    event SupportedToken(address supportedToken);

    error PoolAlreadyExists(address pool);
    error PoolCannotHaveTwoTokensOfTheSameType();
    error TokenNotSupported(address tokenAddress);

    constructor() Ownable(msg.sender) {}

    function setSupportedToken(address _token) external onlyOwner {
        s_supportedTokens[_token] = true;

        emit SupportedToken(_token);
    }

    function deployThunderSwapPool(address _token1, address _token2) external returns (ThunderSwapPool) {
        address poolFromToken1 = s_tokenToPool[_token1];
        if (!s_supportedTokens[_token1]) revert TokenNotSupported(_token1);
        if (!s_supportedTokens[_token2]) revert TokenNotSupported(_token2);
        if (_token1 == _token2) revert PoolCannotHaveTwoTokensOfTheSameType();
        if (poolFromToken1 != address(0) && poolFromToken1 == s_tokenToPool[_token2]) revert PoolAlreadyExists(poolFromToken1);

        string memory poolName = string.concat("ThunderSwap", ERC20(_token1).name(), ERC20(_token2).name());
        string memory poolSymbol = string.concat("TS", ERC20(_token1).symbol(), ERC20(_token1).symbol());
        ThunderSwapPool newPool = new ThunderSwapPool(_token1, _token2, poolName, poolSymbol);

        s_poolToTokens[address(newPool)] = [_token1, _token2];
        s_tokenToPool[_token1] = address(newPool);
        s_tokenToPool[_token2] = address(newPool);

        emit PoolCreated(address(newPool), _token1, _token2);

        return newPool;
    }

    function isTokenSupported(address _token) public view returns (bool) {
        return s_supportedTokens[_token];
    }

    function getPoolFromToken(address _token) external view returns (address) {
        return s_tokenToPool[_token];
    }

    function getPoolTokens(address _pool) external view returns (address[] memory) {
        return s_poolToTokens[_pool];
    }
}
