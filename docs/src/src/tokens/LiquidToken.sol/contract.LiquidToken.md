# LiquidToken
[Git Source](https://github.com/DAObox/fantastic-spork/blob/37171c98e431882ac7150395fb59a9c8f7e87ee4/src/tokens/LiquidToken.sol)

**Inherits:**
[LiquidBase](/src/tokens/LiquidBase.sol/abstract.LiquidBase.md)

**Author:**
DAOBox | (@pythonpete32)

Please use this contract responsibly and understand the implications of the bonding curve
and continuous minting/burning on your token's economics.

*This contract is an implementation of LiquidBase and provides functionalities for managing
a token with a bonding curve. The contract allows the owner to modify the funding rate,
exit fee, or owner address of the contract.
IMPORTANT: This contract uses a number of external contracts and libraries from OpenZeppelin,
so make sure to review and understand those as well.*


## Functions
### initialize

Initializes the contract with the given parameters.

*This function uses the `payable` and `initializer` modifiers. `payable` allows the function to receive ETH when called. `initializer` ensures the function can only be called once during the contract initialization.*


```solidity
function initialize(address _owner, string memory _name, string memory _symbol, CurveParameters memory _curve)
    external
    payable
    initializer;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_owner`|`address`|The address of the contract owner.|
|`_name`|`string`|The name of the token.|
|`_symbol`|`string`|The symbol of the token.|
|`_curve`|`CurveParameters`|The bonding curve parameters for the token.|


### setGovernance

Set governance parameters.

*Allows the owner to modify the funding rate, exit fee, or owner address of the contract.
The value parameter is a bytes type and should be decoded to the appropriate type based on
the parameter being modified.*


```solidity
function setGovernance(bytes32 what, bytes memory value) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`what`|`bytes32`|The name of the governance parameter to modify. Must be one of "fundingRate", "exitFee", or "owner".|
|`value`|`bytes`|The new value for the specified governance parameter. Must be ABI-encoded before passing it to the function.|


### openTrading


```solidity
function openTrading(address[] memory addresses, uint256[] memory amounts) external payable;
```

