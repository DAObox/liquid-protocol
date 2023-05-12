# Utils
[Git Source](https://github.com/DAObox/fantastic-spork/blob/37171c98e431882ac7150395fb59a9c8f7e87ee4/src/test/utils/Utils.sol)

**Inherits:**
Test


## State Variables
### nextUser

```solidity
bytes32 internal nextUser = keccak256(abi.encodePacked("user address"));
```


## Functions
### getNextUserAddress


```solidity
function getNextUserAddress() external returns (address payable);
```

### createUsers


```solidity
function createUsers(uint256 userNum) external returns (address payable[] memory);
```

### mineBlocks


```solidity
function mineBlocks(uint256 numBlocks) external;
```

