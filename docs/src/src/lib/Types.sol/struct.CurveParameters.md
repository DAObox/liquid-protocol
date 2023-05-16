# CurveParameters
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/lib/Types.sol)

This struct holds the key parameters that define a bonding curve for a token.

*These parameters can be updated over time to change the behavior of the bonding curve.*


```solidity
struct CurveParameters {
    uint32 theta;
    uint32 friction;
    uint32 reserveRatio;
    IBondingCurve formula;
}
```

