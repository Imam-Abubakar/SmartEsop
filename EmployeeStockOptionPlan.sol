// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/**
 * @title Employee Stock Option Plan
 * @dev A smart contract to manage an Employee Stock Option Plan (ESOP) on the Ethereum blockchain.
 */
contract EmployeeStockOptionPlan {
    address private owner; // Contract owner

    struct Employee {
        uint256 totalOptions; // Total granted options
        uint256 vestedOptions; // Vested options
        uint256 exercisedOptions; // Exercised options
        uint256 vestingStartTime; // Vesting start time
        uint256 vestingEndTime; // Vesting end time
    }

    mapping(address => Employee) private employees; // Mapping of employee addresses to Employee struct

    event StockOptionsGranted(address indexed employee, uint256 options);
    event VestingScheduleSet(
        address indexed employee,
        uint256 vestingStartTime,
        uint256 vestingEndTime
    );
    event OptionsExercised(address indexed employee, uint256 options);

    /**
     * @dev Constructor function that sets the contract owner as the deployer of the contract.
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Modifier that allows only the contract owner to perform certain actions.
     */
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can perform this action."
        );
        _;
    }

    /**
     * @dev Modifier that allows only authorized employees to perform certain actions.
     */
    modifier onlyEmployee() {
        require(
            employees[msg.sender].totalOptions > 0,
            "Only authorized employees can perform this action."
        );
        _;
    }

    /**
     * @dev Grants stock options to an employee.
     * @param employee The address of the employee.
     * @param options The number of options to be granted.
     * Requirements:
     * - The number of options must be greater than zero.
     */
    function grantStockOptions(address employee, uint256 options)
        public
        onlyOwner
    {
        require(options > 0, "Number of options must be greater than zero.");

        employees[employee].totalOptions += options;

        emit StockOptionsGranted(employee, options);
    }

    /**
     * @dev Sets the vesting schedule for an employee's options.
     * @param employee The address of the employee.
     * @param vestingStartTime The start time of the vesting period.
     * @param vestingEndTime The end time of the vesting period.
     * Requirements:
     * - The vesting start time must be before the vesting end time.
     * - The employee must have been granted options.
     */
    function setVestingSchedule(
        address employee,
        uint256 vestingStartTime,
        uint256 vestingEndTime
    ) public onlyOwner {
        require(vestingStartTime < vestingEndTime, "Invalid vesting schedule.");
        require(
            employees[employee].totalOptions > 0,
            "Employee has no granted options."
        );
        employees[employee].vestingStartTime = vestingStartTime;
        employees[employee].vestingEndTime = vestingEndTime;
        emit VestingScheduleSet(employee, vestingStartTime, vestingEndTime);
    }

    /**
     * @dev Allows an employee to exercise their vested options.
     * @param options The number of options to exercise.
     * Requirements:
     * - The number of options to exercise must be greater than zero.
     * - The employee must have enough vested options.
     * - The total number of exercised options must not exceed the total granted options.
     */
    function exerciseOptions(uint256 options) public onlyEmployee {
        require(
            options > 0,
            "Number of options to exercise must be greater than zero."
        );
        require(
            employees[msg.sender].vestedOptions >= options,
            "Not enough vested options."
        );
        require(
            employees[msg.sender].exercisedOptions + options <=
                employees[msg.sender].totalOptions,
            "Exceeded total granted options."
        );

        employees[msg.sender].vestedOptions -= options;
        employees[msg.sender].exercisedOptions += options;

        emit OptionsExercised(msg.sender, options);
    }

    /**
     * @dev Retrieves the number of vested options for an employee.
     * @param employee The address of the employee.
     * @return The number of vested options.
     */
    function getVestedOptions(address employee) public view returns (uint256) {
        return employees[employee].vestedOptions;
    }

    /**
     * @dev Retrieves the number of exercised options for an employee.
     * @param employee The address of the employee.
     * @return The number of exercised options.
     */
    function getExercisedOptions(address employee)
        public
        view
        returns (uint256)
    {
        return employees[employee].exercisedOptions;
    }

    /**
     * @dev Allows an employee to transfer their vested options to another eligible employee.
     * @param to The address of the recipient employee.
     * @param options The number of options to transfer.
     * Requirements:
     * - The number of options to transfer must be greater than zero.
     * - The recipient address must not be the same as the sender's address.
     * - The recipient must be an eligible employee with granted options.
     */
    function transferOptions(address to, uint256 options) public onlyEmployee {
        require(
            options > 0,
            "Number of options to transfer must be greater than zero."
        );
        require(to != msg.sender, "Cannot transfer options to oneself.");
        require(
            employees[to].totalOptions > 0,
            "Recipient is not an eligible employee."
        );

        employees[msg.sender].vestedOptions -= options;
        employees[to].totalOptions += options;

        emit StockOptionsGranted(to, options);
    }

    /**
     * @dev Updates the vested options for an employee after the vesting period has ended.
     *      Only the contract owner can call this function.
     * @param employee The address of the employee to update vested options for.
     * @return A boolean indicating whether the vested options were successfully updated.
     * @notice This function should be called by the contract owner to update the vested options for an employee
     *         after the vesting period has ended.
     * @dev Access Control:
     *      - Only the contract owner can call this function.
     *      - The vesting period must have ended for the employee.
     */
    function updateVestedOptions(address employee)
        external
        onlyOwner
        returns (bool)
    {
        require(
            block.timestamp >= employees[employee].vestingEndTime,
            "Vesting period not yet ended."
        );

        employees[employee].vestedOptions = employees[employee].totalOptions;

        return true;
    }

    /**
     * @dev Retrieves the start and end dates of the vesting period for an employee.
     * @param employee The address of the employee.
     * @return A tuple containing the start and end dates of the vesting period.
     */
    function getVestingSchedule(address employee)
        public
        view
        returns (uint256, uint256)
    {
        return (
            employees[employee].vestingStartTime,
            employees[employee].vestingEndTime
        );
    }
}
