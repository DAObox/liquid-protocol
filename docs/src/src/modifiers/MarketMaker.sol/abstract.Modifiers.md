# Modifiers
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/modifiers/MarketMaker.sol)


## Functions
### nonZeroAddress


```solidity
modifier nonZeroAddress(address _address);
```

### isPPM


```solidity
modifier isPPM(uint32 _amount);
```

### validateReserve


```solidity
modifier validateReserve(IERC20 token);
```

### isTradingOpen


```solidity
modifier isTradingOpen(bool _isTradingOpen);
```

### isDepositZero


```solidity
modifier isDepositZero(uint256 _amount);
```

### postHatch


```solidity
modifier postHatch(bool _hatched);
```

### preHatch


```solidity
modifier preHatch(bool _hatched);
```

