// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {PoolFactoryHelper} from "../../utils/helpers/PoolFactoryHelper.sol";
import {UniversalHelper} from "../../utils/helpers/UniversalHelper.sol";
import {Token} from "../../utils/mocks/Token.sol";

contract DeployPool is UniversalHelper, PoolFactoryHelper {
    function testDeployingThunderSwapPoolRevertsIfTokenNotSupported() public {
        address tokenAddress = makeAddr("unsupportedToken");

        vm.expectRevert(abi.encodeWithSelector(TokenNotSupported.selector, tokenAddress));
        thunderSwapPoolFactory.deployThunderSwapPool(tokenAddress, tokenAddress);
    }

    function testDeployingThunderSwapPoolRevertsIfBothTokensAreTheSame() public {
        address tokenAddress = makeAddr("unsupportedToken");

        vm.prank(deployer);
        thunderSwapPoolFactory.setSupportedToken(tokenAddress);
        vm.expectRevert(PoolCannotHaveTwoTokensOfTheSameType.selector);
        thunderSwapPoolFactory.deployThunderSwapPool(tokenAddress, tokenAddress);
    }

    function testDeployingThunderSwapPoolRevertsIfPoolAlreadyExists() public distributeTokensToUsers(1e18, 2e18) addInitialLiquidity(1e18, 2e18) {
        vm.expectRevert(abi.encodeWithSelector(PoolAlreadyExists.selector, address(thunderSwapPool)));
        thunderSwapPoolFactory.deployThunderSwapPool(address(tokenB), address(tokenA));
    }

    function testDeployingThunderSwapPoolEmitsEvent() public {
        Token tokenC = new Token("TokenC", "C");
        Token tokenD = new Token("TokenD", "D");

        vm.startPrank(deployer);
        thunderSwapPoolFactory.setSupportedToken(address(tokenC));
        thunderSwapPoolFactory.setSupportedToken(address(tokenD));

        vm.expectEmit(false, true, true, false);
        emit PoolCreated(address(0), address(tokenC), address(tokenD));
        thunderSwapPoolFactory.deployThunderSwapPool(address(tokenC), address(tokenD));
        vm.stopPrank();
    }
}