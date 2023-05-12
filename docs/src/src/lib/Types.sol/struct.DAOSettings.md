# DAOSettings
[Git Source](https://github.com/DAObox/fantastic-spork/blob/417d39e05e02311e6212644ed1689713e91fc673/src/lib/Types.sol)

The container for the DAO settings to be set during the DAO initialization.


```solidity
struct DAOSettings {
    address trustedForwarder;
    string daoURI;
    string subdomain;
    bytes metadata;
}
```

