# SetupVesting
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/test/SetupVesting.t.sol)

**Inherits:**
Test


## State Variables
### utils

```solidity
Utils internal utils;
```


### users

```solidity
address payable[] internal users;
```


### vestingBase

```solidity
address internal vestingBase;
```


### vesting

```solidity
Vesting internal vesting;
```


### token

```solidity
MockBondedToken internal token;
```


### schedule

```solidity
VestingSchedule internal schedule;
```


### dao

```solidity
address internal dao;
```


### beneficiary

```solidity
address internal beneficiary;
```


## Functions
### setUp


```solidity
function setUp() public virtual;
```

### setupVesting


```solidity
function setupVesting() public;
```

