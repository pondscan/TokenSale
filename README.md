# TokenSale Smart Contract

## Overview
This `TokenSale` smart contract is designed for conducting token sales on the Magma Testnet. It allows the contract owner to set a specific ERC20 token contract and adjust the token sale rate, making it versatile for various token sale scenarios.

For simplicity, you may access your Token Sale Admin panel here: https://pondscan.github.io/TokenSale/

## Features
- Settable ERC20 token contract post-deployment.
- Adjustable token sale rate by the contract owner.
- Direct purchase of tokens by sending ETH (LAVA) to the contract.
- Functionality for the owner to end the sale, withdrawing remaining tokens and ETH.

## Prerequisites
- Solidity ^0.8.0
- An ERC20 token contract deployed on the Ethereum network.
- Ethereum wallet with deployment capabilities (e.g., MetaMask).
- Deployment environment (e.g., Remix IDE, Truffle, or Hardhat).

## Deployment
1. **Prepare the Environment**: Choose your preferred Solidity development and deployment environment.
2. **Deploy the Contract**: Use the provided `TokenSale.sol` smart contract code for deployment. At the time of deployment, the contract does not require any constructor parameters.
3. **Verify Contract Ownership**: After deployment, the account used for deploying the contract is automatically set as the contract owner.

## Usage
### For Contract Owners
- **Setting the Token Contract**: Call `setTokenContract` with the address of the ERC20 token contract you wish to sell through this contract.
- **Deposit ERC20 Tokens**: Simply send your ERC20 you wish to sell, directly to your TokenSale contract address.
- **Setting the Sale Rate**: Determine the rate at which you want to sell your tokens (tokens per ETH) and call `setRate` with this value.
- **Ending the Sale**: To end the sale, withdraw remaining tokens and collected ETH, call `endSale`.

### For Buyers
- **Buying Tokens**: Send ETH directly to the contract's address to purchase tokens at the current rate. The equivalent amount of tokens will be transferred to your address.

## Important Considerations
- Ensure the token contract address and sale rate are set before attempting to buy tokens.
- Only the owner can set the token contract address, sale rate, and end the sale.
- The contract's ETH balance is transferred to the owner when the sale is ended, along with any unsold tokens.
- If insufficent tokens are held in the TokenSale contract, the transaction "sale" will revert.
- This is a development version, please test thouroulgy and use at your own risk!

## Support
For additional assistance or inquiries, consider opening an issue on this GitHub repository or contact @pondscan x.com/pondscan.
