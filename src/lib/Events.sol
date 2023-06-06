// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import { PowerSource } from "../lib/Types.sol";

library Events {
    /**
     * @dev Emitted when tokens are minted continuously (the normal minting process).
     * @param buyer The address of the account that initiated the minting process.
     * @param minted The amount of tokens that were minted.
     * @param depositAmount The amount of ether that was deposited to mint the tokens.
     * @param reserveAmount The amount of ether that was added to the reserve.
     * @param fundingAmount The amount of ether that was sent to the owner as funding.
     */
    event ContinuousMint(
        address indexed buyer, uint256 minted, uint256 depositAmount, uint256 reserveAmount, uint256 fundingAmount
    );

    /**
     * @dev Emitted when tokens are burned continuously (the normal burning process).
     * @param burner The address of the account that initiated the burning process.
     * @param burned The amount of tokens that were burned.
     * @param reimburseAmount The amount of ether that was reimbursed to the burner.
     * @param exitFee The amount of ether that was deducted as an exit fee.
     */
    event ContinuousBurn(address indexed burner, uint256 burned, uint256 reimburseAmount, uint256 exitFee);

    /**
     * @dev Emitted when tokens are minted in a sponsored process.
     * @param sender The address of the account that initiated the minting process.
     * @param depositAmount The amount of ether that was deposited to mint the tokens.
     * @param minted The amount of tokens that were minted.
     */
    event SponsoredMint(address indexed sender, uint256 depositAmount, uint256 minted);

    /**
     * @dev Emitted when tokens are burned in a sponsored process.
     * @param sender The address of the account that initiated the burning process.
     * @param burnAmount The amount of tokens that were burned.
     */
    event SponsoredBurn(address indexed sender, uint256 burnAmount);

    /**
     * @dev Emitted when the MarketMaker has been Hatched.
     * @param hatcher The address of the account recieved the hatch tokens.
     * @param amount The amount of bonded tokens that was minted to the hatcher.
     */
    event Hatch(address indexed hatcher, uint256 amount);

    /// @notice Emitted when a new power source is added
    /// @param sourceAddress The address of the power source that was added
    /// @param sourceType The type of the power source that was added
    /// @param weight The weight assigned to the power source
    event AddPowerSource(address indexed sourceAddress, PowerSource sourceType, uint256 weight);

    /// @notice Emitted when the weight of a power source is changed
    /// @param sourceAddress The address of the power source whose weight was changed
    /// @param newWeight The new weight assigned to the power source
    event ChangePowerSourceWeight(address indexed sourceAddress, uint256 newWeight);

    /// @notice Emitted when a power source is disabled
    /// @param sourceAddress The address of the power source that was disabled
    event DisablePowerSource(address indexed sourceAddress);

    /// @notice Emitted when a power source is enabled
    /// @param sourceAddress The address of the power source that was enabled
    event EnablePowerSource(address indexed sourceAddress);
}
