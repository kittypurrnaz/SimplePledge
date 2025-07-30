// Turing Complete Program on Solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SimplePledge
 * @dev A basic smart contract to demonstrate a pledge system.
 * The creator sets a target amount, and others can send Ether to contribute.
 * Once the target is reached, the creator can withdraw the funds.
 */
contract SimplePledge {
    // State variables: These variables are stored on the blockchain
    address public immutable creator; // The address that deployed the contract
    uint256 public targetAmount;     // The total amount of Ether (in Wei) to be pledged
    uint256 public currentPledged;   // The current total amount of Ether pledged
    bool public targetReached;       // True if currentPledged >= targetAmount

    // Events: Used to log information on the blockchain that can be easily
    // queried by off-chain applications (e.g., a web UI)
    event PledgeSet(address indexed _creator, uint256 _targetAmount);
    event Contribution(address indexed _contributor, uint256 _amount, uint256 _newTotal);
    event FundsWithdrawn(address indexed _receiver, uint256 _amount);

    /**
     * @dev Constructor: Executed only once when the contract is deployed.
     * @param _target Wei The target amount in Wei (1 Ether = 10^18 Wei).
     */
    constructor(uint256 _target) {
        // 'msg.sender' is a global variable that refers to the address
        // that initiated the current transaction (in this case, the deployer).
        creator = msg.sender;
        targetAmount = _target;
        currentPledged = 0; // Initialize to zero
        targetReached = false; // Initialize to false

        // Emit an event to log the creation of the pledge
        emit PledgeSet(creator, targetAmount);
    }

    /**
     * @dev Allows anyone to contribute Ether to the pledge.
     * The 'payable' keyword is crucial; it allows the function to receive Ether.
     */
    function contribute() public payable {
        require(!targetReached, "Pledge target already reached.");
        require(msg.value > 0, "Contribution must be greater than zero.");

        // 'msg.value' is a global variable that refers to the amount of Ether
        // sent with the current transaction (in Wei).
        currentPledged += msg.value;

        // Check if the target has been reached after this contribution
        if (currentPledged >= targetAmount) {
            targetReached = true;
        }

        // Emit an event for the contribution
        emit Contribution(msg.sender, msg.value, currentPledged);
    }

    /**
     * @dev Allows the creator to withdraw the pledged funds once the target is reached.
     */
    function withdrawFunds() public {
        // Ensure only the creator can call this function
        require(msg.sender == creator, "Only the creator can withdraw funds.");
        // Ensure the target has been reached
        require(targetReached, "Pledge target not yet reached.");
        // Ensure there are funds to withdraw
        require(currentPledged > 0, "No funds to withdraw.");

        uint256 amountToWithdraw = currentPledged;
        currentPledged = 0; // Reset the pledged amount after withdrawal
        targetReached = false; // Reset the target reached status

        // Transfer the Ether to the creator's address.
        // This is the recommended way to send Ether from a contract.
        (bool success, ) = payable(creator).call{value: amountToWithdraw}("");
        require(success, "Failed to withdraw funds.");

        // Emit an event for the withdrawal
        emit FundsWithdrawn(creator, amountToWithdraw);
    }

    /**
     * @dev Fallback function: This function is executed if Ether is sent to the contract
     * without calling any specific function. Useful for simple Ether transfers.
     * It also allows contributions without explicitly calling 'contribute()'.
     * It must be 'external' and 'payable'.
     */
    receive() external payable {
        contribute(); // Directly call the contribute function
    }
}
