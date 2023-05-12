# CurveParameters
[Git Source](https://github.com/DAObox/fantastic-spork/blob/417d39e05e02311e6212644ed1689713e91fc673/src/lib/Types.sol)

This struct holds the key parameters that define a bonding curve for a token.

*These parameters can be updated over time to change the behavior of the bonding curve.*


```solidity
struct CurveParameters {
    uint16 fundingRate;
    uint16 exitFee;
    IBondingCurve formula;
    uint32 reserveRatio;
}
```

