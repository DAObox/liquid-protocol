# LiquidTokenPlugin
[Git Source](https://github.com/DAObox/fantastic-spork/blob/417d39e05e02311e6212644ed1689713e91fc673/src/tokens/LiquidTokenPlugin.sol)

**Inherits:**
[LiquidBase](/src/tokens/LiquidBase.sol/abstract.LiquidBase.md), PluginCloneable

**Author:**
DAOBox | (@pythonpete32)

Please use this contract responsibly and understand the implications of the bonding curve and continuous minting/burning on your token's economics.

*This contract is an extension of LiquidBase, inheriting all its properties and functionalities.
It is a plugin to be used with Aragon DAOs, and provides an additional layer of governance.
The contract adds the ability to modify the curve parameters through proposals, which requires a certain permission.
IMPORTANT: This contract uses a number of external contracts and libraries from Aragon and OpenZeppelin, so make sure to review and understand those as well.*


## State Variables
### MODIFY_CURVE_PERMISSION_ID
The ID of the permission required to call the `executeProposal` function.


```solidity
bytes32 public constant MODIFY_CURVE_PERMISSION_ID = keccak256("MODIFY_CURVE_PERMISSION");
```


## Functions
### initialize

Initializes the contract with given parameters.

*This should only be called once, at the time of contract deployment.*


```solidity
function initialize(
    IDAO _dao,
    address _owner,
    string memory _name,
    string memory _symbol,
    uint256 _initialSupply,
    CurveParameters memory _curve
) external initializer;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_dao`|`IDAO`|The DAO associated with this contract.|
|`_owner`|`address`|The address of the owner of this contract.|
|`_name`|`string`|The name of the token.|
|`_symbol`|`string`|The symbol of the token.|
|`_initialSupply`|`uint256`|The initial supply of the token.|
|`_curve`|`CurveParameters`|The curve parameters for the token. This includes: {fundingRate} - The percentage of funds that go to the owner. Maximum value is 10000 (i.e., 100%). {exitFee} - The percentage of funds that are taken as fee when tokens are burned. Maximum value is 5000 (i.e., 50%). {reserveRatio} - The ratio for the reserve in the BancorBondingCurve. {curve} - The implementation of the bonding curve.|


### setGovernanceParameter

Set governance parameters.

*Allows the owner to modify the funding rate, exit fee, or owner address of the contract.
The value parameter is a bytes type and should be decoded to the appropriate type based on
the parameter being modified.*


```solidity
function setGovernanceParameter(bytes32 what, bytes memory value) external auth(MODIFY_CURVE_PERMISSION_ID);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`what`|`bytes32`|The name of the governance parameter to modify. Must be one of "fundingRate", "exitFee", or "owner".|
|`value`|`bytes`|The new value for the specified governance parameter. Must be ABI-encoded before passing it to the function.|


