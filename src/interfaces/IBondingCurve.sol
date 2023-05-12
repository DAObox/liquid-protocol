// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/**
 * @title IBondingCurve
 * @author DAOBox | (@pythonpete32)
 * @dev This interface defines the necessary methods for implementing a bonding curve.
 *      Bonding curves are price functions used for automated market makers.
 *      This specific interface is used to calculate rewards for minting and refunds for burning continuous tokens.
 */
interface IBondingCurve {
    /**
     * @notice Calculates the amount of continuous tokens that can be minted for a given reserve token amount.
     * @dev Implements the bonding curve formula to calculate the mint reward.
     * @param _reserveTokenAmount The amount of reserve tokens to be provided for minting.
     * @param _continuousSupply The current supply of continuous tokens.
     * @param _reserveBalance The current balance of reserve tokens in the contract.
     * @param _reserveRatio The reserve ratio, represented in ppm (parts per million), ranging from 1 to 1,000,000.
     * @return The amount of continuous tokens that can be minted.
     */
    function getContinuousMintReward(
        uint256 _reserveTokenAmount,
        uint256 _continuousSupply,
        uint256 _reserveBalance,
        uint32 _reserveRatio
    ) external view returns (uint256);

    /**
     * @notice Calculates the amount of reserve tokens that can be refunded for a given amount of continuous tokens.
     * @dev Implements the bonding curve formula to calculate the burn refund.
     * @param _continuousTokenAmount The amount of continuous tokens to be burned.
     * @param _continuousSupply The current supply of continuous tokens.
     * @param _reserveBalance The current balance of reserve tokens in the contract.
     * @param _reserveRatio The reserve ratio, represented in ppm (parts per million), ranging from 1 to 1,000,000.
     * @return The amount of reserve tokens that can be refunded.
     */
    function getContinuousBurnRefund(
        uint256 _continuousTokenAmount,
        uint256 _continuousSupply,
        uint256 _reserveBalance,
        uint32 _reserveRatio
    ) external view returns (uint256);
}
