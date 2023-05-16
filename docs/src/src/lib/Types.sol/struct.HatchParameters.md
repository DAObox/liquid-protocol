# HatchParameters
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/lib/Types.sol)


```solidity
struct HatchParameters {
    IERC20 externalToken;
    IVotes bondedToken;
    MarketMaker pool;
    uint256 initialPrice;
    uint256 raised;
    uint256 minimumRaise;
    uint256 maximumRaise;
    uint256 hatchDeadline;
    HatchStatus status;
}
```

