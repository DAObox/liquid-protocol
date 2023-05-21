# Liquid Protocol [![Open in Gitpod][gitpod-badge]][gitpod] [![Github Actions][gha-badge]][gha] [![Foundry][foundry-badge]][foundry] [![License: MIT][license-badge]][license]

[gitpod]: https://gitpod.io/#https://github.com/DAOBox/liquid-protocol
[gitpod-badge]: https://img.shields.io/badge/Gitpod-Open%20in%20Gitpod-FFB45B?logo=gitpod
[gha]: https://github.com/DAOBox/liquid-protocol/actions
[gha-badge]: https://github.com/DAOBox/liquid-protocol/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

> Augmented Bonging Curves on Aragon OSx

<br/>

## What's Inside

- [Forge](https://github.com/foundry-rs/foundry/blob/master/forge): compile, test, fuzz, format, and
  deploy smart contracts
- [PRBTest](https://github.com/PaulRBerg/prb-test): modern collection of testing assertions and
  logging utilities
- [Forge Std](https://github.com/foundry-rs/forge-std): collection of helpful contracts and
  cheatcodes for testing
- [Solhint](https://github.com/protofire/solhint): linter for Solidity code
- [Prettier Plugin Solidity](https://github.com/prettier-solidity/prettier-plugin-solidity): code
  formatter for non-Solidity files

<br/>

## Quick Start

1. copy the `.env.example` to `.env` and set the variables
2. install the depencencies 
```bash
pnpm install
forge build
```
3. run the integration test 
```
forge test --fork-url mainnet -vvv --match-test test_protocol
```

<br/>


## License

This project is licensed under MIT.
