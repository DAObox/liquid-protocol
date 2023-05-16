// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {Errors} from "../lib/Errors.sol";
import {VestingSchedule} from "../lib/Types.sol";
import {VestingSchedule, HatchStatus, HatchParameters} from "../lib/Types.sol";

abstract contract Modifiers {
    modifier validateContribution(HatchParameters memory params, uint256 amount) {
        if (params.status != HatchStatus.OPEN) revert Errors.HatchNotOpen();
        if (params.raised + amount > params.maximumRaise) revert Errors.MaxContributionReached();
        if (block.timestamp > params.hatchDeadline) revert Errors.ContributionWindowClosed();
        _;
    }

    modifier validateRefund(HatchParameters memory params, uint256 amount) {
        if (params.status != HatchStatus.CANCELED) revert Errors.HatchNotCanceled();
        if (amount == 0) revert Errors.NoContribution();
        _;
    }
}
