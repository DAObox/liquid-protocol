# Utils
[Git Source](https://github.com/DAObox/fantastic-spork/blob/417d39e05e02311e6212644ed1689713e91fc673/src/test/utils/Utils.sol)

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

