# Vesting
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/core/Vesting.sol)

**Inherits:**
ReentrancyGuardUpgradeable, [Modifiers](/src/modifiers/MarketMaker.sol/abstract.Modifiers.md)

**Author:**
DAOBox | (@pythonpete32)

The contract uses the ERC20 and IVotes interfaces, please understand these before using this contract.

*This contract enables vesting of tokens over a certain period of time. It is upgradeable and protected against reentrancy attacks.
The contract allows an admin to initialize the vesting schedule and the beneficiary of the vested tokens. Once the vesting starts, the beneficiary
can claim the releasable tokens at any time. If the vesting is revocable, the admin can revoke the remaining tokens and send them to a specified address.
The beneficiary can also delegate their voting power to another address.*


## State Variables
### _token
The token being vested


```solidity
ERC20 private _token;
```


### _schedule
The vesting schedule


```solidity
VestingSchedule private _schedule;
```


### _beneficiary
The beneficiary of the vested tokens


```solidity
address private _beneficiary;
```


### _admin
The admin address


```solidity
address private _admin;
```


## Functions
### constructor


```solidity
constructor();
```

### initialize

*Initializes the vesting contract with the provided parameters.
The admin, beneficiary, token, and vesting schedule are all set during initialization.
Additionally, voting power for the vested tokens is delegated to the beneficiary.*


```solidity
function initialize(address admin_, address beneficiary_, address token_, VestingSchedule memory schedule_)
    external
    initializer
    validateInitialize(beneficiary_, token_, schedule_);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`admin_`|`address`|The address of the admin|
|`beneficiary_`|`address`|The address of the beneficiary|
|`token_`|`address`|The address of the token|
|`schedule_`|`VestingSchedule`|The vesting schedule|


### revoke

*Revokes the vesting schedule, if it is revocable.
Any tokens that are vested but not yet released are sent to the beneficiary,
and the remaining tokens are transferred to the specified address.*


```solidity
function revoke(address revokeTo) external validateRevoke(_schedule, _admin);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`revokeTo`|`address`|The address to send the remaining tokens to|


### release

*Releases a specified amount of tokens to the beneficiary.
The amount of tokens to be released must be less than or equal to the releasable amount.*


```solidity
function release(uint256 amount) public validateRelease(amount, computeReleasableAmount(), _schedule);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`amount`|`uint256`|The amount of tokens to release|


### transferVesting

*Transfers the vesting schedule to a new beneficiary.*


```solidity
function transferVesting(address newBeneficiary_) external onlyBeneficiary(_beneficiary);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newBeneficiary_`|`address`|The address of the new beneficiary|


### delegateVestedTokens

*Delegates voting power for the vested tokens to a specified address.*


```solidity
function delegateVestedTokens(address delegateTo) external onlyBeneficiary(_beneficiary);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`delegateTo`|`address`|The address to delegate voting power to|


### getToken

*Returns the address of the token being vested.*


```solidity
function getToken() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The address of the token|


### getSchedule

*Returns the vesting schedule.*


```solidity
function getSchedule() public view returns (VestingSchedule memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`VestingSchedule`|The vesting schedule|


### getWithdrawableAmount

*Returns the amount of tokens that can be withdrawn by the owner if they revoke vesting*


```solidity
function getWithdrawableAmount() public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The withdrawable amount|


### computeReleasableAmount

*Computes the amount of tokens that can be released to the beneficiary.
The releasable amount is dependent on the vesting schedule and the current time.*


```solidity
function computeReleasableAmount() public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The releasable amount|


### getCurrentTime

*Returns the current time.*


```solidity
function getCurrentTime() internal view virtual returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The current time|


