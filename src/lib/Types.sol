// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {IBondingCurve} from "../interfaces/IBondingCurve.sol";

/// @notice This struct holds the key parameters that define a bonding curve for a token.
/// @dev These parameters can be updated over time to change the behavior of the bonding curve.
struct CurveParameters {
    /// @notice The percentage of buy funds that go to the DAO.
    /// @dev This value is represented in basis points, where 10000 equals 100%, 100 equals 1%, and 1 equals 0.01%.
    /// The funds collected here could be used for various purposes like development, marketing, etc., depending on the DAO's decisions.
    uint16 fundingRate;
    /// @notice The percentage of sell funds that are redistributed to the Pool.
    /// @dev This value is represented in basis points, where 10000 equals 100%, 100 equals 1%, and 1 equals 0.01%.
    /// This "exit fee" is used to discourage frequent trading and maintain stability in the token's price.
    uint16 exitFee;
    /// @notice The implementation of the curve.
    /// @dev This is the interface of the bonding curve contract.
    /// Different implementations can be used to change the behavior of the curve, such as linear, exponential, etc.
    IBondingCurve formula;
    /// @notice The reserve ratio of the bonding curve, represented in parts per million (ppm), ranging from 1 to 1,000,000.
    /// @dev The reserve ratio corresponds to different formulas in the bonding curve:
    ///      - 1/3 corresponds to y = multiple * x^2 (exponential curve)
    ///      - 1/2 corresponds to y = multiple * x (linear curve)
    ///      - 2/3 corresponds to y = multiple * x^(1/2) (square root curve)
    /// The reserve ratio determines the price sensitivity of the token to changes in supply.
    uint32 reserveRatio;
}

/// @notice The container for the DAO settings to be set during the DAO initialization.
/// @param trustedForwarder The address of the trusted forwarder required for meta transactions.
/// @param daoURI The DAO uri used with [EIP-4824](https://eips.ethereum.org/EIPS/eip-4824).
/// @param subdomain The ENS subdomain to be registered for the DAO contract.
/// @param metadata The metadata of the DAO.
struct DAOSettings {
    address trustedForwarder;
    string daoURI;
    string subdomain;
    bytes metadata;
}
