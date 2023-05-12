# DSTest
[Git Source](https://github.com/DAObox/fantastic-spork/blob/37171c98e431882ac7150395fb59a9c8f7e87ee4/src/test/utils/test.sol)


## State Variables
### IS_TEST

```solidity
bool public IS_TEST = true;
```


### failed

```solidity
bool public failed;
```


### HEVM_ADDRESS

```solidity
address public constant HEVM_ADDRESS = address(bytes20(uint160(uint256(keccak256("hevm cheat code")))));
```


## Functions
### mayRevert


```solidity
modifier mayRevert();
```

### testopts


```solidity
modifier testopts(string memory);
```

### fail


```solidity
function fail() public;
```

### logs_gas


```solidity
modifier logs_gas();
```

### assertTrue


```solidity
function assertTrue(bool condition) public;
```

### assertTrue


```solidity
function assertTrue(bool condition, string memory err) public;
```

### assertEq


```solidity
function assertEq(address a, address b) public;
```

### assertEq


```solidity
function assertEq(address a, address b, string memory err) public;
```

### assertEq


```solidity
function assertEq(bytes32 a, bytes32 b) public;
```

### assertEq


```solidity
function assertEq(bytes32 a, bytes32 b, string memory err) public;
```

### assertEq32


```solidity
function assertEq32(bytes32 a, bytes32 b) public;
```

### assertEq32


```solidity
function assertEq32(bytes32 a, bytes32 b, string memory err) public;
```

### assertEq


```solidity
function assertEq(int256 a, int256 b) public;
```

### assertEq


```solidity
function assertEq(int256 a, int256 b, string memory err) public;
```

### assertEq


```solidity
function assertEq(uint256 a, uint256 b) public;
```

### assertEq


```solidity
function assertEq(uint256 a, uint256 b, string memory err) public;
```

### assertEqDecimal


```solidity
function assertEqDecimal(int256 a, int256 b, uint256 decimals) public;
```

### assertEqDecimal


```solidity
function assertEqDecimal(int256 a, int256 b, uint256 decimals, string memory err) public;
```

### assertEqDecimal


```solidity
function assertEqDecimal(uint256 a, uint256 b, uint256 decimals) public;
```

### assertEqDecimal


```solidity
function assertEqDecimal(uint256 a, uint256 b, uint256 decimals, string memory err) public;
```

### assertGt


```solidity
function assertGt(uint256 a, uint256 b) public;
```

### assertGt


```solidity
function assertGt(uint256 a, uint256 b, string memory err) public;
```

### assertGt


```solidity
function assertGt(int256 a, int256 b) public;
```

### assertGt


```solidity
function assertGt(int256 a, int256 b, string memory err) public;
```

### assertGtDecimal


```solidity
function assertGtDecimal(int256 a, int256 b, uint256 decimals) public;
```

### assertGtDecimal


```solidity
function assertGtDecimal(int256 a, int256 b, uint256 decimals, string memory err) public;
```

### assertGtDecimal


```solidity
function assertGtDecimal(uint256 a, uint256 b, uint256 decimals) public;
```

### assertGtDecimal


```solidity
function assertGtDecimal(uint256 a, uint256 b, uint256 decimals, string memory err) public;
```

### assertGe


```solidity
function assertGe(uint256 a, uint256 b) public;
```

### assertGe


```solidity
function assertGe(uint256 a, uint256 b, string memory err) public;
```

### assertGe


```solidity
function assertGe(int256 a, int256 b) public;
```

### assertGe


```solidity
function assertGe(int256 a, int256 b, string memory err) public;
```

### assertGeDecimal


```solidity
function assertGeDecimal(int256 a, int256 b, uint256 decimals) public;
```

### assertGeDecimal


```solidity
function assertGeDecimal(int256 a, int256 b, uint256 decimals, string memory err) public;
```

### assertGeDecimal


```solidity
function assertGeDecimal(uint256 a, uint256 b, uint256 decimals) public;
```

### assertGeDecimal


```solidity
function assertGeDecimal(uint256 a, uint256 b, uint256 decimals, string memory err) public;
```

### assertLt


```solidity
function assertLt(uint256 a, uint256 b) public;
```

### assertLt


```solidity
function assertLt(uint256 a, uint256 b, string memory err) public;
```

### assertLt


```solidity
function assertLt(int256 a, int256 b) public;
```

### assertLt


```solidity
function assertLt(int256 a, int256 b, string memory err) public;
```

### assertLtDecimal


```solidity
function assertLtDecimal(int256 a, int256 b, uint256 decimals) public;
```

### assertLtDecimal


```solidity
function assertLtDecimal(int256 a, int256 b, uint256 decimals, string memory err) public;
```

### assertLtDecimal


```solidity
function assertLtDecimal(uint256 a, uint256 b, uint256 decimals) public;
```

### assertLtDecimal


```solidity
function assertLtDecimal(uint256 a, uint256 b, uint256 decimals, string memory err) public;
```

### assertLe


```solidity
function assertLe(uint256 a, uint256 b) public;
```

### assertLe


```solidity
function assertLe(uint256 a, uint256 b, string memory err) public;
```

### assertLe


```solidity
function assertLe(int256 a, int256 b) public;
```

### assertLe


```solidity
function assertLe(int256 a, int256 b, string memory err) public;
```

### assertLeDecimal


```solidity
function assertLeDecimal(int256 a, int256 b, uint256 decimals) public;
```

### assertLeDecimal


```solidity
function assertLeDecimal(int256 a, int256 b, uint256 decimals, string memory err) public;
```

### assertLeDecimal


```solidity
function assertLeDecimal(uint256 a, uint256 b, uint256 decimals) public;
```

### assertLeDecimal


```solidity
function assertLeDecimal(uint256 a, uint256 b, uint256 decimals, string memory err) public;
```

### assertEq


```solidity
function assertEq(string memory a, string memory b) public;
```

### assertEq


```solidity
function assertEq(string memory a, string memory b, string memory err) public;
```

### checkEq0


```solidity
function checkEq0(bytes memory a, bytes memory b) public pure returns (bool ok);
```

### assertEq0


```solidity
function assertEq0(bytes memory a, bytes memory b) public;
```

### assertEq0


```solidity
function assertEq0(bytes memory a, bytes memory b, string memory err) public;
```

## Events
### log

```solidity
event log(string);
```

### logs

```solidity
event logs(bytes);
```

### log_address

```solidity
event log_address(address);
```

### log_bytes32

```solidity
event log_bytes32(bytes32);
```

### log_int

```solidity
event log_int(int256);
```

### log_uint

```solidity
event log_uint(uint256);
```

### log_bytes

```solidity
event log_bytes(bytes);
```

### log_string

```solidity
event log_string(string);
```

### log_named_address

```solidity
event log_named_address(string key, address val);
```

### log_named_bytes32

```solidity
event log_named_bytes32(string key, bytes32 val);
```

### log_named_decimal_int

```solidity
event log_named_decimal_int(string key, int256 val, uint256 decimals);
```

### log_named_decimal_uint

```solidity
event log_named_decimal_uint(string key, uint256 val, uint256 decimals);
```

### log_named_int

```solidity
event log_named_int(string key, int256 val);
```

### log_named_uint

```solidity
event log_named_uint(string key, uint256 val);
```

### log_named_bytes

```solidity
event log_named_bytes(string key, bytes val);
```

### log_named_string

```solidity
event log_named_string(string key, string val);
```

