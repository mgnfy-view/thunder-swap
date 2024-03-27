// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Token } from "../mocks/Token.sol";

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ThunderSwapPool } from "@src/core/ThunderSwapPool.sol";
import { ThunderSwapPoolFactory } from "@src/core/ThunderSwapPoolFactory.sol";

import { Test } from "forge-std/Test.sol";

contract UniversalHelper is Test {
    address public deployer;
    address public user1;
    address public user2;
    Token public tokenA;
    Token public tokenB;
    ThunderSwapPoolFactory public thunderSwapPoolFactory;
    ThunderSwapPool public thunderSwapPool;

    error InputValueZeroNotAllowed();
    error DeadlinePassed(uint256 _deadline);
    error NotAPoolToken(IERC20 poolToken);
    error ReceiverZeroAddress();

    function setUp() public {
        deployer = makeAddr("deployer");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");

        vm.startPrank(deployer);
        tokenA = new Token("TokenA", "A");
        tokenB = new Token("TokenB", "B");
        thunderSwapPoolFactory = new ThunderSwapPoolFactory();
        thunderSwapPoolFactory.setSupportedToken(address(tokenA));
        thunderSwapPoolFactory.setSupportedToken(address(tokenB));
        thunderSwapPool =
            thunderSwapPoolFactory.deployThunderSwapPool(address(tokenA), address(tokenB));
        vm.stopPrank();
    }

    modifier distributeTokensToUsers(uint256 _poolToken1Amount, uint256 _poolToken2Amount) {
        vm.startPrank(deployer);
        tokenA.mint(deployer, _poolToken1Amount);
        tokenB.mint(deployer, _poolToken2Amount);

        tokenA.mint(user1, _poolToken1Amount);
        tokenB.mint(user1, _poolToken2Amount);

        tokenA.mint(user2, _poolToken1Amount);
        tokenB.mint(user2, _poolToken2Amount);
        vm.stopPrank();
        _;
    }

    modifier addInitialLiquidity(uint256 _poolToken1Amount, uint256 _poolToken2Amount) {
        vm.startPrank(deployer);
        tokenA.approve(address(thunderSwapPool), _poolToken1Amount);
        tokenB.approve(address(thunderSwapPool), _poolToken2Amount);
        thunderSwapPool.addLiquidity(
            _poolToken1Amount,
            _poolToken2Amount,
            _poolToken2Amount,
            _poolToken1Amount,
            uint256(block.timestamp)
        );
        vm.stopPrank();
        _;
    }
}
