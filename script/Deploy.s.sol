// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.17;

import { ContinuousDaoSetup } from "../src/core/ContinuousDaoSetup.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    function run() public broadcaster returns (ContinuousDaoSetup setup) {
        setup = new ContinuousDaoSetup();
    }
}
