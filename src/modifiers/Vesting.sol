// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import { Errors } from "../lib/Errors.sol";
import { VestingSchedule } from "../lib/Types.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract Modifiers {
    /**
     * @dev This modifier checks if the vesting schedule is initialized and not revoked.
     *      It reverts if the vesting schedule is either not initialized or revoked.
     */
    modifier onlyIfVestingScheduleNotRevoked(VestingSchedule memory schedule) {
        if (schedule.initialized == false) revert Errors.VestingScheduleNotInitialized();
        if (schedule.revoked == true) revert Errors.VestingScheduleRevoked();
        _;
    }

    /**
     * @dev This modifier checks if the caller is the owner and if the vesting schedule is revocable and not already
     * revoked.
     *      It reverts if the caller is not the owner, the vesting schedule is not revocable, or the vesting schedule is
     * already revoked.
     *
     * @param schedule The vesting schedule
     * @param owner The owner's address
     */
    modifier validateRevoke(VestingSchedule memory schedule, address owner) {
        if (msg.sender != owner) revert Errors.OnlyOwner(msg.sender, owner);
        if (schedule.revocable != true) revert Errors.VestingScheduleNotRevocable();
        if (schedule.revoked == true) revert Errors.VestingScheduleRevoked();
        _;
    }

    /**
     * @dev This modifier checks if the provided address is not the zero address.
     *      It reverts if the provided address is the zero address.
     *
     * @param _address The address to check
     */
    modifier nonZeroAddress(address _address) {
        if (_address != address(0)) revert Errors.AddressCannotBeZero();
        _;
    }

    /**
     * @dev This modifier checks if the caller is the beneficiary.
     *      It reverts if the caller is not the beneficiary.
     *
     * @param beneficiary The beneficiary's address
     */
    modifier onlyBeneficiary(address beneficiary) {
        if (msg.sender != beneficiary) revert Errors.OnlyBeneficiary(msg.sender, beneficiary);
        _;
    }

    /**
     * @dev This modifier checks if the vesting schedule is initialized and not revoked, and if the requested amount is
     * less than or equal to the releasable amount.
     *      It reverts if the vesting schedule is not initialized or revoked, or if the requested amount is greater than
     * the releasable amount.
     *
     * @param requested The requested amount
     * @param releasable The releasable amount
     * @param schedule The vesting schedule
     */
    modifier validateRelease(uint256 requested, uint256 releasable, VestingSchedule memory schedule) {
        if (schedule.revoked == true) revert Errors.VestingScheduleRevoked();
        if (schedule.initialized == false) revert Errors.VestingScheduleNotInitialized();
        if (requested > releasable) {
            revert Errors.NotEnoughVestedTokens({ requested: requested, available: releasable });
        }
        _;
    }

    /**
     * @dev This modifier checks if the beneficiary and token addresses are not the zero address,
     *      if the duration and slice period of the vesting schedule are not zero,
     *      if the duration is not less than the cliff,
     *      if the total amount of the vesting schedule is not greater than the token balance of this contract.
     *      It reverts if any of these conditions are not met.
     *
     * @param beneficiary The beneficiary's address
     * @param token The token's address
     * @param schedule The vesting schedule
     */
    modifier validateInitialize(address beneficiary, address token, VestingSchedule memory schedule) {
        if (beneficiary == address(0)) revert Errors.AddressCannotBeZero();
        if (token == address(0)) revert Errors.AddressCannotBeZero();
        if (schedule.duration == 0) revert Errors.DurationCannotBeZero();
        if (schedule.slicePeriodSeconds == 0) revert Errors.SlicePeriodCannotBeZero();
        if (schedule.duration < schedule.cliff) revert Errors.DurationCannotBeLessThanCliff();
        if (schedule.amountTotal > IERC20(token).balanceOf(address(this))) {
            revert Errors.InsufficientReserve({
                requested: schedule.amountTotal,
                available: IERC20(token).balanceOf(address(this))
            });
        }
        _;
    }
}
