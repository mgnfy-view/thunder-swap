// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title Aidrop Manager
 * @author Sahil Gujrati aka mgnfy.view
 * @notice This contract serves as a manager to drop various supported tokens to users
 */
contract AirdropManager is Ownable {
    using SafeERC20 for IERC20;

    address[] private s_tokens;
    mapping(address token => bool isSupported) private s_supportedTokens;
    uint256 constant AIRDROP_LIMIT = 150;

    error AirdropManager__LimitBreached(
        uint256 numberOfRecepients, uint256 allowedNumberOfRecepients
    );
    error AirdropManager__TokenAlreadySupported();
    error AirdropManager__InsufficientTokenBalance();

    event AirdropManager__TokenSupported(address token);
    event AirdropManager__TokensAirdropped(address token, uint256 totalAmount);

    constructor(address[] memory _tokens) Ownable(msg.sender) {
        uint256 length = _tokens.length;
        for (uint256 count; count < length; count++) {
            s_tokens.push(_tokens[count]);
            s_supportedTokens[_tokens[count]] = true;
        }
    }

    /**
     * @notice Airdrops specified amounts of a token to sepcified recipients
     * @param _recipients Beneficiaries of the airdrop
     * @param _amounts The exact amounts to airdrop to recipients
     * @param _tokenIndex Gets the token to airdrop from the supported tokens list
     */
    function airdrop(
        address[] memory _recipients,
        uint256[] memory _amounts,
        uint256 _tokenIndex
    )
        external
        onlyOwner
    {
        if (_recipients.length > AIRDROP_LIMIT) {
            revert AirdropManager__LimitBreached(_recipients.length, AIRDROP_LIMIT);
        }
        address token = s_tokens[_tokenIndex];
        uint256 totalAmount = 0;
        if (IERC20(token).balanceOf(address(this)) == 0) {
            revert AirdropManager__InsufficientTokenBalance();
        }
        for (uint256 count = 0; count < _recipients.length; count++) {
            require(_recipients[count] != address(0));
            IERC20(token).safeTransfer(_recipients[count], _amounts[count]);
            totalAmount += _amounts[count];
        }

        emit AirdropManager__TokensAirdropped(token, totalAmount);
    }

    /**
     * @notice Support a new token for airdrop
     * @param _token The token to support
     */
    function addToken(address _token) external onlyOwner {
        if (s_supportedTokens[_token]) revert AirdropManager__TokenAlreadySupported();
        s_supportedTokens[_token] = true;
        s_tokens.push(_token);
        emit AirdropManager__TokenSupported(_token);
    }

    /**
     * @notice Withdraws a specific amount of the given token from this contract
     * @param _amount The amount to withdraw
     * @param _tokenIndex Gets the token to airdrop from the supported tokens list
     */
    function withdrawAmount(uint256 _amount, uint256 _tokenIndex) external onlyOwner {
        IERC20(s_tokens[_tokenIndex]).safeTransfer(owner(), _amount);
    }

    /**
     * @notice Withdraws all amount of the given token held by this contract
     * @param _tokenIndex Gets the token to airdrop from the supported tokens list
     */
    function withdrawAllBalance(uint256 _tokenIndex) external onlyOwner {
        address token = s_tokens[_tokenIndex];
        uint256 balance = IERC20(token).balanceOf(address(this));
        IERC20(token).safeTransfer(owner(), balance);
    }

    /**
     * @notice Gets the balance of the given token held by this contract
     * @param _tokenIndex Gets the token to airdrop from the supported tokens list
     */
    function checkTokenBalanceHeld(uint256 _tokenIndex) external view returns (uint256) {
        address token = s_tokens[_tokenIndex];
        return IERC20(token).balanceOf(address(this));
    }

    /**
     * @notice Gets the token to airdrop from the supported tokens list
     * @param _tokenIndex The index of the token in the supported tokens list
     */
    function getToken(uint256 _tokenIndex) external view returns (address) {
        return s_tokens[_tokenIndex];
    }
}
