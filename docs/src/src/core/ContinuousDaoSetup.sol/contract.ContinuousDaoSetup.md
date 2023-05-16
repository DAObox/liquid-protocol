# ContinuousDaoSetup
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/core/ContinuousDaoSetup.sol)

**Inherits:**
PluginSetup


## State Variables
### tokenVotingBase
The address of the `TokenVoting` base contract.


```solidity
address private immutable tokenVotingBase;
```


### hatchBase

```solidity
address private immutable hatchBase;
```


### governanceERC20Base

```solidity
address private immutable governanceERC20Base;
```


### marketMakerBase

```solidity
address private immutable marketMakerBase;
```


## Functions
### constructor

The contract constructor, that deploys the bases.


```solidity
constructor();
```

### prepareInstallation


```solidity
function prepareInstallation(address _dao, bytes calldata _data)
    external
    returns (address plugin, PreparedSetupData memory preparedSetupData);
```

### prepareUninstallation


```solidity
function prepareUninstallation(address _dao, SetupPayload calldata _payload)
    external
    view
    returns (PermissionLib.MultiTargetPermission[] memory permissions);
```

### implementation


```solidity
function implementation() external view virtual override returns (address);
```

