# Utils
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/test/utils/Utils.sol)

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

