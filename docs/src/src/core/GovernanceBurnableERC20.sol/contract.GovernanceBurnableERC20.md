# GovernanceBurnableERC20
[Git Source](https://github.com/DAObox/fantastic-spork/blob/e85e294b9aa197e65780cf42fd333d2b29d2cb82/src/core/GovernanceBurnableERC20.sol)

**Inherits:**
Initializable, ERC20Upgradeable, ERC20BurnableUpgradeable, ERC20PermitUpgradeable, ERC20VotesUpgradeable, ERC165Upgradeable, UUPSUpgradeable, DaoAuthorizableUpgradeable


## State Variables
### MINTER_ROLE_ID

```solidity
bytes32 public constant MINTER_ROLE_ID = keccak256("MINTER_ROLE");
```


### UPGRADER_ROLE_ID

```solidity
bytes32 public constant UPGRADER_ROLE_ID = keccak256("UPGRADER_ROLE");
```


## Functions
### constructor


```solidity
constructor();
```

### initialize


```solidity
function initialize(IDAO _dao, string memory _name, string memory _symbol) public initializer;
```

### mint


```solidity
function mint(address to, uint256 amount) public auth(MINTER_ROLE_ID);
```

### _authorizeUpgrade


```solidity
function _authorizeUpgrade(address newImplementation) internal override auth(UPGRADER_ROLE_ID);
```

### supportsInterface


```solidity
function supportsInterface(bytes4 _interfaceId) public view virtual override returns (bool);
```

### _afterTokenTransfer


```solidity
function _afterTokenTransfer(address from, address to, uint256 amount)
    internal
    override(ERC20Upgradeable, ERC20VotesUpgradeable);
```

### _mint


```solidity
function _mint(address to, uint256 amount) internal override(ERC20Upgradeable, ERC20VotesUpgradeable);
```

### _burn


```solidity
function _burn(address account, uint256 amount) internal override(ERC20Upgradeable, ERC20VotesUpgradeable);
```

