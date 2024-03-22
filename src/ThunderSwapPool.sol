// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { LiquidityProviderToken } from "./LiquidityProviderToken.sol";
import { IThunderSwapPool } from "./interfaces/IThunderSwapPool.sol";
import { IThunderSwapReceiver } from "./interfaces/IThunderSwapReceiver.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ThunderSwapPool is IThunderSwapPool {
    using SafeERC20 for IERC20;

    IERC20 private immutable i_poolToken1;
    IERC20 private immutable i_poolToken2;
    LiquidityProviderToken private immutable i_liquidityProviderToken;
    uint256 private constant MINIMUM_POOL_TOKEN_1_TO_DEPOSIT = 1e9;
    uint256 private constant FEE_NUMERATOR = 997;
    uint256 private constant FEE_DENOMINATOR = 1000;

    event LiquidityProviderTokenDeployed(address indexed liquidityProviderToken);
    event LiquidityAdded(
        address indexed liquidityProvider,
        uint256 indexed poolToken1Amount,
        uint256 indexed poolToken2Amount
    );
    event LiquidityWithdrawn(
        address liquidityProvider,
        uint256 indexed liquidityProviderTokensBurnt,
        uint256 indexed poolToken1AmountWithdrawn,
        uint256 indexed poolToken2AmountWithdrawn
    );
    event FlashSwapped(
        address user,
        IERC20 inputToken,
        IERC20 outputToken,
        uint256 indexed inputAmount,
        uint256 indexed outputAmount
    );

    error InputValueZeroNotAllowed();
    error DeadlinePassed(uint256 _deadline);
    error LiquidityToAddTooLow(uint256 liquidityToAdd, uint256 minimumPoolToken1ToDeposit);
    error LiquidityProviderTokensToMintTooLow(
        uint256 liquidityProviderTokensToMint, uint256 minimumLiquidityProviderTokensToMint
    );
    error NotAPoolToken(IERC20 poolToken);
    error PoolTokensToDepositGreaterThanMaximumPoolTokensToDeposit(
        IERC20 poolToken, uint256 poolTokensToDeposit, uint256 maximumPoolTokensToDeposit
    );
    error PoolTokensToWithdrawLessThanMinimumPoolTokensToWithdraw(
        IERC20 poolToken, uint256 poolTokensToWithdraw, uint256 minimumPoolTokensToWithdraw
    );
    error ReceiverZeroAddress();
    error PoolTokenToReceiveLessThanMinimumPoolTokenToReceive(
        IERC20 outputToken, uint256 outputAmount, uint256 minimumOutputAmount
    );
    error PoolTokenToSendMoreThanMaximumPoolTokenToSend(
        IERC20 inputToken, uint256 inputAmount, uint256 maximumInputAmount
    );

    modifier notZero(uint256 _inputValue) {
        if (_inputValue == 0) revert InputValueZeroNotAllowed();
        _;
    }

    modifier beforeDeadline(uint256 _deadline) {
        if (_deadline < block.timestamp) revert DeadlinePassed(_deadline);
        _;
    }

    constructor(
        address _poolToken1,
        address _poolToken2,
        string memory _liquidityProviderTokenName,
        string memory _liquidityProviderTokenSymbol
    ) {
        i_liquidityProviderToken =
            new LiquidityProviderToken(_liquidityProviderTokenName, _liquidityProviderTokenSymbol);
        i_poolToken1 = IERC20(_poolToken1);
        i_poolToken2 = IERC20(_poolToken2);

        emit LiquidityProviderTokenDeployed(address(i_liquidityProviderToken));
    }

    function addLiquidity(
        uint256 _poolToken1Amount,
        uint256 _poolToken2Amount,
        uint256 _maximumPoolToken2ToDeposit,
        uint256 _minimumLiquidityProviderTokensToMint,
        uint256 _deadline
    )
        external
        notZero(_poolToken1Amount)
        notZero(_poolToken2Amount)
        notZero(_maximumPoolToken2ToDeposit)
        beforeDeadline(_deadline)
    {
        if (_poolToken1Amount < MINIMUM_POOL_TOKEN_1_TO_DEPOSIT) {
            revert LiquidityToAddTooLow(_poolToken1Amount, MINIMUM_POOL_TOKEN_1_TO_DEPOSIT);
        }

        if (getTotalLiquidityProviderTokenSupply() == 0) {
            _addLiquidity(_poolToken1Amount, _poolToken2Amount, _poolToken1Amount);
        } else {
            uint256 poolToken2ToDeposit =
                getPoolToken2LiquidityToAddBasedOnPoolToken1Amount(_poolToken1Amount);
            if (poolToken2ToDeposit > _maximumPoolToken2ToDeposit) {
                revert PoolTokensToDepositGreaterThanMaximumPoolTokensToDeposit(
                    i_poolToken2, poolToken2ToDeposit, _maximumPoolToken2ToDeposit
                );
            }

            uint256 liquidityProviderTokensToMint =
                getLiquidityProviderTokensToMint(_poolToken1Amount);
            if (liquidityProviderTokensToMint < _minimumLiquidityProviderTokensToMint) {
                revert LiquidityProviderTokensToMintTooLow(
                    liquidityProviderTokensToMint, _minimumLiquidityProviderTokensToMint
                );
            }

            _addLiquidity(_poolToken1Amount, poolToken2ToDeposit, liquidityProviderTokensToMint);
        }
    }

    function withdrawLiquidity(
        uint256 _liquidityProviderTokensToBurn,
        uint256 _minimumPoolToken1ToWithdraw,
        uint256 _minimumPoolToken2ToWithdraw,
        uint256 _deadline
    )
        external
        notZero(_liquidityProviderTokensToBurn)
        notZero(_minimumPoolToken1ToWithdraw)
        notZero(_minimumPoolToken2ToWithdraw)
        beforeDeadline(_deadline)
    {
        uint256 poolToken1Reserves = getPoolToken1Reserves();
        uint256 poolToken2Reserves = getPoolToken2Reserves();

        uint256 poolToken1AmountToWithdraw = (_liquidityProviderTokensToBurn * poolToken1Reserves)
            / getTotalLiquidityProviderTokenSupply();
        uint256 poolToken2AmountToWithdraw = (_liquidityProviderTokensToBurn * poolToken2Reserves)
            / getTotalLiquidityProviderTokenSupply();

        if (poolToken1AmountToWithdraw < _minimumPoolToken1ToWithdraw) {
            revert PoolTokensToWithdrawLessThanMinimumPoolTokensToWithdraw(
                i_poolToken1, poolToken1AmountToWithdraw, _minimumPoolToken1ToWithdraw
            );
        }

        if (poolToken2AmountToWithdraw < _minimumPoolToken2ToWithdraw) {
            revert PoolTokensToWithdrawLessThanMinimumPoolTokensToWithdraw(
                i_poolToken2, poolToken2AmountToWithdraw, _minimumPoolToken2ToWithdraw
            );
        }

        emit LiquidityWithdrawn(
            msg.sender,
            _liquidityProviderTokensToBurn,
            poolToken1AmountToWithdraw,
            poolToken2AmountToWithdraw
        );

        _withdrawLiquidity(
            _liquidityProviderTokensToBurn, poolToken1AmountToWithdraw, poolToken2AmountToWithdraw
        );
    }

    function flashSwapExactInput(
        IERC20 _inputToken,
        uint256 _inputAmount,
        uint256 _minimumOutputTokenToReceive,
        address _receiver,
        bool _callContract,
        uint256 _deadline
    )
        external
        notZero(_inputAmount)
        notZero(_minimumOutputTokenToReceive)
        beforeDeadline(_deadline)
    {
        if (!isPoolToken(_inputToken)) revert NotAPoolToken(_inputToken);
        if (_receiver == address(0)) revert ReceiverZeroAddress();

        IERC20 outputToken = _inputToken == i_poolToken1 ? i_poolToken2 : i_poolToken1;
        uint256 outputTokenAmount = getOutputBasedOnInput(
            _inputAmount, _inputToken.balanceOf(address(this)), outputToken.balanceOf(address(this))
        );
        if (outputTokenAmount < _minimumOutputTokenToReceive) {
            revert PoolTokenToReceiveLessThanMinimumPoolTokenToReceive(
                outputToken, outputTokenAmount, _minimumOutputTokenToReceive
            );
        }

        _flashSwap(
            _inputToken, _inputAmount, outputToken, outputTokenAmount, _receiver, _callContract
        );
    }

    function flashSwapExactOutput(
        IERC20 _outputToken,
        uint256 _outputAmount,
        uint256 _maximumInputTokensToSend,
        address _receiver,
        bool _callContract,
        uint256 _deadline
    )
        external
        notZero(_outputAmount)
        notZero(_maximumInputTokensToSend)
        beforeDeadline(_deadline)
    {
        if (!isPoolToken(_outputToken)) revert NotAPoolToken(_outputToken);
        if (_receiver == address(0)) revert ReceiverZeroAddress();

        IERC20 inputToken = _outputToken == i_poolToken1 ? i_poolToken2 : i_poolToken1;
        uint256 inputAmountToSend = getInputBasedOnOuput(
            _outputAmount,
            inputToken.balanceOf(address(this)),
            _outputToken.balanceOf(address(this))
        );
        if (inputAmountToSend > _maximumInputTokensToSend) {
            revert PoolTokenToSendMoreThanMaximumPoolTokenToSend(
                inputToken, inputAmountToSend, _maximumInputTokensToSend
            );
        }

        _flashSwap(
            inputToken, inputAmountToSend, _outputToken, _outputAmount, _receiver, _callContract
        );
    }

    function getPoolToken1() external view returns (IERC20) {
        return i_poolToken1;
    }

    function getPoolToken2() external view returns (IERC20) {
        return i_poolToken2;
    }

    function getLiquidityProviderToken() external view returns (IERC20) {
        return i_liquidityProviderToken;
    }

    function getMinimumPoolToken1ToSupply() external pure returns (uint256) {
        return MINIMUM_POOL_TOKEN_1_TO_DEPOSIT;
    }

    function getTotalLiquidityProviderTokenSupply() public view returns (uint256) {
        return i_liquidityProviderToken.totalSupply();
    }

    function getPoolToken1Reserves() public view returns (uint256) {
        return i_poolToken1.balanceOf(address(this));
    }

    function getPoolToken2Reserves() public view returns (uint256) {
        return i_poolToken2.balanceOf(address(this));
    }

    function isPoolToken(IERC20 _token) public view returns (bool) {
        if (_token == i_poolToken1 || _token == i_poolToken2) return true;
        return false;
    }

    function getPoolToken2LiquidityToAddBasedOnPoolToken1Amount(uint256 _poolToken1Amount)
        public
        view
        returns (uint256)
    {
        // p1: pool token 1 reserves, dp1: pool token 1 amount to deposit
        // p2: pool token 2 reserves, dp2: pool token 2 amount to deposit
        // (p1 + dp1) / (p2 + dp2) = p1 / p2
        // (p1 * p2) + (p2 * dp1) = (p1 * p2) + (p1 * dp2)
        // (p2 * dp1) = (p1 * dp2)
        // dp2 = (p2 * dp1) / p1
        return ((getPoolToken2Reserves() * _poolToken1Amount) / getPoolToken1Reserves());
    }

    function getPoolToken1LiquidityToAddBasedOnPoolToken2Amount(uint256 _poolToken2Amount)
        external
        view
        returns (uint256)
    {
        // p1: pool token 1 reserves, dp1: pool token 1 amount to deposit
        // p2: pool token 2 reserves, dp2: pool token 2 amount to deposit
        // (p1 + dp1) / (p2 + dp2) = p1 / p2
        // (p1 * p2) + (p2 * dp1) = (p1 * p2) + (p1 * dp2)
        // (p2 * dp1) = (p1 * dp2)
        // dp1 = (p1 * dp2) / p2
        return ((getPoolToken1Reserves() * _poolToken2Amount) / getPoolToken2Reserves());
    }

    function getLiquidityProviderTokensToMint(uint256 _poolToken1AmountToDeposit)
        public
        view
        returns (uint256)
    {
        // p: pool token 1 reserves, dp: pool token 1 amount to deposit
        // lp: total liquidity provider token supply
        // dlp: amount of liquidity provider token to mint to the liquidity provider
        // (p + dp) / (lp + dlp) = p / lp
        // (p * dp) + (dp * lp) = (p * lp) + (p * dlp)
        // dlp = (dp * lp) / p
        return (_poolToken1AmountToDeposit * getTotalLiquidityProviderTokenSupply())
            / getPoolToken1Reserves();
    }

    function getInputBasedOnOuput(
        uint256 _outputAmount,
        uint256 _inputReserves,
        uint256 _outputReserves
    )
        public
        pure
        notZero(_outputAmount)
        notZero(_inputReserves)
        notZero(_outputReserves)
        returns (uint256)
    {
        return (
            (FEE_DENOMINATOR * _inputReserves * _outputAmount)
                / (FEE_NUMERATOR * (_outputReserves - _outputAmount))
        );
    }

    function getOutputBasedOnInput(
        uint256 _inputAmount,
        uint256 _inputReserves,
        uint256 _outputReserves
    )
        public
        pure
        notZero(_inputAmount)
        notZero(_outputReserves)
        notZero(_inputReserves)
        returns (uint256)
    {
        return (FEE_NUMERATOR * _inputAmount * _outputReserves)
            / ((FEE_NUMERATOR * _inputAmount) + (FEE_DENOMINATOR * _inputReserves));
    }

    function _addLiquidity(
        uint256 _poolToken1Amount,
        uint256 _poolToken2Amount,
        uint256 _liquidityProviderTokensToMint
    )
        internal
    {
        emit LiquidityAdded(msg.sender, _poolToken1Amount, _poolToken2Amount);

        i_liquidityProviderToken.mint(msg.sender, _liquidityProviderTokensToMint);
        i_poolToken1.safeTransferFrom(msg.sender, address(this), _poolToken1Amount);
        i_poolToken2.safeTransferFrom(msg.sender, address(this), _poolToken2Amount);
    }

    function _withdrawLiquidity(
        uint256 _liquidityProviderTokensToBurn,
        uint256 _poolToken1AmountToWithdraw,
        uint256 _poolToken2AmountToWithdraw
    )
        internal
    {
        i_liquidityProviderToken.burn(msg.sender, _liquidityProviderTokensToBurn);
        i_poolToken1.safeTransfer(msg.sender, _poolToken1AmountToWithdraw);
        i_poolToken2.safeTransfer(msg.sender, _poolToken2AmountToWithdraw);
    }

    function _flashSwap(
        IERC20 _inputToken,
        uint256 _inputAmount,
        IERC20 _outputToken,
        uint256 _outputAmount,
        address _receiver,
        bool _callContract
    )
        internal
    {
        _outputToken.safeTransfer(_receiver, _outputAmount);
        if (_callContract) {
            IThunderSwapReceiver(_receiver).onThunderSwapReceived(
                _inputToken, _inputAmount, _outputToken, _outputAmount
            );
        }
        _inputToken.safeTransferFrom(_receiver, address(this), _inputAmount);

        emit FlashSwapped(msg.sender, _inputToken, _outputToken, _inputAmount, _outputAmount);
    }
}
