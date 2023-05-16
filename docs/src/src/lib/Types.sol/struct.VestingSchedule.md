# VestingSchedule
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/lib/Types.sol)


```solidity
struct VestingSchedule {
    bool initialized;
    uint256 cliff;
    uint256 start;
    uint256 duration;
    uint256 slicePeriodSeconds;
    bool revocable;
    uint256 amountTotal;
    uint256 released;
    bool revoked;
}
```

