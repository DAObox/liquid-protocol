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
    function initialize(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        PowerSource[] memory _sources,
        PowerSource memory _boostedToken
    )
        external
    {
        revert("not implemented");
    }

    // =============================================================== //
    // =========================== TALLY ============================= //
    // =============================================================== //

    function _aggregateAt(uint256 _blockNumber, bytes memory _paramdata) internal view returns (uint256) {
        revert("not implemented");
    }

    // =============================================================== //
    // ======================== POWER SOURCE ========================= //
    // =============================================================== //

    /**
     * @notice Add a new power source (`_sourceAddr`) with `_weight` weight
     * @param _sourceAddr Address of the power source
     * @param _sourceType Interface type of the power source
     * @param _weight Weight to assign to the source
     */
    function addPowerSource(
        address _sourceAddr,
        TokenType _sourceType,
        uint256 _weight
    )
        external
        auth(ADD_POWER_SOURCE_ROLE)
    {
        revert("not implemented");
    }

    /**
     * @notice Change weight of power source at `_sourceAddr` to `_weight`
     * @param _sourceAddr Power source's address
     * @param _weight New weight to assign
     */
    function changeSourceWeight(
        address _sourceAddr,
        uint256 _weight
    )
        external
        auth(MANAGE_WEIGHTS_ROLE)
        sourceExists(_sourceAddr)
    {
        revert("not implemented");
    }

    /**
     * @notice Disable power source at `_sourceAddr`
     * @param _sourceAddr Power source's address
     */
    function disableSource(address _sourceAddr) external auth(MANAGE_POWER_SOURCE_ROLE) sourceExists(_sourceAddr) {
        revert("not implemented");
    }

    /**
     * @notice Enable power source at `_sourceAddr`
     * @param _sourceAddr Power source's address
     */
    function enableSource(address _sourceAddr) external sourceExists(_sourceAddr) auth(MANAGE_POWER_SOURCE_ROLE) {
        revert("not implemented");
    }

    function getPowerSourceDetails(address _sourceAddr) public view sourceExists(_sourceAddr) {
        revert("not implemented");
    }

    /**
     * @dev Return number of added power sources
     * @return Number of added power sources
     * TODO: make only init
     */
    function getPowerSourcesLength() public view returns (uint256) {
        revert("not implemented");
    }

    function _powerSourceExists(address _sourceAddr) internal view returns (bool) {
        revert("not implemented");
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

    modifier sourceExists(address _sourceAddr) {
        if (_powerSourceExists(_sourceAddr)) revert Errors.NotAPowerSource(_sourceAddr);
        _;
    }
}
