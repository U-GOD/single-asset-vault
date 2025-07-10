// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title TestToken
/// @notice A simple ERC20 token to simulate a stablecoin like USDC
contract TestToken is ERC20 {
    /// @notice Constructor sets token name and symbol, and mints initial supply to deployer
    constructor(uint256 initialSupply) ERC20("TestToken", "TTK") {
        _mint(msg.sender, initialSupply);
    }
}