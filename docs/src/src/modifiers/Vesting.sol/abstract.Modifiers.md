# Modifiers
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/modifiers/Vesting.sol)


## Functions
### onlyIfVestingScheduleNotRevoked

*This modifier checks if the vesting schedule is initialized and not revoked.
It reverts if the vesting schedule is either not initialized or revoked.*


```solidity
modifier onlyIfVestingScheduleNotRevoked(VestingSchedule memory schedule);
```

### validateRevoke

*This modifier checks if the caller is the owner and if the vesting schedule is revocable and not already revoked.
It reverts if the caller is not the owner, the vesting schedule is not revocable, or the vesting schedule is already revoked.*


```solidity
modifier validateRevoke(VestingSchedule memory schedule, address owner);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`schedule`|`VestingSchedule`|The vesting schedule|
|`owner`|`address`|The owner's address|


### nonZeroAddress

*This modifier checks if the provided address is not the zero address.
It reverts if the provided address is the zero address.*


```solidity
modifier nonZeroAddress(address _address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_address`|`address`|The address to check|


### onlyBeneficiary

*This modifier checks if the caller is the beneficiary.
It reverts if the caller is not the beneficiary.*


```solidity
modifier onlyBeneficiary(address beneficiary);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`beneficiary`|`address`|The beneficiary's address|


### validateRelease

*This modifier checks if the vesting schedule is initialized and not revoked, and if the requested amount is less than or equal to the releasable amount.
It reverts if the vesting schedule is not initialized or revoked, or if the requested amount is greater than the releasable amount.*


```solidity
modifier validateRelease(uint256 requested, uint256 releasable, VestingSchedule memory schedule);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`requested`|`uint256`|The requested amount|
|`releasable`|`uint256`|The releasable amount|
|`schedule`|`VestingSchedule`|The vesting schedule|


### validateInitialize

*This modifier checks if the beneficiary and token addresses are not the zero address,
if the duration and slice period of the vesting schedule are not zero,
if the duration is not less than the cliff,
if the total amount of the vesting schedule is not greater than the token balance of this contract.
It reverts if any of these conditions are not met.*


```solidity
modifier validateInitialize(address beneficiary, address token, VestingSchedule memory schedule);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`beneficiary`|`address`|The beneficiary's address|
|`token`|`address`|The token's address|
|`schedule`|`VestingSchedule`|The vesting schedule|


