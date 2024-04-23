// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { AirdropManagerHelper } from "../../utils/helpers/AirdropManagerHelper.sol";
import { Token } from "../../utils/mocks/Token.sol";

contract AirdropManagerTests is AirdropManagerHelper {
    function testAirdroppingFailsIfAccountLimitBreached() public {
        for (uint256 count = 0; count < 200; ++count) {
            recipients.push(user1);
            amounts.push((count * 1e18) / 5);
        }

        vm.expectRevert(
            abi.encodeWithSelector(LimitBreached.selector, 200, airdropManager.getAirdropLimit())
        );
        vm.startPrank(owner);
        airdropManager.airdrop(recipients, amounts, 0);
        vm.stopPrank();
    }

    function testAirdropFailsOnInsufficientBalanceHeld() public {
        for (uint256 count = 0; count < 100; ++count) {
            recipients.push(makeAddr("mock user"));
            amounts.push((count * 1e18) / 5);
        }

        vm.expectRevert(InsufficientTokenBalance.selector);
        vm.prank(owner);
        airdropManager.airdrop(recipients, amounts, 0);
    }

    function testAirdrop() public {
        uint256 totalAmount = 0;
        for (uint256 count = 0; count < 100; ++count) {
            recipients.push(user1);
            amounts.push((count * 1e18) / 5);
            totalAmount += amounts[count];
        }

        vm.startPrank(owner);
        thud.transfer(address(airdropManager), initialThudSupply);
        airdropManager.airdrop(recipients, amounts, 0);
        vm.stopPrank();

        assertEq(thud.balanceOf(user1), totalAmount);
    }

    function testAirdropEmitsEvent() public {
        uint256 totalAmount = 0;
        for (uint256 count = 0; count < 100; ++count) {
            recipients.push(user1);
            amounts.push((count * 1e18) / 5);
            totalAmount += amounts[count];
        }

        vm.startPrank(owner);
        thud.transfer(address(airdropManager), initialThudSupply);
        vm.expectEmit();
        emit TokensAirdropped(address(thud), totalAmount);
        airdropManager.airdrop(recipients, amounts, 0);
        vm.stopPrank();
    }

    function testAddingTokenRevertsIfAlreadyAdded() public {
        vm.prank(owner);
        vm.expectRevert(TokenAlreadySupported.selector);
        airdropManager.addToken(address(thud));
    }

    function testAddingTokenEmitsEvent() public {
        vm.startPrank(owner);
        Token mockToken = new Token("mock token", "mktkn");
        vm.expectEmit();
        emit TokenSupported(address(mockToken));
        airdropManager.addToken(address(mockToken));
        vm.stopPrank();
    }

    function testWithdrawTokenAmountFromAirdropManager() public {
        uint256 withdrawAmount = 100e18;

        vm.startPrank(owner);
        thud.transfer(address(airdropManager), initialThudSupply);
        airdropManager.withdrawAmount(withdrawAmount, 0);
        vm.stopPrank();

        assertEq(thud.balanceOf(owner), withdrawAmount);
    }

    function testWithdrawAllTokenAmountFromAirdropManager() public {
        vm.startPrank(owner);
        thud.transfer(address(airdropManager), initialThudSupply);
        airdropManager.withdrawAllBalance(0);
        vm.stopPrank();

        assertEq(thud.balanceOf(owner), initialThudSupply);
    }

    function testCheckTokenBalanceheld() public {
        vm.prank(owner);
        thud.transfer(address(airdropManager), initialThudSupply);

        assertEq(thud.balanceOf(address(airdropManager)), airdropManager.checkTokenBalanceHeld(0));
    }

    function testGetToken() public view {
        assertEq(airdropManager.getToken(0), address(thud));
    }

    function testGetAirdropLimit() public view {
        assertEq(airdropManager.getAirdropLimit(), 150);
    }
}
