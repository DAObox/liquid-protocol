// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.17;

// OpenZeppelin dependencies
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { IVotes } from "@openzeppelin/contracts/governance/utils/IVotes.sol";
import { ReentrancyGuardUpgradeable } from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

import { Errors } from "../lib/Errors.sol";
import { VestingSchedule } from "../lib/Types.sol";
import { Modifiers } from "../modifiers/Vesting.sol";

/**
 * @title Vesting
 * @author DAOBox | (@pythonpete32)
 * @dev This contract enables vesting of tokens over a certain period of time. It is upgradeable and protected against
 * reentrancy attacks.
 *      The contract allows an admin to initialize the vesting schedule and the beneficiary of the vested tokens. Once
 * the vesting starts, the beneficiary
 *      can claim the releasable tokens at any time. If the vesting is revocable, the admin can revoke the remaining
 * tokens and send them to a specified address.
 *      The beneficiary can also delegate their voting power to another address.
 *
 * @notice The contract uses the ERC20 and IVotes interfaces, please understand these before using this contract.
 */
contract Vesting is ReentrancyGuardUpgradeable, Modifiers {
    /// @notice The token being vested
    ERC20 private _token;

    /// @notice The vesting schedule
    VestingSchedule private _schedule;

    /// @notice The beneficiary of the vested tokens
    address private _beneficiary;

    /// @notice The admin address
    address private _admin;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @dev Initializes the vesting contract with the provided parameters.
     *      The admin, beneficiary, token, and vesting schedule are all set during initialization.
     *      Additionally, voting power for the vested tokens is delegated to the beneficiary.
     *
     * @param admin_ The address of the admin
     * @param beneficiary_ The address of the beneficiary
     * @param token_ The address of the token
     * @param schedule_ The vesting schedule
     */
    function initialize(
        address admin_,
        address beneficiary_,
        address token_,
        VestingSchedule memory schedule_
    )
        external
        initializer
        validateInitialize(beneficiary_, token_, schedule_)
    {
        _admin = admin_;

        _token = ERC20(token_);
        _beneficiary = beneficiary_;
        _schedule = schedule_;

        IVotes(address(token_)).delegate(beneficiary_);
    }

    /**
     * @dev Revokes the vesting schedule, if it is revocable.
     *      Any tokens that are vested but not yet released are sent to the beneficiary,
     *      and the remaining tokens are transferred to the specified address.
     *
     * @param revokeTo The address to send the remaining tokens to
     */
    function revoke(address revokeTo) external validateRevoke(_schedule, _admin) {
        if (_schedule.revocable != true) revert Errors.VestingScheduleNotRevocable();
        uint256 vestedAmount = computeReleasableAmount();
        if (vestedAmount > 0) release(vestedAmount);
        uint256 unreleased = _schedule.amountTotal - _schedule.released;
        _token.transfer(revokeTo, unreleased);
        _schedule.revoked = true;
    }

    /**
     * @dev Releases a specified amount of tokens to the beneficiary.
     *      The amount of tokens to be released must be less than or equal to the releasable amount.
     *
     * @param amount The amount of tokens to release
     */
    function release(uint256 amount) public validateRelease(amount, computeReleasableAmount(), _schedule) {
        _schedule.released = _schedule.released + amount;

        _token.transfer(_beneficiary, amount);
    }

    /**
     * @dev Transfers the vesting schedule to a new beneficiary.
     *
     * @param newBeneficiary_ The address of the new beneficiary
     */
    function transferVesting(address newBeneficiary_) external onlyBeneficiary(_beneficiary) {
        _beneficiary = newBeneficiary_;
    }

    /**
     * @dev Delegates voting power for the vested tokens to a specified address.
     *
     * @param delegateTo The address to delegate voting power to
     */
    function delegateVestedTokens(address delegateTo) external onlyBeneficiary(_beneficiary) {
        IVotes(address(_token)).delegate(delegateTo);
    }

    /**
     * @dev Returns the address of the token being vested.
     *
     * @return The address of the token
     */
    function getToken() external view returns (address) {
        return address(_token);
    }

    /**
     * @dev Returns the vesting schedule.
     *
     * @return The vesting schedule
     */
    function getSchedule() public view returns (VestingSchedule memory) {
        return _schedule;
    }

    /**
     * @dev Returns the amount of tokens that can be withdrawn by the owner if they revoke vesting
     *
     * @return The withdrawable amount
     */

    function getWithdrawableAmount() public view returns (uint256) {
        return _token.balanceOf(address(this)) - computeReleasableAmount();
    }

    /**
     * @dev Returns the amount of tokens that can be withdrawn by the owner if they revoke vesting
     *
     * @return The withdrawable amount
     */

    function getBeneficiary() public view returns (address) {
        return _beneficiary;
    }

    /**
     * @dev Computes the amount of tokens that can be released to the beneficiary.
     *      The releasable amount is dependent on the vesting schedule and the current time.
     *
     * @return The releasable amount
     */
    function computeReleasableAmount() public view returns (uint256) {
        // Retrieve the current time.
        uint256 currentTime = getCurrentTime();
        // If the current time is before the cliff, no tokens are releasable.
        if ((currentTime < _schedule.cliff) || _schedule.revoked) {
            return 0;
        }
        // If the current time is after the vesting period, all tokens are releasable,
        // minus the amount already released.
        else if (currentTime >= _schedule.start + _schedule.duration) {
            return _schedule.amountTotal - _schedule.released;
        }
        // Otherwise, some tokens are releasable.
        else {
            // Compute the number of full vesting periods that have elapsed.
            uint256 timeFromStart = currentTime - _schedule.start;
            uint256 secondsPerSlice = _schedule.slicePeriodSeconds;
            uint256 vestedSlicePeriods = timeFromStart / secondsPerSlice;
            uint256 vestedSeconds = vestedSlicePeriods * secondsPerSlice;
            // Compute the amount of tokens that are vested.
            uint256 vestedAmount = (_schedule.amountTotal * vestedSeconds) / _schedule.duration;
            // Subtract the amount already released and return.
            return vestedAmount - _schedule.released;
        }
    }

    /**
     * @dev Returns the current time (in seconds).
     *
     * @return The current time
     */
    function getCurrentTime() public view virtual returns (uint256) {
        return block.timestamp;
    }
}
