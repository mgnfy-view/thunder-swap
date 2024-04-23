// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { GovernanceHelper } from "../../utils/helpers/GovernanceHelper.sol";

contract GovernanceTests is GovernanceHelper {
    function testCantSupportNewTokensWithoutGovernance() public {
        vm.expectRevert();
        thunderSwapPoolFactory.setSupportedToken(address(1));
    }

    function testSupportNewTokenByGovernance() public airdrop(user1, INITIAL_SUPPLY) {
        bytes memory encodedFunctionCall =
            abi.encodeWithSignature("setSupportedToken(address)", address(thud));
        string memory description = "Support $THUD swapping";
        addressesToCall.push(address(thunderSwapPoolFactory));
        values.push(0);
        functionCalls.push(encodedFunctionCall);
        vm.startPrank(user1);
        thud.delegate(user1);
        vm.roll(2000);
        uint256 proposalId = governor.propose(addressesToCall, values, functionCalls, description);
        vm.stopPrank();

        vm.warp(block.timestamp + VOTING_DELAY + 1);
        vm.roll(block.number + VOTING_DELAY + 1);

        string memory reason = "";
        // 0 = Against, 1 = For, 2 = Abstain for this example
        uint8 voteWay = 1;
        vm.prank(user1);
        governor.castVoteWithReason(proposalId, voteWay, reason);

        vm.warp(block.timestamp + VOTING_PERIOD + 1);
        vm.roll(block.number + VOTING_PERIOD + 1);

        bytes32 descriptionHash = keccak256(abi.encodePacked(description));
        governor.queue(addressesToCall, values, functionCalls, descriptionHash);
        vm.roll(block.number + MIN_DELAY + 1);
        vm.warp(block.timestamp + MIN_DELAY + 1);

        governor.execute(addressesToCall, values, functionCalls, descriptionHash);

        assertEq(thunderSwapPoolFactory.isTokenSupported(address(thud)), true);
    }
}
