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
* **Actions**: Adds `msg.value` to `currentPledged`. If `currentP
