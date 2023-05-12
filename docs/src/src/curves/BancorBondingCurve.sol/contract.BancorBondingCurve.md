# BancorBondingCurve
[Git Source](https://github.com/DAObox/fantastic-spork/blob/417d39e05e02311e6212644ed1689713e91fc673/src/curves/BancorBondingCurve.sol)

**Inherits:**
[IBondingCurve](/src/interfaces/IBondingCurve.sol/interface.IBondingCurve.md), [BancorFormula](/src/math/BancorFormula.sol/contract.BancorFormula.md)

**Author:**
DAOBox | (@pythonpete32)

Please use this contract responsibly and understand the implications of the bonding curve
and continuous minting/burning on your token's economics.

*This contract implements the Bancor Formula for a bonding curve. The Bancor Formula provides
a way to calculate the price and the return of tokens for continuous token models.
The contract provides two main functionalities:
1. Calculating the reward for minting continuous tokens.
2. Calculating the refund for burning continuous tokens.*


## Functions
### getContinuousMintReward

Calculates the amount of continuous tokens that can be minted for a given reserve token amount.

*Implements the bonding curve formula to calculate the mint reward.*


```solidity
function getContinuousMintReward(
    uint256 _reserveTokenAmount,
    uint256 _continuousSupply,
    uint256 _reserveBalance,
    uint32 _reserveRatio
) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_reserveTokenAmount`|`uint256`|The amount of reserve tokens to be provided for minting.|
|`_continuousSupply`|`uint256`|The current supply of continuous tokens.|
|`_reserveBalance`|`uint256`|The current balance of reserve tokens in the contract.|
|`_reserveRatio`|`uint32`|The reserve ratio, represented in ppm (parts per million), ranging from 1 to 1,000,000.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The amount of continuous tokens that can be minted.|


### getContinuousBurnRefund

Calculates the amount of reserve tokens that can be refunded for a given amount of continuous tokens.

*Implements the bonding curve formula to calculate the burn refund.*


```solidity
function getContinuousBurnRefund(
    uint256 _continuousTokenAmount,
    uint256 _continuousSupply,
    uint256 _reserveBalance,
    uint32 _reserveRatio
) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_continuousTokenAmount`|`uint256`|The amount of continuous tokens to be burned.|
|`_continuousSupply`|`uint256`|The current supply of continuous tokens.|
|`_reserveBalance`|`uint256`|The current balance of reserve tokens in the contract.|
|`_reserveRatio`|`uint32`|The reserve ratio, represented in ppm (parts per million), ranging from 1 to 1,000,000.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The amount of reserve tokens that can be refunded.|


