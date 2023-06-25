# Employee Stock Option Plan Solution

A smart contract to manage an Employee Stock Option Plan (ESOP) on the Ethereum blockchain.

## Deployment

The contract has been deployed to goerli testnet for testing purposes. You can access the deployed contract at the following address:

Testnet Contract Address: [Contract Address](https://goerli.etherscan.io/address/0x3126def28532453846ce0d205e7f1eca9fef3fc0)


## Contract Details

The Employee Stock Option Plan contract allows for the following functionality:

- Granting stock options to employees
- Setting the vesting schedule for employee options
- Allowing employees to exercise their vested options
- Transferring vested options between employees
- Updating vested options after the vesting period

## Contract Functions

The contract exposes the following functions:

- `grantStockOptions`: Grants stock options to an employee.
- `setVestingSchedule`: Sets the vesting schedule for an employee's options.
- `exerciseOptions`: Allows an employee to exercise their vested options.
- `getVestedOptions`: Retrieves the number of vested options for an employee.
- `getExercisedOptions`: Retrieves the number of exercised options for an employee.
- `transferOptions`: Allows an employee to transfer their vested options to another eligible employee.
- `updateVestedOptions`: Updates the vested options for an employee after the vesting period has ended.
- `getVestingSchedule`: Retrieves the start and end dates of the vesting period for an employee.

For detailed information on each function, including parameters and usage, please refer to the contract's source code.

## Access Control

The contract implements access control through modifiers. The `onlyOwner` modifier restricts certain functions to be called only by the contract owner. The `onlyEmployee` modifier ensures that specific actions can only be performed by authorized employees.


