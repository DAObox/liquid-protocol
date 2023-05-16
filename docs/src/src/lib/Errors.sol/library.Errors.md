# Errors
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/lib/Errors.sol)


## Errors
### TradingAlreadyOpened
Error thrown when the market is already open


```solidity
error TradingAlreadyOpened();
```

### InitialReserveCannotBeZero
Error thrown when the initial reserve for the token contract is zero.


```solidity
error InitialReserveCannotBeZero();
```

### FundingRateError
Error thrown when the funding rate provided is greater than 10000 (100%).


```solidity
error FundingRateError(uint16 fundingRate);
```

### ExitFeeError
Error thrown when the exit fee provided is greater than 5000 (50%).


```solidity
error ExitFeeError(uint16 exitFee);
```

### InitialSupplyCannotBeZero
Error thrown when the initial supply for the token contract is zero.


```solidity
error InitialSupplyCannotBeZero();
```

### OwnerCanNotContinuousMint
Error thrown when the owner of the contract tries to mint tokens continuously.


```solidity
error OwnerCanNotContinuousMint();
```

### OwnerCanNotContinuousBurn
Error thrown when the owner of the contract tries to burn tokens continuously.


```solidity
error OwnerCanNotContinuousBurn();
```

### DepositAmountCannotBeZero
Error thrown when the deposit amount provided is zero.


```solidity
error DepositAmountCannotBeZero();
```

### BurnAmountCannotBeZero
Error thrown when the burn amount provided is zero.


```solidity
error BurnAmountCannotBeZero();
```

### InsufficientReserve
Error thrown when the reserve balance is less than the amount requested to burn.


```solidity
error InsufficientReserve(uint256 requested, uint256 available);
```

### InsufficentBalance
Error thrown when the balance of the sender is less than the amount requested to burn.


```solidity
error InsufficentBalance(address sender, uint256 balance, uint256 amount);
```

### OnlyOwner
Error thrown when a function that requires ownership is called by an address other than the owner.


```solidity
error OnlyOwner(address caller, address owner);
```

### TransferFailed
Error thrown when a transfer of ether fails.


```solidity
error TransferFailed(address recipient, uint256 amount);
```

### InvalidGovernanceParameter
Error thrown when an invalid governance parameter is set.


```solidity
error InvalidGovernanceParameter(bytes32 what);
```

### AddressesAmountMismatch
Error thrown when addresses and values provided are not equal.


```solidity
error AddressesAmountMismatch(uint256 addresses, uint256 values);
```

### AddressCannotBeZero

```solidity
error AddressCannotBeZero();
```

### InvalidPPMValue

```solidity
error InvalidPPMValue(uint32 value);
```

### HatchingNotStarted

```solidity
error HatchingNotStarted();
```

### HatchingAlreadyStarted

```solidity
error HatchingAlreadyStarted();
```

### HatchNotOpen

```solidity
error HatchNotOpen();
```

### VestingScheduleNotInitialized

```solidity
error VestingScheduleNotInitialized();
```

### VestingScheduleRevoked

```solidity
error VestingScheduleRevoked();
```

### VestingScheduleNotRevocable

```solidity
error VestingScheduleNotRevocable();
```

### OnlyBeneficiary

```solidity
error OnlyBeneficiary(address caller, address beneficiary);
```

### NotEnoughVestedTokens

```solidity
error NotEnoughVestedTokens(uint256 requested, uint256 available);
```

### DurationCannotBeZero

```solidity
error DurationCannotBeZero();
```

### SlicePeriodCannotBeZero

```solidity
error SlicePeriodCannotBeZero();
```

### DurationCannotBeLessThanCliff

```solidity
error DurationCannotBeLessThanCliff();
```

### ContributionWindowClosed

```solidity
error ContributionWindowClosed();
```

### MaxContributionReached

```solidity
error MaxContributionReached();
```

### HatchNotCanceled

```solidity
error HatchNotCanceled();
```

### NoContribution

```solidity
error NoContribution();
```

