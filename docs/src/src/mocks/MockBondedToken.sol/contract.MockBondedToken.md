# MockBondedToken
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/mocks/MockBondedToken.sol)

**Inherits:**
ERC20, ERC20Burnable, Ownable, ERC20Permit, ERC20Votes


## Functions
### constructor


```solidity
constructor() ERC20("MockBondedToken", "TKN") ERC20Permit("MockBondedToken");
```

### mint


```solidity
function mint(address to, uint256 amount) public;
```

### _afterTokenTransfer


```solidity
function _afterTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Votes);
```

### _mint


```solidity
function _mint(address to, uint256 amount) internal override(ERC20, ERC20Votes);
```

### _burn


```solidity
function _burn(address account, uint256 amount) internal override(ERC20, ERC20Votes);
```

