// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title SingleAssetVault
/// @notice A simple vault that accepts deposits, issues shares, charges withdrawal fees, and can simulate yield
contract SingleAssetVault is Ownable {
    IERC20 public immutable token;

    uint256 public totalAssets;
    uint256 public totalShares;

    // Maps each user to their share balance
    mapping(address => uint256) public balances;

    // Withdrawal fee (e.g., 0.5% = 50 basis points)
    uint256 public constant WITHDRAW_FEE_BPS = 50; // 50 basis points = 0.5%
    uint256 public constant BPS_DIVISOR = 10_000;

    /// @notice Constructor sets the ERC-20 token that the vault will accept
    constructor(address _token) Ownable(msg.sender) {
        require(_token != address(0), "Invalid token address");
        token = IERC20(_token);
    }

    event Deposit(address indexed user, uint256 amount, uint256 shares);
    event Withdraw(address indexed user, uint256 amount, uint256 shares, uint256 fee);
    event YieldAdded(uint256 amount);

    /// @notice Deposit tokens and receive vault shares
    /// @param amount The amount of tokens to deposit
    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");

        // Transfer tokens from user to vault
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        // Calculate shares to mint
        uint256 shares;
        if (totalShares == 0) {
            shares = amount; // 1:1 for first depositor
        } else {
            shares = (amount * totalShares) / totalAssets;
        }

        require(shares > 0, "Shares must be > 0");

        // Update state
        totalAssets += amount;
        totalShares += shares;
        balances[msg.sender] += shares;

        emit Deposit(msg.sender, amount, shares);
    }

    /// @notice Withdraw tokens by burning vault shares
    /// @param shares The number of shares to redeem
    function withdraw(uint256 shares) external {
        require(shares > 0, "Shares must be > 0");
        require(balances[msg.sender] >= shares, "Not enough shares");

        // Calculate proportional token amount
        uint256 tokensOwed = (shares * totalAssets) / totalShares;
        require(tokensOwed > 0, "Nothing to withdraw");

        // Calculate withdrawal fee
        uint256 fee = (tokensOwed * WITHDRAW_FEE_BPS) / BPS_DIVISOR;
        uint256 netAmount = tokensOwed - fee;

        // Update state
        totalAssets -= tokensOwed;
        totalShares -= shares;
        balances[msg.sender] -= shares;

        // Transfer tokens to user
        require(token.transfer(msg.sender, netAmount), "Transfer failed");

        emit Withdraw(msg.sender, netAmount, shares, fee);
    }

    /// @notice Add yield to the vault, increasing totalAssets without minting shares
    /// @param amount The amount of tokens to add as yield
    function addYield(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be > 0");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        totalAssets += amount;

        emit YieldAdded(amount);
    }
}
