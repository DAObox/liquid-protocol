// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

/**
 * @title IHatch
 * @author DAOBox | (@pythonpete32)
 * @dev
 */
interface IHatch {
    function contribute(uint256 _amount) external;
    function refund() external;
    function claimVesting() external;
    function hatch() external;
    function cancel() external;
}
