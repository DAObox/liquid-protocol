// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.17;

import { BancorBondingCurve } from "../src/math/BancorBondingCurve.sol";
import { MockUSDC } from "../src/mocks/MockUSDC.sol";

import { PluginRepoFactory } from "@aragon/framework/plugin/repo/PluginRepoFactory.sol";
import { PluginRepo } from "@aragon/framework/plugin/repo/PluginRepo.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    function run() public broadcaster returns (BancorBondingCurve curve, MockUSDC usdc) {
        curve = new BancorBondingCurve();
        usdc = new MockUSDC();
    }
}
