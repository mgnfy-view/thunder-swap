// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title The token to keep track of the shares of the pool held by LPs
 * @author mgnfy-view
 * @notice This is the ERC20 token that each `ThunderSwaPool` uses to keep track of the liquidity
 * supplied by LPs
 */
contract LiquidityProviderToken is ERC20, Ownable {
    constructor(
        string memory _name,
        string memory _symbol
    )
        ERC20(_name, _symbol)
        Ownable(msg.sender)
    { }

    /**
     * @notice Mints the specified amount of LP tokens to the specified account
     * @param _account The receiver of LP tokens
     * @param _amount The amount of LP tokens to mint
     */
    function mint(address _account, uint256 _amount) external onlyOwner {
        _mint(_account, _amount);
    }

    /**
     * @notice Burns the specified amount of LP tokens held by the specified account
     * @param _account The account whose LP tokens are to be burnt
     * @param _amount The amount of LP tokens to burn
     */
    function burn(address _account, uint256 _amount) external onlyOwner {
        _burn(_account, _amount);
    }
}
