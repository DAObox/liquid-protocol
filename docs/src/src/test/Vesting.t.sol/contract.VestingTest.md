# VestingTest
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/test/Vesting.t.sol)

**Inherits:**
[SetupVesting](/src/test/SetupVesting.t.sol/contract.SetupVesting.md)


## State Variables
### maxTransferAmount

```solidity
uint256 internal maxTransferAmount = 12e18;
```


## Functions
### setUp


```solidity
function setUp() public virtual override;
```

### testInitialize

*Testing the initialization of the contract*


```solidity
function testInitialize() public;
```

### testRevoke

Test for revoke() function


```solidity
function testRevoke() public;
```

### testRevoke_RevertWhenNotRevocable

Test for revoke() function when not revocable


```solidity
function testRevoke_RevertWhenNotRevocable() public;
```

### testRelease

Test for release() function


```solidity
function testRelease() public;
```

### testReleaseWithInvalidAmount

Test for release() function with invalid amount


```solidity
function testReleaseWithInvalidAmount() public;
```

### testTransferVesting

Test for transferVesting() function


```solidity
function testTransferVesting() public;
```

### testTransferVestingByNonBeneficiary

Test for transferVesting() function by non-beneficiary


```solidity
function testTransferVestingByNonBeneficiary() public;
```

### testDelegateVestedTokens

Test for delegateVestedTokens() function


```solidity
function testDelegateVestedTokens() public;
```

### testDelegateVestedTokensByNonBeneficiary

Test for delegateVestedTokens() function by non-beneficiary


```solidity
function testDelegateVestedTokensByNonBeneficiary() public;
```

### testGetToken

Test for getToken() function


```solidity
function testGetToken() public;
```

### testGetSchedule

Test for getSchedule() function


```solidity
function testGetSchedule() public;
```

### testGetWithdrawableAmount

Test for getWithdrawableAmount() function


```solidity
function testGetWithdrawableAmount() public;
```

### testComputeReleasableAmount

Test for computeReleasableAmount() function


```solidity
function testComputeReleasableAmount() public;
```

### testComputeReleasableAmountBeforeCliff

Test for computeReleasableAmount() function before the cliff


```solidity
function testComputeReleasableAmountBeforeCliff() public;
```

### testComputeReleasableAmountAfterVestingPeriod

Test for computeReleasableAmount() function after the vesting period


```solidity
function testComputeReleasableAmountAfterVestingPeriod() public;
```

### testComputeReleasableAmountDuringVestingPeriod

Test for computeReleasableAmount() function during the vesting period


```solidity
function testComputeReleasableAmountDuringVestingPeriod() public;
```

### testGetCurrentTime

Test for getCurrentTime() function


```solidity
function testGetCurrentTime() public;
```

