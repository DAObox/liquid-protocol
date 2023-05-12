# BaseSetup
[Git Source](https://github.com/DAObox/fantastic-spork/blob/37171c98e431882ac7150395fb59a9c8f7e87ee4/src/test/BaseSetup.t.sol)

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


### token

```solidity
LiquidToken internal token;
```


### formula

```solidity
BancorBondingCurve internal formula;
```


### ONE_TOKEN

```solidity
uint256 public constant ONE_TOKEN = 1e18;
```


### ONE_PERCENT

```solidity
uint16 public constant ONE_PERCENT = 100;
```


### alice

```solidity
address internal alice;
```


### bob

```solidity
address internal bob;
```


### owner

```solidity
address internal owner;
```


## Functions
### setUp


```solidity
function setUp() public virtual;
```

### openTrading


```solidity
function openTrading() public;
```

