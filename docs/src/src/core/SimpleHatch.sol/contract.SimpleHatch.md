# SimpleHatch
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/core/SimpleHatch.sol)

**Inherits:**
PluginCloneable, [Modifiers](/src/modifiers/MarketMaker.sol/abstract.Modifiers.md)


## State Variables
### _vestingBase

```solidity
address internal _vestingBase;
```


### _params

```solidity
HatchParameters internal _params;
```


### _schedule

```solidity
VestingSchedule internal _schedule;
```


### _contributions

```solidity
mapping(address => uint256) internal _contributions;
```


## Functions
### constructor


```solidity
constructor();
```

### initialize


```solidity
function initialize(IDAO dao_, HatchParameters memory params_, VestingSchedule memory schedule_) external initializer;
```

### contribute


```solidity
function contribute(uint256 _amount) external validateContribution(_params, _amount);
```

### refund


```solidity
function refund() external validateRefund(_params, _contributions[msg.sender]);
```

### claimVesting


```solidity
function claimVesting() external;
```

### hatch


```solidity
function hatch() external;
```

### cancel


```solidity
function cancel() external;
```

## Events
### Contribute

```solidity
event Contribute(address indexed contributor, uint256 amount);
```

### Refund

```solidity
event Refund(address indexed contributor, uint256 amount);
```

