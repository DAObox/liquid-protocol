// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC20BurnableUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import {ERC20VotesUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import {ERC20PermitUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

import {IBondingCurve} from "../interfaces/IBondingCurve.sol";
import {Errors} from "../lib/Errors.sol";
import {Events} from "../lib/Events.sol";
import {CurveParameters} from "../lib/Types.sol";

/**
 * @title LiquidBase
 * @author DAOBox | (@pythonpete32)
 * @dev This contract is an upgradeable, burnable ERC20 token with voting rights that is tied to a bonding curve.
 *      It allows for continuous minting and burning of tokens, with a portion of the funds going to the contract owner (usually a DAO) and the rest being added to a reserve.
 *      The bonding curve formula can be provided at initialization and determines the reward for minting and the refund for burning.
 *      The contract owner can also receive a sponsored mint, where another address pays to increase the reserve and the owner receives the minted tokens.
 *      Users can also perform a sponsored burn, where they burn their own tokens to increase the value of the remaining tokens.
 *      The contract owner can set certain governance parameters like the funding rate, exit fee, or owner address.
 *
 *      IMPORTANT: This contract uses a number of external contracts and libraries from OpenZeppelin, so make sure to review and understand those as well.
 *
 * @notice Please use this contract responsibly and understand the implications of the bonding curve and continuous minting/burning on your token's economics.
 */
abstract contract LiquidBase is
    ERC20Upgradeable,
    ERC20BurnableUpgradeable,
    ERC20VotesUpgradeable,
    PausableUpgradeable
{
    using SafeMath for uint256;

    // =============================================================== //
    // =========================== STROAGE =========================== //
    // =============================================================== //

    /// @dev 100% represented as 10000
    uint16 internal constant ONE_HUNDRED_PERCENT = 10000;

    /// @notice The parameters for the curve
    CurveParameters internal curve;

    /// @notice The reserve balance in the bonding curve
    uint256 internal reserve;

    /// @notice The owner address, usually a DAO
    address internal owner;

    // =============================================================== //
    // ========================= INITIALIZE ========================== //
    // =============================================================== //

    /**
     * @dev Sets the values for {owner}, {fundingRate}, {exitFee}, {reserveRatio}, {formula}, and {reserve}.
     * Governance cannot arbitrarily mint tokens after deployment. deployer must send some ETH
     * in the constructor to initialize the reserve.
     * Emits a {Transfer} event for the minted tokens.
     *
     * @param _owner The address that will own the contract. This address will also receive the funding.
     * @param _name The name of the token.
     * @param _symbol The symbol of the token.
     * @param _curve The parameters for the curve. This includes:
     *        {fundingRate} - The percentage of funds that go to the owner. Maximum value is 10000 (i.e., 100%).
     *        {exitFee} - The percentage of funds that are taken as fee when tokens are burned. Maximum value is 5000 (i.e., 50%).
     *        {reserveRatio} - The ratio for the reserve in the BancorBondingCurve.
     *        {formula} - The implementation of the bonding curve.
     */
    function __LiquidToken_init(
        address _owner,
        string memory _name,
        string memory _symbol,
        CurveParameters memory _curve
    ) internal {
        if (_curve.fundingRate > 10000) revert Errors.FundingRateError(_curve.fundingRate);
        if (_curve.exitFee > 5000) revert Errors.ExitFeeError(_curve.exitFee);

        __ERC20_init(_name, _symbol);
        __ERC20Burnable_init();
        __ERC20Permit_init(_name);
        __Pausable_init();
        __ERC20Votes_init();

        owner = _owner;
        reserve = address(this).balance;

        curve.fundingRate = _curve.fundingRate;
        curve.exitFee = _curve.exitFee;
        curve.reserveRatio = _curve.reserveRatio;
        curve.formula = _curve.formula;
        _pause();
    }

    /**
     * @dev opens trading and unpauses the token
     * @param addresses Array of addresses that will receive initial tokens.
     * @param amounts Array of token amounts corresponding to the addresses.
     * Both arrays must be of equal length.
     *
     * This function can only be called by the owner of the contract during deployment, and the contract must hold a non-zero balance of ETH.
     * It starts the contract's operation by unpausing it and distributes the initial tokens to the provided addresses.
     *
     * @notice Make sure that the contract holds a non-zero balance of ETH before calling this function.
     *
     * Reverts if:
     * - The caller is not the contract owner.
     * - The contract does not hold any ETH.
     * - The lengths of the addresses and amounts arrays do not match.
     *
     * Emits a {Transfer} event for each mint operation.
     */
    function openTrading(address[] memory addresses, uint256[] memory amounts) public payable {
        if (msg.sender != owner) revert Errors.OnlyOwner({caller: msg.sender, owner: owner});
        if (address(this).balance == 0) revert Errors.InitialReserveCannotBeZero();
        if (addresses.length != amounts.length) {
            revert Errors.AddressesAmountMismatch({addresses: addresses.length, values: amounts.length});
        }

        _unpause();
        for (uint256 i = 0; i < addresses.length; i++) {
            _mint(addresses[i], amounts[i]);
        }
    }

    // =============================================================== //
    // ======================== BONDING CURVE ======================== //
    // =============================================================== //

    /**
     * @dev Mints tokens continuously, adding a portion of the minted amount to the reserve.
     * Reverts if the sender is the contract owner or if no ether is sent.
     * Emits a {ContinuousMint} event.
     *
     */
    function mint() public payable {
        // Only addresses other than the owner can call this function
        if (msg.sender == owner) revert Errors.OwnerCanNotContinuousMint();

        // The sent ether must be greater than zero
        if (msg.value == 0) revert Errors.DepositAmountCannotBeZero();

        // Calculate the funding portion and the reserve portion
        uint256 fundingAmount = (msg.value * curve.fundingRate) / ONE_HUNDRED_PERCENT; // Calculate the funding amount
        uint256 reserveAmount = msg.value - fundingAmount; // Calculate the reserve amount

        // Add the reserve amount to the reserve
        reserve += reserveAmount;

        // Calculate the reward amount and mint the tokens
        uint256 rewardAmount = calculateMint(msg.value); // Calculate the reward amount
        _mint(msg.sender, rewardAmount); // Mint the tokens to the sender

        // Transfer the funding amount to the owner
        (bool success,) = payable(owner).call{value: fundingAmount}(""); // Attempt to transfer the funding amount to the owner
        if (!success) revert Errors.TransferFailed(owner, fundingAmount); // If the transfer fails, revert the transaction

        // Emit the ContinuousMint event
        emit Events.ContinuousMint(msg.sender, rewardAmount, msg.value, reserveAmount, fundingAmount);
    }

    /**
     * @dev Burns tokens continuously, deducting a portion of the burned amount from the reserve.
     * Reverts if the sender is the contract owner, if no tokens are burned, if the sender's balance is insufficient,
     * or if the reserve is insufficient to cover the refund amount.
     * Emits a {ContinuousBurn} event.
     *
     * @param _amount The amount of tokens to burn.
     */
    function burn(uint256 _amount) public override(ERC20BurnableUpgradeable) {
        // Only addresses other than the owner can call this function
        if (msg.sender == owner) revert Errors.OwnerCanNotContinuousBurn();

        // The amount of tokens to burn must be greater than zero
        if (_amount == 0) revert Errors.BurnAmountCannotBeZero();

        // The sender must have a sufficient balance to burn the specified amount of tokens
        if (balanceOf(msg.sender) < _amount) {
            revert Errors.InsufficentBalance({sender: msg.sender, balance: balanceOf(msg.sender), amount: _amount});
        }

        // Calculate the refund amount
        uint256 refundAmount = calculateBurn(_amount);

        // The reserve must be sufficient to cover the refund amount
        if (refundAmount > reserve) {
            revert Errors.InsufficientReserve({requested: refundAmount, available: reserve});
        }

        // Burn the specified amount of tokens from the sender's balance
        _burn(msg.sender, _amount);

        // Calculate the exit fee
        uint256 exitFeeAmount = (refundAmount * curve.exitFee) / ONE_HUNDRED_PERCENT;
        // Calculate the refund amount minus the exit fee
        uint256 refundAmountLessFee = refundAmount - exitFeeAmount;

        // Subtract the refund amount (minus the exit fee) from the reserve
        reserve -= refundAmountLessFee;

        // Attempt to transfer the refund amount (minus the exit fee) to the sender
        (bool success,) = payable(msg.sender).call{value: refundAmountLessFee}("");
        if (!success) {
            revert Errors.TransferFailed(msg.sender, refundAmountLessFee);
        } // If the transfer fails, revert the transaction

        // Emit the ContinuousBurn event
        emit Events.ContinuousBurn(msg.sender, _amount, refundAmountLessFee, exitFeeAmount);
    }

    /**
     * @notice Mints tokens to the owner's address and adds the sent ether to the reserve.
     * @dev This function is referred to as "sponsored" mint because the sender of the transaction sponsors
     * the increase of the reserve but the minted tokens are sent to the owner of the contract. This can be
     * useful in scenarios where a third-party entity (e.g., a user, an investor, or another contract) wants
     * to increase the reserve and, indirectly, the value of the token, without receiving any tokens in return.
     * The function reverts if no ether is sent along with the transaction.
     * Emits a {SponsoredMint} event.
     * @return mintedTokens The amount of tokens minted to the owner's address.
     */
    function sponsoredMint() external payable returns (uint256) {
        // The value of ether sent with the transaction must be greater than zero
        if (msg.value == 0) revert Errors.DepositAmountCannotBeZero();

        // The deposited ether is added to the reserve
        reserve += msg.value;

        // Calculate the number of tokens to be minted based on the deposited amount
        uint256 mintedTokens = calculateMint(msg.value);

        // Mint the calculated amount of tokens to the owner's address
        _mint(owner, mintedTokens);

        // Emit the SponsoredMint event, which logs the details of the minting transaction
        emit Events.SponsoredMint(msg.sender, msg.value, mintedTokens);

        // Return the amount of tokens minted
        return mintedTokens;
    }

    /**
     * @notice Burns a specific amount of tokens from the caller's balance.
     * @dev This function is referred to as "sponsored" burn because the caller of the function burns
     * their own tokens, effectively reducing the total supply and, indirectly, increasing the value of
     * remaining tokens. The function reverts if the caller tries to burn more tokens than their balance
     * or tries to burn zero tokens. Emits a {SponsoredBurn} event.
     * @param burnAmount The amount of tokens to burn.
     */
    function sponsoredBurn(uint256 burnAmount) external {
        // Ensure the burn amount is greater than zero
        if (burnAmount == 0) revert Errors.BurnAmountCannotBeZero();

        // Ensure the caller has enough tokens to burn
        if (balanceOf(msg.sender) < burnAmount) {
            revert Errors.InsufficentBalance({sender: msg.sender, balance: balanceOf(msg.sender), amount: burnAmount});
        }

        // Burn the specified amount of tokens from the caller's balance
        _burn(msg.sender, burnAmount);

        // Emit the SponsoredBurn event, which logs the details of the burn transaction
        emit Events.SponsoredBurn(msg.sender, burnAmount);
    }

    // =============================================================== //
    // ===================== GOVERNANCE FUNCTIONS ==================== //
    // =============================================================== //

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
    function _setGovernance(bytes32 what, bytes memory value) internal {
        if (what == "fundingRate") curve.fundingRate = (abi.decode(value, (uint16)));
        else if (what == "exitFee") curve.exitFee = (abi.decode(value, (uint16)));
        else if (what == "owner") owner = (abi.decode(value, (address)));
        else if (what == "curve") curve.formula = (abi.decode(value, (IBondingCurve)));
        else if (what == "reserveRatio") curve.reserveRatio = (abi.decode(value, (uint32)));
        else revert Errors.InvalidGovernanceParameter(what);
    }

    // =============================================================== //
    // ======================== VIEW FUNCTIONS ======================= //
    // =============================================================== //

    /**
     * @notice Calculates and returns the amount of tokens that can be minted with {_amount}.
     * @dev The price calculation is based on the current bonding curve and reserve ratio.
     * @return uint The amount of tokens that can be minted with {_amount}.
     */
    function calculateMint(uint256 _amount) public view returns (uint256) {
        return curve.formula.getContinuousMintReward(_amount, totalSupply(), reserve, curve.reserveRatio);
    }

    /**
     * @notice Calculates and returns the amount of Ether that can be refunded by burning {_amount} Continuous Governance Token.
     * @dev The price calculation is based on the current bonding curve and reserve ratio.
     * @return uint The amount of Ether that can be refunded by burning {_amount} token.
     */
    function calculateBurn(uint256 _amount) public view returns (uint256) {
        return curve.formula.getContinuousBurnRefund(_amount, totalSupply(), reserve, curve.reserveRatio);
    }

    /**
     * @notice Returns the current implementation of the bonding curve used by the contract.
     * @dev This is an internal property and cannot be modified directly. Use the appropriate function to modify it.
     * @return The current implementation of the bonding curve.
     */
    function getCurveParameters() public view returns (CurveParameters memory) {
        return curve;
    }

    /**
     * @notice Returns the current reserve balance of the contract.
     * @dev This function is necessary to calculate the buy and sell price of the tokens. The reserve
     * balance represents the amount of ether held by the contract, and is used in the Bancor algorithm
     *  to determine the price curve of the token.
     * @return The current reserve balance of the contract.
     */
    function reserveBalance() public view returns (uint256) {
        return reserve;
    }

    /**
     * @notice Returns the owner of the contract.
     * @dev This function is view only, meaning it doesn't change the state of the contract.
     * @return The address of the owner.
     */
    function getOwner() public view returns (address) {
        return owner;
    }

    // =============================================================== //
    // ====================== OVERRIDE FUNCTIONS ===================== //
    // =============================================================== //

    /// @notice See {ERC20Upgradeable-_mint}.
    function _mint(address to, uint256 amount) internal override(ERC20Upgradeable, ERC20VotesUpgradeable) {
        super._mint(to, amount);
    }

    ///@notice See {ERC20Upgradeable-_burn}.

    function _burn(address account, uint256 amount) internal override(ERC20Upgradeable, ERC20VotesUpgradeable) {
        super._burn(account, amount);
    }

    /// @notice See {ERC20Upgradeable-_beforeTokenTransfer}.
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        super._beforeTokenTransfer(from, to, amount);
    }

    /// @notice See {ERC20Upgradeable-_afterTokenTransfer}.
    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20Upgradeable, ERC20VotesUpgradeable)
    {
        super._afterTokenTransfer(from, to, amount);

        // Automatically turn on delegation on mint/transfer but only for the first time.
        if (to != address(0) && numCheckpoints(to) == 0 && delegates(to) == address(0)) {
            _delegate(to, to);
        }
    }

    // =============================================================== //
    // ====================== FALLBACK FUNCTIONS ===================== //
    // =============================================================== //

    /**
     * @notice The fallback function for the contract.
     * @dev When ether is sent directly to the contract without any data, the fallback function
     * will call the mint function. This allows users to mint tokens by simply sending ether to
     * the contract.
     */
    fallback() external payable {
        mint();
    }

    /**
     * @notice The receive function for the contract.
     * @dev This function is called when ether is sent directly to the contract without any
     *  data. It is a required function for contracts that define a fallback function, and it
     *  should be left empty since the fallback function handles the minting process.
     */
    receive() external payable {}
}
