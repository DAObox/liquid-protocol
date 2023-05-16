# MarketMaker
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/core/MarketMaker.sol)

**Inherits:**
PluginCloneable, [Modifiers](/src/modifiers/MarketMaker.sol/abstract.Modifiers.md)

**Author:**
DAOBox | (@pythonpete32)

This contract uses several external contracts and libraries from OpenZeppelin. Please review and understand those before using this contract.
Also, consider the effects of the adjustable bonding curve and continuous minting/burning on your token's economics. Use this contract responsibly.

*This contract is an non-upgradeable Aragon OSx Plugin
It enables continuous minting and burning of tokens on an Augmented Bonding Curve, with part of the funds going to the DAO and the rest being added to a reserve.
The adjustable bonding curve formula is provided at initialization and determines the reward for minting and the refund for burning.
The DAO can also receive a sponsored mint, where another address pays to boost the reserve and the owner obtains the minted tokens.
Users can also perform a sponsored burn, where they burn their own tokens to enhance the value of the remaining tokens.
The DAO can set certain governance parameters like the theta (funding rate), or friction(exit fee)*


## State Variables
### HATCH_PERMISSION_ID
*The identifier of the permission that allows an address to conduct the hatch.*


```solidity
bytes32 public constant HATCH_PERMISSION_ID = keccak256("HATCH_PERMISSION");
```


### CONFIGURE_PERMISSION_ID
*The identifier of the permission that allows an address to configure the contract.*


```solidity
bytes32 public constant CONFIGURE_PERMISSION_ID = keccak256("CONFIGURE_PERMISSION");
```


### DENOMINATOR_PPM
*100% represented in PPM (parts per million)*


```solidity
uint32 public constant DENOMINATOR_PPM = 1_000_000;
```


### _bondedToken
The bonded token


```solidity
IBondedToken private _bondedToken;
```


### _externalToken
The external token used to purchase the bonded token


```solidity
IERC20 private _externalToken;
```


### _curve
The parameters for the _curve


```solidity
CurveParameters private _curve;
```


### _hatched
is the contract post hatching


```solidity
bool private _hatched;
```


## Functions
### initialize

*Sets the values for {owner}, {fundingRate}, {exitFee}, {reserveRatio}, {formula}, and {reserve}.
Governance cannot arbitrarily mint tokens after deployment. deployer must send some ETH
in the constructor to initialize the reserve.
Emits a {Transfer} event for the minted tokens.*


```solidity
function initialize(IDAO dao_, IBondedToken bondedToken_, IERC20 externalToken_, CurveParameters memory curve_)
    external
    initializer
    nonZeroAddress(address(externalToken_))
    nonZeroAddress(address(bondedToken_))
    nonZeroAddress(address(curve_.formula))
    isPPM(curve_.theta)
    isPPM(curve_.friction)
    isPPM(curve_.reserveRatio);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`dao_`|`IDAO`|The associated DAO.|
|`bondedToken_`|`IBondedToken`|The bonded token.|
|`externalToken_`|`IERC20`|The external token used to purchace the bonded token.|
|`curve_`|`CurveParameters`|The parameters for the curve_. This includes: {fundingRate} - The percentage of funds that go to the owner. Maximum value is 10000 (i.e., 100%). {exitFee} - The percentage of funds that are taken as fee when tokens are burned. Maximum value is 5000 (i.e., 50%). {reserveRatio} - The ratio for the reserve in the BancorBondingCurve. {formula} - The implementation of the bonding curve_.|


### hatch


```solidity
function hatch(address hatchTo, uint256 hatchAmount)
    external
    validateReserve(_externalToken)
    preHatch(_hatched)
    auth(HATCH_PERMISSION_ID);
```

### mint

*Mints tokens continuously, adding a portion of the minted amount to the reserve.
Reverts if the sender is the contract owner or if no ether is sent.
Emits a {ContinuousMint} event.*


```solidity
function mint(uint256 _amount) public payable isDepositZero(_amount) postHatch(_hatched);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_amount`|`uint256`|The amount of external tokens used to mint.|


### burn

*Burns tokens continuously, deducting a portion of the burned amount from the reserve.
Reverts if the sender is the contract owner, if no tokens are burned, if the sender's balance is insufficient,
or if the reserve is insufficient to cover the refund amount.
Emits a {ContinuousBurn} event.*


```solidity
function burn(uint256 _amount) public isDepositZero(_amount) postHatch(_hatched);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_amount`|`uint256`|The amount of tokens to burn.|


### sponsoredMint

Mints tokens to the owner's address and adds the sent ether to the reserve.

*This function is referred to as "sponsored" mint because the sender of the transaction sponsors
the increase of the reserve but the minted tokens are sent to the owner of the contract. This can be
useful in scenarios where a third-party entity (e.g., a user, an investor, or another contract) wants
to increase the reserve and, indirectly, the value of the token, without receiving any tokens in return.
The function reverts if no ether is sent along with the transaction.
Emits a {SponsoredMint} event.*


```solidity
function sponsoredMint(uint256 _amount) external payable isDepositZero(_amount) postHatch(_hatched) returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|mintedTokens The amount of tokens minted to the owner's address.|


### sponsoredBurn

Burns a specific amount of tokens from the caller's balance.

*This function is referred to as "sponsored" burn because the caller of the function burns
their own tokens, effectively reducing the total supply and, indirectly, increasing the value of
remaining tokens. The function reverts if the caller tries to burn more tokens than their balance
or tries to burn zero tokens. Emits a {SponsoredBurn} event.*


```solidity
function sponsoredBurn(uint256 _amount) external isDepositZero(_amount) postHatch(_hatched);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_amount`|`uint256`|The amount of tokens to burn.|


### setGovernance

Set governance parameters.

*Allows the owner to modify the funding rate, exit fee, or owner address of the contract.
The value parameter is a bytes type and should be decoded to the appropriate type based on
the parameter being modified.*


```solidity
function setGovernance(bytes32 what, bytes memory value) external auth(CONFIGURE_PERMISSION_ID);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`what`|`bytes32`|The name of the governance parameter to modify|
|`value`|`bytes`|The new value for the specified governance parameter. Must be ABI-encoded before passing it to the function.|


### calculateMint

Calculates and returns the amount of tokens that can be minted with {_amount}.

*The price calculation is based on the current bonding _curve and reserve ratio.*


```solidity
function calculateMint(uint256 _amount) public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint The amount of tokens that can be minted with {_amount}.|


### calculateBurn

Calculates and returns the amount of Ether that can be refunded by burning {_amount} Continuous Governance Token.

*The price calculation is based on the current bonding _curve and reserve ratio.*


```solidity
function calculateBurn(uint256 _amount) public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint The amount of Ether that can be refunded by burning {_amount} token.|


### getCurveParameters

Returns the current implementation of the bonding _curve used by the contract.

*This is an internal property and cannot be modified directly. Use the appropriate function to modify it.*


```solidity
function getCurveParameters() public view returns (CurveParameters memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`CurveParameters`|The current implementation of the bonding _curve.|


### reserveBalance

Returns the current reserve balance of the contract.

*This function is necessary to calculate the buy and sell price of the tokens. The reserve
balance represents the amount of ether held by the contract, and is used in the Bancor algorithm
to determine the price _curve of the token.*


```solidity
function reserveBalance() public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The current reserve balance of the contract.|


### totalSupply


```solidity
function totalSupply() public view returns (uint256);
```

### externalToken


```solidity
function externalToken() public view returns (IERC20);
```

### bondedToken


```solidity
function bondedToken() public view returns (IBondedToken);
```

### isHatched


```solidity
function isHatched() public view returns (bool);
```

