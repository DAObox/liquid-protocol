# Events
[Git Source](https://github.com/DAObox/fantastic-spork/blob/417d39e05e02311e6212644ed1689713e91fc673/src/lib/Events.sol)


## Events
### ContinuousMint
*Emitted when tokens are minted continuously (the normal minting process).*


```solidity
event ContinuousMint(
    address indexed buyer, uint256 minted, uint256 depositAmount, uint256 reserveAmount, uint256 fundingAmount
);
```

### ContinuousBurn
*Emitted when tokens are burned continuously (the normal burning process).*


```solidity
event ContinuousBurn(address indexed burner, uint256 burned, uint256 reimburseAmount, uint256 exitFee);
```

### SponsoredMint
*Emitted when tokens are minted in a sponsored process.*


```solidity
event SponsoredMint(address indexed sender, uint256 depositAmount, uint256 minted);
```

### SponsoredBurn
*Emitted when tokens are burned in a sponsored process.*


```solidity
event SponsoredBurn(address indexed sender, uint256 burnAmount);
```

