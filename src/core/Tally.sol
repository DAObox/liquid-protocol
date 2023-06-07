// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { IVotes } from "@openzeppelin/contracts/governance/utils/IVotes.sol";
import { PluginCloneable, IDAO } from "@aragon/core/plugin/PluginCloneable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import { PowerSource, TokenType } from "../lib/Types.sol";
import { Errors } from "../lib/Errors.sol";
import { Events } from "../lib/Events.sol";

contract VotingAggregator is IVotes, PluginCloneable {
    // =============================================================== //
    // ========================== CONSTANTS ========================== //
    // =============================================================== //

    bytes32 public constant ADD_POWER_SOURCE_ROLE = keccak256("ADD_POWER_SOURCE_ROLE");
    bytes32 public constant MANAGE_POWER_SOURCE_ROLE = keccak256("MANAGE_POWER_SOURCE_ROLE");
    bytes32 public constant MANAGE_WEIGHTS_ROLE = keccak256("MANAGE_WEIGHTS_ROLE");

    uint256 internal constant MAX_SOURCES = 20;
    uint256 internal constant MAX_WEIGHT = 1 ether;

    // =============================================================== //
    // =========================== STROAGE =========================== //
    // =============================================================== //

    /// @notice The total number of powersources
    uint256 public powersourceCount;

    /// @notice The mapping to store powersources
    mapping(uint256 => PowerSource) public powersources;

    PowerSource public BoostedToken;
    bool public boostRequired;

    // Mapping from user address to deposited ERC20 tokens and their amounts
    mapping(address => mapping(IERC20 => uint256)) private _erc20Balances;

    // Mapping from user address to deposited ERC721 tokens and their token IDs
    mapping(address => mapping(IERC721 => uint256[])) private _erc721Balances;

    // =============================================================== //
    // ========================= INITIALIZE ========================== //
    // =============================================================== //

    /**
     * @notice Initialize the contract by adding power sources and setting a boosted token.
     * @dev Each power source's weight should not exceed MAX_WEIGHT, and the total weight of all sources should not
     * exceed MAX_WEIGHT.
     * If a boosted token is provided, its weight will be used as a multiplier to the sum of the weights of other
     * sources with a minimum of 1, so it doesn't have a weight limit.
     * @param _sources An array of power sources to be added.
     * @param _boostedToken An optional boosted token power source to be added.
     * @param _boostRequired A flag indicating if the boosted token is required.
     */
    function initialize(
        PowerSource[] memory _sources,
        PowerSource memory _boostedToken,
        bool _boostRequired
    )
        external
    {
        // Revert if there are more sources than the maximum allowed
        if (_sources.length > MAX_SOURCES) revert Errors.TooManyPowerSources();

        // Initialize total weight to zero
        uint256 totalWeight = 0;

        // Loop over each power source
        for (uint256 i = 0; i < _sources.length; i++) {
            // Revert if the source address is zero
            if (_sources[i].sourceAddress == address(0)) revert Errors.NotAPowerSource(_sources[i].sourceAddress);

            // Revert if the source already exists
            if (_powerSourceExists(_sources[i].sourceAddress)) {
                revert Errors.PowerSourceAlreadyAdded(_sources[i].sourceAddress);
            }

            // Revert if the weight of the source is more than the maximum allowed weight
            if (_sources[i].weight > MAX_WEIGHT) revert Errors.InvalidWeight(_sources[i].weight, MAX_WEIGHT);

            // Add the source to the powersources mapping
            powersources[i] = _sources[i];

            // Add the weight of the source to the total weight
            totalWeight += _sources[i].weight;
        }

        // Revert if the total weight of the sources is more than the maximum allowed weight
        if (totalWeight > MAX_WEIGHT) revert Errors.TotalWeightExceedsMax();

        // If a boosted token is provided, add it
        if (_boostedToken.sourceAddress != address(0)) {
            // Add the boosted token to the power sources
            BoostedToken = _boostedToken;
        }

        // Revert if a boost is required but no boosted token is provided
        if (_boostRequired && _boostedToken.sourceAddress == address(0)) {
            revert Errors.InvalidBoost();
        }

        // Set the total number of power sources
        powersourceCount = _sources.length;

        // Set the flag indicating if a boost is required
        boostRequired = _boostRequired;
    }

    // =============================================================== //
    // =========================== TALLY ============================= //
    // =============================================================== //

    function _aggregateAt(uint256 _blockNumber) internal view returns (uint256) {
        revert("not implemented");
    }

    // =============================================================== //
    // ======================== POWER SOURCE ========================= //
    // =============================================================== //

    /**
     * @dev Add a new power source with adjusted weights for all power sources.
     * The weights array should include weights for all the current sources,
     * plus the weight for the new source as the last element.
     * The source address cannot be a zero address and should not be already added.
     * The sum of weights should add up to 100%.
     *
     * @param _sourceAddr The address of the new power source
     * @param _sourceType The type of the power source
     * @param _weights The array of weights for all the power sources
     */
    function addPowerSource(
        address _sourceAddr,
        TokenType _sourceType,
        uint256[] calldata _weights
    )
        external
        auth(ADD_POWER_SOURCE_ROLE)
    {
        if (_sourceAddr == address(0)) revert Errors.InvalidPowerSource(_sourceAddr);
        if (_powerSourceExists(_sourceAddr)) revert Errors.PowerSourceAlreadyAdded(_sourceAddr);
        if (_weights.length == powersourceCount + 1) revert Errors.InvalidWeightsLength();

        uint256 totalWeight;
        // Update the weights of existing sources
        for (uint256 i = 0; i < powersourceCount; i++) {
            require(_weights[i] <= MAX_WEIGHT, "Invalid weight");

            totalWeight += _weights[i];
            powersources[i].weight = _weights[i];
        }

        // Add the new source
        PowerSource memory newSource =
            PowerSource({ sourceAddress: _sourceAddr, sourceType: _sourceType, weight: _weights[powersourceCount] });

        totalWeight += newSource.weight;

        require(totalWeight == MAX_WEIGHT, "Total weight must add up to 100%");

        powersources[powersourceCount] = newSource;
        powersourceCount += 1;
    }

    /**
     * @notice Change weights of all power sources.
     * The length of the weights array should match the current number of power sources.
     * The sum of weights should add up to 100%.
     *
     * @dev Updates the weights of all power sources.
     * The `_weights` array should include weights for all the current sources in order.
     * The sum of weights should add up to 100% (MAX_WEIGHT).
     *
     * @param _weights The array of new weights for all the power sources
     */
    function changeSourceWeights(uint256[] calldata _weights) external auth(MANAGE_WEIGHTS_ROLE) {
        require(_weights.length == powersourceCount, "Invalid weights length");

        uint256 totalWeight;
        for (uint256 i = 0; i < powersourceCount; i++) {
            require(_weights[i] <= MAX_WEIGHT, "Invalid weight");

            totalWeight += _weights[i];
            powersources[i].weight = _weights[i];
        }

        require(totalWeight == MAX_WEIGHT, "Total weights must add up to 100%");
    }

    /**
     * @notice Removes a power source from the list of power sources and adjusts the weights of the remaining sources.
     * @dev This function removes a power source by swapping it with the last power source in the list and then reducing
     * the powersource count.
     * The caller must provide the new weights for the remaining power sources.
     *
     * @param index The index of the power source to remove.
     * @param _weights The new weights for the remaining power sources.
     */
    function removePowerSource(uint256 index, uint256[] calldata _weights) external auth(REMOVE_POWER_SOURCE_ROLE) {
        require(index < powersourceCount, "Invalid index");
        require(_weights.length == powersourceCount - 1, "Invalid weights length");

        uint256 totalWeight;
        for (uint256 i = 0; i < _weights.length; i++) {
            require(_weights[i] <= MAX_WEIGHT, "Invalid weight");

            totalWeight += _weights[i];
        }

        require(totalWeight == MAX_WEIGHT, "Total weight must add up to 100%");

        // Swap the power source to delete with the last one
        powersources[index] = powersources[powersourceCount - 1];

        // Decrease the powersource count
        powersourceCount -= 1;

        // Update the weights of the remaining sources
        for (uint256 i = 0; i < powersourceCount; i++) {
            powersources[i].weight = _weights[i];
        }
    }

    /**
     * @dev Checks if a power source with the given address exists in the powersources mapping.
     *
     * @param _sourceAddr The address of the power source to check.
     * @return bool Returns true if a power source with the given address exists, false otherwise.
     */
    function _powerSourceExists(address _sourceAddr) internal view returns (bool) {
        for (uint256 i = 0; i < powersourceCount; i++) {
            if (powersources[i].sourceAddress == _sourceAddr) {
                return true;
            }
        }
        return false;
    }

    // =============================================================== //
    // =========================== IVOTES ============================ //
    // =============================================================== //

    /**
     * @dev Returns the current amount of votes that `account` has.
     */
    function getVotes(address account) external view returns (uint256) {
        revert("not implemented");
    }

    function getPastVotes(address account, uint256 timepoint) external view returns (uint256) {
        revert("not implemented");
    }

    function getPastTotalSupply(uint256 timepoint) external view returns (uint256) {
        revert("not implemented");
    }

    function delegate(address delegatee) external {
        revert("not implemented");
    }

    function delegates(address account) external view returns (address) {
        revert("not implemented");
    }

    function delegateBySig(address delegatee, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s) external {
        revert("not implemented");
    }

    // =============================================================== //
    // =========================== TO MOVE =========================== //
    // =============================================================== //

    function _powerSourceExists(address _sourceAddr) internal view returns (bool) {
        for (uint256 i = 0; i < powersourceCount; i++) {
            if (powersources[i].sourceAddress == _sourceAddr) {
                return true;
            }
        }
        return false;
    }
}
