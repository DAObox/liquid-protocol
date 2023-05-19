// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.17 <0.9.0;

import { console2 } from "forge-std/console2.sol";

import { IntegrationBase } from "./IntegrationBase.sol";
/// @dev If this is your first time with Forge, see the "Writing Tests" tutorial in the Foundry Book.
/// https://book.getfoundry.sh/forge/writing-tests

contract Integration is IntegrationBase {
    /// @dev An optional function invoked before each test case is run.
    function setUp() public virtual override {
        super.setUp();
    }

    /// @dev Basic test. Run it with `-vvv` to see the console log.
    function test_protocol() external {
        console2.log("Hello World");
        assertTrue(true);
    }
}
