// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IBondingCurve} from "../interfaces/IBondingCurve.sol";
import {LiquidBase} from "./LiquidBase.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";

import {CurveParameters} from "../lib/Types.sol";
import {Errors} from "../lib/Errors.sol";

/**
 * @title LiquidToken
 * @author DAOBox | (@pythonpete32)
 * @dev This contract is an implementation of LiquidBase and provides functionalities for managing
 *      a token with a bonding curve. The contract allows the owner to modify the funding rate,
 *      exit fee, or owner address of the contract.
 *
 *      IMPORTANT: This contract uses a number of external contracts and libraries from OpenZeppelin,
 *      so make sure to review and understand those as well.
 *
 * @notice Please use this contract responsibly and understand the implications of the bonding curve
 *         and continuous minting/burning on your token's economics.
 */
contract LiquidToken is LiquidBase {
    using SafeMath for uint256;

    /**
     * @notice Initializes the contract with the given parameters.
     * @dev This function uses the `payable` and `initializer` modifiers. `payable` allows the function to receive ETH when called. `initializer` ensures the function can only be called once during the contract initialization.
     * @param _owner The address of the contract owner.
     * @param _name The name of the token.
     * @param _symbol The symbol of the token.
     * @param _curve The bonding curve parameters for the token.
     */
    function initialize(address _owner, string memory _name, string memory _symbol, CurveParameters memory _curve)
        external
        payable
        initializer
    {
        __LiquidToken_init(_owner, _name, _symbol, _curve);
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
    function setGovernance(bytes32 what, bytes memory value) external {
        if (msg.sender != owner) revert Errors.OnlyOwner(msg.sender, owner);

        _setGovernance(what, value);
    }

    function openTrading(address[] memory addresses, uint256[] memory amounts) external payable {
        _openTrading(addresses, amounts);
    }
}
