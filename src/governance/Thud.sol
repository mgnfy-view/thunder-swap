// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { ERC20Permit, Nonces } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import { ERC20Votes } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

/**
 * @title THUD TOken
 * @author Sahil Gujrati aka mgnfy.view
 * @notice This is the key utility and governance token of the Thunder Swap protocol
 */
contract Thud is ERC20, ERC20Permit, ERC20Votes, Ownable {
    constructor(uint256 _initialSupply)
        ERC20("Thunder", "THUD")
        ERC20Permit("Thunder")
        Ownable(msg.sender)
    {
        _mint(msg.sender, _initialSupply);
    }

    // The following functions are overrides required by Solidity.
    function _update(
        address from,
        address to,
        uint256 value
    )
        internal
        override(ERC20, ERC20Votes)
    {
        super._update(from, to, value);
    }

    function nonces(address ownerOfNonce)
        public
        view
        override(ERC20Permit, Nonces)
        returns (uint256)
    {
        return super.nonces(ownerOfNonce);
    }
}
