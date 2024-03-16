// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interface for ERC20 tokens to interact with the TokenSale contract.
interface IERC20 {
    // Allows the transfer of tokens from this contract to a recipient.
    function transfer(address recipient, uint256 amount) external returns (bool);
    
    // Returns the token balance of a given account.
    function balanceOf(address account) external view returns (uint256);
}

// The TokenSale contract enables the sale of ERC20 tokens in exchange for ETH (LAVA).
contract TokenSale {
    address private owner; // The owner of the contract, set to the deployer.
    IERC20 public tokenContract; // The ERC20 token being sold.
    uint256 public tokensSold; // Tracks the number of tokens sold through this contract.
    uint256 public rate; // Number of tokens per ETH (e.g., 1000 tokens per 1 ETH).

    // Event emitted when tokens are sold.
    event Sold(address buyer, uint256 amount);
    
    // Event emitted when the token contract address is updated.
    event TokenContractUpdated(address tokenContract);
    
    // Event emitted when the token sale rate is updated.
    event RateUpdated(uint256 newRate);

    // Modifier to restrict certain functions to only the contract owner.
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Constructor sets the initial owner of the contract to the deployer.
    constructor() {
        owner = msg.sender;
    }

    // Allows the owner to set the ERC20 token contract that will be sold.
    function setTokenContract(IERC20 _tokenContract) public onlyOwner {
        tokenContract = _tokenContract;
        emit TokenContractUpdated(address(_tokenContract));
    }

    // Allows the owner to set the rate of tokens sold per ETH.
    // This function is critical for adjusting the sale to market conditions or token value.
    function setRate(uint256 _rate) public onlyOwner {
        rate = _rate;
        emit RateUpdated(_rate);
    }

    // Public function to buy tokens in exchange for ETH sent to the contract.
    // The function calculates the token amount based on the sent ETH and the set rate.
    // It then checks for sufficient token supply and transfers the tokens to the buyer.
    function buyTokens() public payable {
        require(address(tokenContract) != address(0), "Token contract not set");
        require(rate > 0, "Rate not set");

        uint256 tokenAmount = msg.value * rate;
        require(tokenContract.balanceOf(address(this)) >= tokenAmount, "Not enough tokens in the reserve");

        tokensSold += tokenAmount;
        emit Sold(msg.sender, tokenAmount);

        require(tokenContract.transfer(msg.sender, tokenAmount), "Failed to transfer tokens");
    }

    // Allows the owner to end the sale, returning any unsold tokens to the owner
    // and transferring the collected ETH from the sale to the owner.
    function endSale() public onlyOwner {
        require(tokenContract.transfer(owner, tokenContract.balanceOf(address(this))), "Failed to return unsold tokens");
        payable(owner).transfer(address(this).balance);
    }

    // Fallback function to allow ETH to be sent directly to the contract address
    // for buying tokens. It automatically calls the buyTokens function.
    receive() external payable {
        buyTokens();
    }
}
