/*

___________.__                      .___               _________                       
\__    ___/|  |__  __ __  ____    __| _/___________   /   _____/_  _  _______  ______  
  |    |   |  |  \|  |  \/    \  / __ |/ __ \_  __ \  \_____  \\ \/ \/ /\__  \ \____ \ 
  |    |   |   Y  \  |  /   |  \/ /_/ \  ___/|  | \/  /        \\     /  / __ \|  |_> >
  |____|   |___|  /____/|___|  /\____ |\___  >__|    /_______  / \/\_/  (____  /   __/ 
                \/           \/      \/    \/                \/              \/|__|    

*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { IThunderSwapReceiver } from "../ThunderSwapReceiver/interfaces/IThunderSwapReceiver.sol";
import { LiquidityProviderToken } from "./LiquidityProviderToken.sol";

import { IThunderSwapPool } from "./interfaces/IThunderSwapPool.sol";
import { LiquiditySupplyAndSwapMath } from "./lib/LiquiditySupplyAndSwapMath.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ThunderSwapPool is IThunderSwapPool, ReentrancyGuard {
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
    error IncompatibleContract();

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

    /**
     * @inheritdoc IThunderSwapPool
     */
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

    /**
     * @inheritdoc IThunderSwapPool
     */
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

    /**
     * @inheritdoc IThunderSwapPool
     */
    function flashSwapExactInput(
        IERC20 _inputToken,
        uint256 _inputAmount,
        uint256 _minimumOutputTokenToReceive,
        address _receiver,
        bool _callContract,
        bool _callBeforeHook,
        bool _callAfterHook,
        uint256 _deadline
    )
        external
        nonReentrant
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
            _inputToken,
            _inputAmount,
            outputToken,
            outputTokenAmount,
            _receiver,
            _callContract,
            _callBeforeHook,
            _callAfterHook
        );
    }

    /**
     * @inheritdoc IThunderSwapPool
     */
    function flashSwapExactOutput(
        IERC20 _outputToken,
        uint256 _outputAmount,
        uint256 _maximumInputTokensToSend,
        address _receiver,
        bool _callContract,
        bool _callBeforeHook,
        bool _callAfterHook,
        uint256 _deadline
    )
        external
        nonReentrant
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
            inputToken,
            inputAmountToSend,
            _outputToken,
            _outputAmount,
            _receiver,
            _callContract,
            _callBeforeHook,
            _callAfterHook
        );
    }

    /**
     * @return The pool token 1 contract
     */
    function getPoolToken1() external view returns (IERC20) {
        return i_poolToken1;
    }

    /**
     * @return The pool token 2 contract
     */
    function getPoolToken2() external view returns (IERC20) {
        return i_poolToken2;
    }

    /**
     * @return The liquidity provider token contract
     */
    function getLiquidityProviderToken() external view returns (IERC20) {
        return i_liquidityProviderToken;
    }

    /**
     * @return The minimum pool token 1 amount to add as liquidity
     */
    function getMinimumPoolToken1ToSupply() external pure returns (uint256) {
        return MINIMUM_POOL_TOKEN_1_TO_DEPOSIT;
    }

    /**
     * @notice Gets the fee taken on each flash swap (or normal swap)
     * @return The fee numerator
     * @return The fee denominator
     */
    function getSwapFee() external pure returns (uint256, uint256) {
        return (FEE_NUMERATOR, FEE_DENOMINATOR);
    }

    /**
     * @return The total LP token supply
     */
    function getTotalLiquidityProviderTokenSupply() public view returns (uint256) {
        return i_liquidityProviderToken.totalSupply();
    }

    /**
     * @return The total amount of pool token 1 held by this protocol
     */
    function getPoolToken1Reserves() public view returns (uint256) {
        return i_poolToken1.balanceOf(address(this));
    }

    /**
     * @return The total amount of pool token 2 held by this protocol
     */
    function getPoolToken2Reserves() public view returns (uint256) {
        return i_poolToken2.balanceOf(address(this));
    }

    /**
     * @notice Checks if the specified token is used by this pool
     * @param _token The token to check
     * @return True or false depending on whether it is a pool token or not
     */
    function isPoolToken(IERC20 _token) public view returns (bool) {
        if (_token == i_poolToken1 || _token == i_poolToken2) return true;
        return false;
    }

    /**
     * @notice Calculates the amount of pool token 2 to supply as liquidity for a specified
     * pool token 1 amount
     * @param _poolToken1Amount The amount of pool token 1 liquidity you want to add
     * @return The amount of pool token 2 to supply as liquidity
     */
    function getPoolToken2LiquidityToAddBasedOnPoolToken1Amount(uint256 _poolToken1Amount)
        public
        view
        returns (uint256)
    {
        return LiquiditySupplyAndSwapMath.getPoolToken2LiquidityToAddBasedOnPoolToken1Amount(
            _poolToken1Amount, getPoolToken1Reserves(), getPoolToken2Reserves()
        );
    }

    /**
     * @notice Calculates the amount of pool token 1 to supply as liquidity for a specified
     * pool token 2 amount
     * @param _poolToken2Amount The amount of pool token 2 liquidity you want to add
     * @return The amount of pool token 1 to supply as liquidity
     */
    function getPoolToken1LiquidityToAddBasedOnPoolToken2Amount(uint256 _poolToken2Amount)
        external
        view
        returns (uint256)
    {
        return LiquiditySupplyAndSwapMath.getPoolToken2LiquidityToAddBasedOnPoolToken1Amount(
            _poolToken2Amount, getPoolToken1Reserves(), getPoolToken2Reserves()
        );
    }

    /**
     * @notice Calculates the amount of LP tokens to mint based on the amount of pool token 1
     * to supply as liquidity
     * @param _poolToken1AmountToDeposit The amount of pool token 1 liquidity you want to add
     * @return The amount of LP tokens to mint
     */
    function getLiquidityProviderTokensToMint(uint256 _poolToken1AmountToDeposit)
        public
        view
        returns (uint256)
    {
        return LiquiditySupplyAndSwapMath.getLiquidityProviderTokensToMint(
            _poolToken1AmountToDeposit,
            getTotalLiquidityProviderTokenSupply(),
            getPoolToken1Reserves()
        );
    }

    /**
     * @notice Calculates the amount of input pool token to send based on the amount of output
     * pool token you want to receive as output
     * @param _outputAmount The amount of output pool token you want to receive
     * @param _inputReserves The total amount of input pool token supply held by this protocol
     * @param _outputReserves The total amount of output pool token supply held by this protocol
     */
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
        return LiquiditySupplyAndSwapMath.getInputBasedOnOuput(
            _outputAmount, _inputReserves, _outputReserves, FEE_NUMERATOR, FEE_DENOMINATOR
        );
    }

    /**
     * @notice Calculates the amount of output pool token to receive based on the amount of input
     * pool token you want to send
     * @param _inputAmount The amount of output pool token you want to receive
     * @param _inputReserves The total amount of input pool token supply held by this protocol
     * @param _outputReserves The total amount of output pool token supply held by this protocol
     */
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
        return LiquiditySupplyAndSwapMath.getOutputBasedOnInput(
            _inputAmount, _inputReserves, _outputReserves, FEE_NUMERATOR, FEE_DENOMINATOR
        );
    }

    /**
     * @notice Transfers pool token 1 and pool token 2 amounts from the user to the protocol. Helper
     * for the `addLiquidity` function
     * @param _poolToken1Amount The amount of pool token 1 to supply
     * @param _poolToken2Amount The amount of pool token 2 to supply
     * @param _liquidityProviderTokensToMint The amount of LP tokens to mint to the LP
     */
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

    /**
     * @notice Sends pool token 1 and pool token 2 amount to the LP. Helper for the
     * `withdrawLiquidity` function
     * @param _liquidityProviderTokensToBurn The amount of LP tokens to burn
     * @param _poolToken1AmountToWithdraw The amount of pool token 1 to withdraw
     * @param _poolToken2AmountToWithdraw The amount of pool token 2 to withdraw
     */
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

    /**
     * @notice Flash swaps input token amount for the output token amount. The output token is first
     * sent to the receiver, and the `onThunderSwapReceived()` function is called if `_callContract`
     * is set to true. Then, in the same transaction, the receiver contract approves the amount of
     * input token to send, and this function transfers the amount to the protocol. There can be no
     * intermediate contract, and wallets can directly swap tokens as well by setting
     * `_callContract` to false, and `receiver` to the wallet address
     * @param _inputToken The input token
     * @param _inputAmount The input token amount
     * @param _outputToken The output token
     * @param _outputAmount The output token amount
     * @param _receiver The receiver of the flash swap
     * @param _callContract If true, call the `onThunderSwapReceived()` function on the receiver
     * contract
     * @param _callBeforeHook if true, calls the `beforeThunderSwapReceived` hook on the receiver
     * contract
     * @param _callAfterHook if true, calls the `afterThunderSwapReceived` hook on the receiver
     * contract
     */
    function _flashSwap(
        IERC20 _inputToken,
        uint256 _inputAmount,
        IERC20 _outputToken,
        uint256 _outputAmount,
        address _receiver,
        bool _callContract,
        bool _callBeforeHook,
        bool _callAfterHook
    )
        internal
    {
        _outputToken.safeTransfer(_receiver, _outputAmount);

        if (_callContract && _callBeforeHook) {
            IThunderSwapReceiver(_receiver).beforeThunderSwapReceived(
                _inputToken, _inputAmount, _outputToken, _outputAmount
            );
        }
        if (_callContract) {
            (string memory check) = IThunderSwapReceiver(_receiver).onThunderSwapReceived(
                _inputToken, _inputAmount, _outputToken, _outputAmount
            );
            if (keccak256(abi.encodePacked(check)) != keccak256(abi.encodePacked("Thunder Swap"))) {
                revert IncompatibleContract();
            }
        }
        _inputToken.safeTransferFrom(_receiver, address(this), _inputAmount);
        if (_callContract && _callAfterHook) {
            IThunderSwapReceiver(_receiver).afterThunderSwapReceived(
                _inputToken, _inputAmount, _outputToken, _outputAmount
            );
        }

        emit FlashSwapped(msg.sender, _inputToken, _outputToken, _inputAmount, _outputAmount);
    }
}
