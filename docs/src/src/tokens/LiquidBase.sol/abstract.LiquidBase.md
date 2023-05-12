# LiquidBase
[Git Source](https://github.com/DAObox/fantastic-spork/blob/37171c98e431882ac7150395fb59a9c8f7e87ee4/src/tokens/LiquidBase.sol)

**Inherits:**
ERC20Upgradeable, ERC20BurnableUpgradeable, ERC20VotesUpgradeable, PausableUpgradeable

**Author:**
DAOBox | (@pythonpete32)

Please use this contract responsibly and understand the implications of the bonding curve and continuous minting/burning on your token's economics.

*This contract is an upgradeable, burnable ERC20 token with voting rights that is tied to a bonding curve.
It allows for continuous minting and burning of tokens, with a portion of the funds going to the contract owner (usually a DAO) and the rest being added to a reserve.
The bonding curve formula can be provided at initialization and determines the reward for minting and the refund for burning.
The contract owner can also receive a sponsored mint, where another address pays to increase the reserve and the owner receives the minted tokens.
Users can also perform a sponsored burn, where they burn their own tokens to increase the value of the remaining tokens.
The contract owner can set certain governance parameters like the funding rate, exit fee, or owner address.
IMPORTANT: This contract uses a number of external contracts and libraries from OpenZeppelin, so make sure to review and understand those as well.*


## State Variables
### ONE_HUNDRED_PERCENT
*100% represented as 10000*


```solidity
uint16 internal constant ONE_HUNDRED_PERCENT = 10000;
```


### curve
The parameters for the curve


```solidity
CurveParameters internal curve;
```


### reserve
The reserve balance in the bonding curve


```solidity
uint256 internal reserve;
```


### owner
The owner address, usually a DAO


```solidity
address internal owner;
```


### _tradingInitialized

```solidity
bool private _tradingInitialized;
```


## Functions
### __LiquidToken_init

*Sets the values for {owner}, {fundingRate}, {exitFee}, {reserveRatio}, {formula}, and {reserve}.
Governance cannot arbitrarily mint tokens after deployment. deployer must send some ETH
in the constructor to initialize the reserve.
Emits a {Transfer} event for the minted tokens.*


```solidity
function __LiquidToken_init(address _owner, string memory _name, string memory _symbol, CurveParameters memory _curve)
    internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_owner`|`address`|The address that will own the contract. This address will also receive the funding.|
|`_name`|`string`|The name of the token.|
|`_symbol`|`string`|The symbol of the token.|
|`_curve`|`CurveParameters`|The parameters for the curve. This includes: {fundingRate} - The percentage of funds that go to the owner. Maximum value is 10000 (i.e., 100%). {exitFee} - The percentage of funds that are taken as fee when tokens are burned. Maximum value is 5000 (i.e., 50%). {reserveRatio} - The ratio for the reserve in the BancorBondingCurve. {formula} - The implementation of the bonding curve.|


### _openTrading

Make sure that the contract holds a non-zero balance of ETH before calling this function.
Reverts if:
- The caller is not the contract owner.
- The contract does not hold any ETH.
- The lengths of the addresses and amounts arrays do not match.
Emits a {Transfer} event for each mint operation.

*opens trading and unpauses the token*


```solidity
function _openTrading(address[] memory addresses, uint256[] memory amounts) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`addresses`|`address[]`|Array of addresses that will receive initial tokens.|
|`amounts`|`uint256[]`|Array of token amounts corresponding to the addresses. Both arrays must be of equal length. This function can only be called by the owner of the contract during deployment, and the contract must hold a non-zero balance of ETH. It starts the contract's operation by unpausing it and distributes the initial tokens to the provided addresses.|


### mint

*Mints tokens continuously, adding a portion of the minted amount to the reserve.
Reverts if the sender is the contract owner or if no ether is sent.
Emits a {ContinuousMint} event.*


```solidity
function mint() public payable;
```

### burn

*Burns tokens continuously, deducting a portion of the burned amount from the reserve.
Reverts if the sender is the contract owner, if no tokens are burned, if the sender's balance is insufficient,
or if the reserve is insufficient to cover the refund amount.
Emits a {ContinuousBurn} event.*


```solidity
function burn(uint256 _amount) public override(ERC20BurnableUpgradeable);
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
function sponsoredMint() external payable returns (uint256);
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
function sponsoredBurn(uint256 burnAmount) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`burnAmount`|`uint256`|The amount of tokens to burn.|


### _setGovernance

Set governance parameters.

*Allows the owner to modify the funding rate, exit fee, or owner address of the contract.
The value parameter is a bytes type and should be decoded to the appropriate type based on
the parameter being modified.*


```solidity
function _setGovernance(bytes32 what, bytes memory value) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`what`|`bytes32`|The name of the governance parameter to modify. Must be one of "fundingRate", "exitFee", or "owner".|
|`value`|`bytes`|The new value for the specified governance parameter. Must be ABI-encoded before passing it to the function.|


### calculateMint

Calculates and returns the amount of tokens that can be minted with {_amount}.

*The price calculation is based on the current bonding curve and reserve ratio.*


```solidity
function calculateMint(uint256 _amount) public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint The amount of tokens that can be minted with {_amount}.|


### calculateBurn

Calculates and returns the amount of Ether that can be refunded by burning {_amount} Continuous Governance Token.

*The price calculation is based on the current bonding curve and reserve ratio.*


```solidity
function calculateBurn(uint256 _amount) public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint The amount of Ether that can be refunded by burning {_amount} token.|


### getCurveParameters

Returns the current implementation of the bonding curve used by the contract.

*This is an internal property and cannot be modified directly. Use the appropriate function to modify it.*


```solidity
function getCurveParameters() public view returns (CurveParameters memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`CurveParameters`|The current implementation of the bonding curve.|


### reserveBalance

Returns the current reserve balance of the contract.

*This function is necessary to calculate the buy and sell price of the tokens. The reserve
balance represents the amount of ether held by the contract, and is used in the Bancor algorithm
to determine the price curve of the token.*


```solidity
function reserveBalance() public view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The current reserve balance of the contract.|


### getOwner

Returns the owner of the contract.

*This function is view only, meaning it doesn't change the state of the contract.*


```solidity
function getOwner() public view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The address of the owner.|


### _mint

See {ERC20Upgradeable-_mint}.


```solidity
function _mint(address to, uint256 amount) internal override(ERC20Upgradeable, ERC20VotesUpgradeable);
```

### _burn

See {ERC20Upgradeable-_burn}.


```solidity
function _burn(address account, uint256 amount) internal override(ERC20Upgradeable, ERC20VotesUpgradeable);
```

### _beforeTokenTransfer

See {ERC20Upgradeable-_beforeTokenTransfer}.


```solidity
function _beforeTokenTransfer(address from, address to, uint256 amount) internal override;
```

### _afterTokenTransfer

See {ERC20Upgradeable-_afterTokenTransfer}.


```solidity
function _afterTokenTransfer(address from, address to, uint256 amount)
    internal
    override(ERC20Upgradeable, ERC20VotesUpgradeable);
```

### fallback

The fallback function for the contract.

*When ether is sent directly to the contract without any data, the fallback function
will call the mint function. This allows users to mint tokens by simply sending ether to
the contract.*


```solidity
fallback() external payable;
```

### receive

The receive function for the contract.

*This function is called when ether is sent directly to the contract without any
data. It is a required function for contracts that define a fallback function, and it
should be left empty since the fallback function handles the minting process.*


```solidity
receive() external payable;
```

