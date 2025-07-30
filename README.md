# SimplePledge: A Basic Solidity Pledge System

This repository contains a simple smart contract, `SimplePledge`, written in Solidity. It demonstrates a basic crowdfunding or pledge system where a creator sets a target amount, and others can contribute Ether until the target is met. Once the target is reached, the creator can withdraw the accumulated funds.

---
## Features

* **Pledge Creation**: The deployer of the contract sets a specific Ether target.
* **Ether Contributions**: Anyone can contribute Ether to the pledge.
* **Target Tracking**: The contract keeps track of the total Ether pledged and whether the target has been reached.
* **Creator Withdrawal**: Once the target amount is met, only the creator can withdraw the collected Ether.
* **Event Logging**: Important actions like pledge creation, contributions, and withdrawals are logged as events, making it easy for off-chain applications to monitor the contract's state.
* **Fallback Functionality**: Allows users to send Ether directly to the contract address, which will automatically be treated as a contribution.

---
## Contract Details

### State Variables

* `creator` (address): The address of the individual who deployed the contract. This address is immutable, meaning it cannot be changed after deployment.
* `targetAmount` (uint256): The total amount of Ether (in Wei) that needs to be pledged for the target to be considered reached.
* `currentPledged` (uint256): The current total amount of Ether (in Wei) that has been contributed to the pledge.
* `targetReached` (bool): A boolean flag that is `true` if `currentPledged` is greater than or equal to `targetAmount`.

### Events

* `PledgeSet(address indexed _creator, uint256 _targetAmount)`: Emitted when the contract is deployed, indicating the creator and the target amount.
* `Contribution(address indexed _contributor, uint256 _amount, uint256 _newTotal)`: Emitted whenever a new contribution is made, showing the contributor's address, the amount contributed, and the new total pledged.
* `FundsWithdrawn(address indexed _receiver, uint256 _amount)`: Emitted when the creator successfully withdraws the funds.

### Functions

#### `constructor(uint256 _target)`

* **Purpose**: Initializes the contract upon deployment.
* **Parameters**:
    * `_target` (uint256): The desired target amount in Wei.
* **Actions**: Sets the `creator` to `msg.sender` (the deployer), `targetAmount` to `_target`, and initializes `currentPledged` to 0 and `targetReached` to `false`. Emits a `PledgeSet` event.

#### `contribute() public payable`

* **Purpose**: Allows any user to send Ether to contribute to the pledge.
* **Requirements**:
    * The `targetReached` must be `false`.
    * The `msg.value` (amount of Ether sent with the transaction) must be greater than 0.
* **Actions**: Adds `msg.value` to `currentPledged`. If `currentPledged` meets or exceeds `targetAmount`, sets `targetReached` to `true`. Emits a `Contribution` event.
* **Note**: The `payable` keyword is essential, allowing this function to receive Ether.

#### `withdrawFunds() public`

* **Purpose**: Allows the contract creator to withdraw the pledged funds.
* **Requirements**:
    * Only the `creator` can call this function.
    * The `targetReached` must be `true`.
    * `currentPledged` must be greater than 0.
* **Actions**: Transfers the `currentPledged` amount to the `creator`'s address. Resets `currentPledged` to 0 and `targetReached` to `false`. Emits a `FundsWithdrawn` event.
* **Security**: Uses `payable(creator).call{value: amountToWithdraw}("")` for secure Ether transfer, which is the recommended approach to prevent reentrancy attacks.

#### `receive() external payable`

* **Purpose**: This is a special fallback function that is executed whenever Ether is sent directly to the contract address without specifying a function to call.
* **Actions**: Calls the `contribute()` function, effectively allowing direct Ether transfers to count as contributions.

---
## How to Use

### Deployment

To deploy `SimplePledge`, you'll need a Solidity development environment (e.g., Remix, Hardhat, Truffle). You'll provide the `_target` amount (in Wei) as a constructor argument.

Example deployment using Remix:
1.  Navigate to Remix IDE.
2.  Paste the contract code.
3.  Compile the contract (`SimplePledge.sol`).
4.  In the "Deploy & Run Transactions" tab, select `SimplePledge` contract.
5.  In the deploy input field, enter the target amount in Wei (e.g., `1000000000000000000` for 1 Ether).
6.  Click "Deploy".

### Interacting with the Contract

Once deployed, you can interact with the contract's functions:

* **`contribute()`**: Send Ether to this function. In Remix, you can specify the "Value" in Ether or Wei and then call `contribute()`.
* **`withdrawFunds()`**: Only accessible by the contract `creator` after the `targetAmount` has been reached.
* **`creator`**, **`targetAmount`**, **`currentPledged`**, **`targetReached`**: These are public state variables that can be read without a transaction.

---
## Development and Testing

This contract is a basic example and is suitable for learning and demonstration purposes. For production use cases, consider adding more robust features and security audits, such as:

* **Refund mechanism**: What happens if the target is not reached?
* **Contribution limits**: Minimum or maximum contribution amounts per user.
* **Time limits**: Set a deadline for contributions.
* **Error handling**: More specific error messages.
* **Access control**: More granular permissions for different roles.

---
## License

This project is licensed under the MIT License. See the `SPDX-License-Identifier: MIT` in the contract code.

---
If you have any questions about this contract or suggestions for improvement, feel free to contribute!
