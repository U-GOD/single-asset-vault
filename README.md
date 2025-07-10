# Single Asset Vault

A simple ERC20 token vault built in Solidity to practice DeFi primitives.

## Overview

This contract allows users to:

- Deposit ERC20 tokens and receive proportional vault shares.
- Simulate yield by adding extra tokens to the vault.
- Withdraw tokens, including accumulated yield, with a configurable withdrawal fee.

## Features

- ERC20 deposit and share minting
- Accurate proportional accounting of deposits and withdrawals
- Yield simulation for testing rewards
- Fee deduction on withdrawal

## How to Use

1. **Deploy TestToken.sol**

   Deploy an ERC20 token (TestToken) to act as the vault asset.

2. **Deploy SingleAssetVault.sol**

   Deploy the vault contract, passing the TestToken address to the constructor.

3. **Approve Tokens**

   From your wallet, call `approve()` on the TestToken contract to allow the vault to transfer tokens on your behalf.

4. **Deposit**

   Call `deposit(amount)` to deposit tokens and receive shares.

5. **Simulate Yield**

   Call `addYield(amount)` to simulate profits being added to the vault.

6. **Withdraw**

   Call `withdraw(shares)` to redeem your shares for tokens minus the withdrawal fee.

## Technical Details

- Fixed withdrawal fee: 0.1%
- Fee recipient: contract owner
- All balances and shares are tracked proportionally

## Built With

- Solidity ^0.8.20
- zkSync Era Sepolia Testnet
- Remix IDE and MetaMask

## License

MIT
