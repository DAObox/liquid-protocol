# Events
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/lib/Events.sol)


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

### Hatch
*Emitted when the MarketMaker has been Hatched.*


```solidity
event Hatch(address indexed hatcher, uint256 amount);
```

