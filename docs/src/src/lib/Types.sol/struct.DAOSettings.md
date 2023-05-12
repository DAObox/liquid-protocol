# DAOSettings
[Git Source](https://github.com/DAObox/fantastic-spork/blob/37171c98e431882ac7150395fb59a9c8f7e87ee4/src/lib/Types.sol)

The container for the DAO settings to be set during the DAO initialization.


```solidity
struct DAOSettings {
    address trustedForwarder;
    string daoURI;
    string subdomain;
    bytes metadata;
}
```

