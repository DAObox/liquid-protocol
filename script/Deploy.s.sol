// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.17;

import { ContinuousDaoSetup } from "../src/core/ContinuousDaoSetup.sol";
import { PluginRepoFactory } from "@aragon/framework/plugin/repo/PluginRepoFactory.sol";
import { PluginRepo } from "@aragon/framework/plugin/repo/PluginRepo.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    string constant subdomain = "lp";
    address constant maintainer = 0x47d80912400ef8f8224531EBEB1ce8f2ACf4b75a;
    bytes constant buildMetadata = "mock";
    bytes constant releaseMetadata = "mock";

    // PluginRepoFactory factory = PluginRepoFactory(0x96E54098317631641703404C06A5afAD89da7373); // mainnet
    PluginRepoFactory factory = PluginRepoFactory(0xDcC5933bc3567E7798Ff00Ab3413cF5f5801BD41); // mumbai
    // PluginRepoFactory factory = PluginRepoFactory(0x6E924eA5864044D8642385683fFA5AD42FB687f2); // polygon
    // PluginRepoFactory factory = PluginRepoFactory(0x301868712b77744A3C0E5511609238399f0A2d4d); // goerli

    function run() public broadcaster returns (ContinuousDaoSetup setup, PluginRepo repo) {
        setup = new ContinuousDaoSetup();
        repo = factory.createPluginRepoWithFirstVersion({
            _subdomain: subdomain,
            _pluginSetup: address(setup),
            _maintainer: maintainer,
            _releaseMetadata: releaseMetadata,
            _buildMetadata: buildMetadata
        });
    }
}
