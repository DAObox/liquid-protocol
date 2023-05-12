# CurveParameters
[Git Source](https://github.com/DAObox/fantastic-spork/blob/37171c98e431882ac7150395fb59a9c8f7e87ee4/src/lib/Types.sol)

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

