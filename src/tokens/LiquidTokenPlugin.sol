// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.17;

import {PluginCloneable, IDAO} from "@aragon/core/plugin/PluginCloneable.sol";

import {CurveParameters} from "../lib/Types.sol";
import {LiquidBase} from "./LiquidBase.sol";

/**
 * @title LiquidTokenPlugin
 * @author DAOBox | (@pythonpete32)
 * @dev This contract is an extension of LiquidBase, inheriting all its properties and functionalities.
 *      It is a plugin to be used with Aragon DAOs, and provides an additional layer of governance.
 *      The contract adds the ability to modify the curve parameters through proposals, which requires a certain permission.
 *
 *      IMPORTANT: This contract uses a number of external contracts and libraries from Aragon and OpenZeppelin, so make sure to review and understand those as well.
 *
 * @notice Please use this contract responsibly and understand the implications of the bonding curve and continuous minting/burning on your token's economics.
 */
contract LiquidTokenPlugin is LiquidBase, PluginCloneable {
    /// @notice The ID of the permission required to call the `executeProposal` function.
    bytes32 public constant MODIFY_CURVE_PERMISSION_ID = keccak256("MODIFY_CURVE_PERMISSION");
    bytes32 public constant SEED_PERMISSION_ID = keccak256("SEED_PERMISSION");

    /**
     * @notice Initializes the contract with given parameters.
     * @dev This should only be called once, at the time of contract deployment.
     *
     * @param _dao The DAO associated with this contract.
     * @param _owner The address of the owner of this contract.
     * @param _name The name of the token.
     * @param _symbol The symbol of the token.
     * @param _curve The curve parameters for the token. This includes:
     *        {fundingRate} - The percentage of funds that go to the owner. Maximum value is 10000 (i.e., 100%).
     *        {exitFee} - The percentage of funds that are taken as fee when tokens are burned. Maximum value is 5000 (i.e., 50%).
     *        {reserveRatio} - The ratio for the reserve in the BancorBondingCurve.
     *        {curve} - The implementation of the bonding curve.
     */
    function initialize(
        IDAO _dao,
        address _owner,
        string memory _name,
        string memory _symbol,
        CurveParameters memory _curve
    ) external initializer {
        __PluginCloneable_init(_dao);
        __LiquidToken_init(_owner, _name, _symbol, _curve);

        owner = _owner;
    }

    /**
     * @notice Set governance parameters.
     * @dev Allows the owner to modify the funding rate, exit fee, or owner address of the contract.
     * The value parameter is a bytes type and should be decoded to the appropriate type based on
     * the parameter being modified.
     * @param what The name of the governance parameter to modify. Must be one of
     * "fundingRate", "exitFee", or "owner".
     * @param value The new value for the specified governance parameter.
     * Must be ABI-encoded before passing it to the function.
     */
    function setGovernanceParameter(bytes32 what, bytes memory value) external auth(MODIFY_CURVE_PERMISSION_ID) {
        _setGovernance(what, value);
    }

    function openTrading(address[] memory addresses, uint256[] memory amounts)
        external
        payable
        auth(SEED_PERMISSION_ID)
    {
        _openTrading(addresses, amounts);
    }
}
