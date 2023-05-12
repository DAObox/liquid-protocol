# BancorFormula
[Git Source](https://github.com/DAObox/fantastic-spork/blob/37171c98e431882ac7150395fb59a9c8f7e87ee4/src/math/BancorFormula.sol)

**Inherits:**
[Power](/src/math/Power.sol/contract.Power.md)


## State Variables
### MAX_RESERVE_RATIO

```solidity
uint32 private constant MAX_RESERVE_RATIO = 1000000;
```


## Functions
### calculatePurchaseReturn

*given a continuous token supply, reserve token balance, reserve ratio, and a deposit amount (in the reserve token),
calculates the return for a given conversion (in the continuous token)
Formula:
Return = _supply * ((1 + _depositAmount / _reserveBalance) ^ (_reserveRatio / MAX_RESERVE_RATIO) - 1)*


```solidity
function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _depositAmount)
    public
    view
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_supply`|`uint256`|             continuous token total supply|
|`_reserveBalance`|`uint256`|   total reserve token balance|
|`_reserveRatio`|`uint32`|    reserve ratio, represented in ppm, 1-1000000|
|`_depositAmount`|`uint256`|      deposit amount, in reserve token|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|purchase return amount|


### calculateSaleReturn

*given a continuous token supply, reserve token balance, reserve ratio and a sell amount (in the continuous token),
calculates the return for a given conversion (in the reserve token)
Formula:
Return = _reserveBalance * (1 - (1 - _sellAmount / _supply) ^ (1 / (_reserveRatio / MAX_RESERVE_RATIO)))*


```solidity
function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _sellAmount)
    public
    view
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_supply`|`uint256`|             continuous token total supply|
|`_reserveBalance`|`uint256`|   total reserve token balance|
|`_reserveRatio`|`uint32`|    constant reserve ratio, represented in ppm, 1-1000000|
|`_sellAmount`|`uint256`|         sell amount, in the continuous token itself|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|sale return amount|


