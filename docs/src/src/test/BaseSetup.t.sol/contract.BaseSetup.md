# BaseSetup
[Git Source](https://github.com/DAObox/fantastic-spork/blob/417d39e05e02311e6212644ed1689713e91fc673/src/test/BaseSetup.t.sol)

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

