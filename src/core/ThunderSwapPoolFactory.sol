// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { ThunderSwapPool } from "./ThunderSwapPool.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title Thunder Swap Pool Factory
 * @author Sahil Gujrati aka mgnfy.view
 * @notice This factory can be used to deploy Thunder Swap pools for various
 * token combinations
 */
contract ThunderSwapPoolFactory is Ownable {
    mapping(address token => bool supported) private s_supportedTokens;
    mapping(address token1 => mapping(address token2 => address pool)) private s_pairings;
    mapping(address token => address[] pools) private s_tokenToPools;
    mapping(address pool => address[] tokens) private s_poolToTokens;

    event PoolCreated(address newPool, address token1, address token2);
    event SupportedToken(address supportedToken);

    error PoolAlreadyExists(address pool);
    error PoolCannotHaveTwoTokensOfTheSameType();
    error TokenNotSupported(address tokenAddress);

    constructor() Ownable(msg.sender) { }

    /**
     * @notice Adds tokens for which a thunder swap pool can be deployed
     * @param _token The token to support
     */
    function setSupportedToken(address _token) external onlyOwner {
        s_supportedTokens[_token] = true;

        emit SupportedToken(_token);
    }

    /**
     * @notice Deploys a thunder swap pool for the two specified supported tokens
     * @param _token1 Pool token 1
     * @param _token2 Pool token 2
     * @return The deployed thunder swap pool
     */
    function deployThunderSwapPool(
        address _token1,
        address _token2
    )
        external
        returns (ThunderSwapPool)
    {
        if (!s_supportedTokens[_token1]) revert TokenNotSupported(_token1);
        if (!s_supportedTokens[_token2]) revert TokenNotSupported(_token2);
        if (_token1 == _token2) revert PoolCannotHaveTwoTokensOfTheSameType();
        address pool = s_pairings[_token1][_token2];
        if (pool != address(0)) revert PoolAlreadyExists(pool);

        string memory poolName =
            string.concat("ThunderSwap", ERC20(_token1).name(), ERC20(_token2).name());
        string memory poolSymbol =
            string.concat("TS", ERC20(_token1).symbol(), ERC20(_token1).symbol());
        ThunderSwapPool newPool = new ThunderSwapPool(_token1, _token2, poolName, poolSymbol);

        s_poolToTokens[address(newPool)] = [_token1, _token2];

        s_tokenToPools[_token1].push(address(newPool));
        s_tokenToPools[_token2].push(address(newPool));

        s_pairings[_token1][_token2] = address(newPool);
        s_pairings[_token2][_token1] = address(newPool);

        emit PoolCreated(address(newPool), _token1, _token2);

        return newPool;
    }

    /**
     * @notice Checks if the token is supported
     * @param _token The token to check
     * @return A bool indicating if the token is supported or not
     */
    function isTokenSupported(address _token) public view returns (bool) {
        return s_supportedTokens[_token];
    }

    /**
     * @notice Gets the thunder swap pool for the specified token
     * @param _token The token to find a pool for
     * @return The thunder swap pool address for the given token
     */
    function getPoolsFromToken(address _token) external view returns (address[] memory) {
        return s_tokenToPools[_token];
    }

    /**
     * @notice Gets the pool tokens supported by a specified pool
     * @param _pool The thunder swap pool
     * @return An array of the pool tokens supported by the thunder swap pool
     */
    function getPoolTokens(address _pool) external view returns (address[] memory) {
        return s_poolToTokens[_pool];
    }

    /**
     * @notice Gets the address of the pool that two tokens have
     * @param _token1 The address of the first token
     * @param _token2 The address of the second token
     * @return The address of the pool for _token1 and _token2
     */
    function getPoolFromPairing(address _token1, address _token2) external view returns (address) {
        return s_pairings[_token1][_token2];
    }
}
