// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.17;

import { ContinuousDaoSetup } from "../src/core/ContinuousDaoSetup.sol";
import { PluginRepoFactory } from "@aragon/framework/plugin/repo/PluginRepoFactory.sol";
import { PluginRepo } from "@aragon/framework/plugin/repo/PluginRepo.sol";
import { DAOFactory } from "@aragon/framework/dao/DAOFactory.sol";
import { PluginSetupRef } from "@aragon/framework/plugin/setup/PluginSetupProcessorHelpers.sol";
import { MajorityVotingBase } from "@aragon/plugins/governance/majority-voting/MajorityVotingBase.sol";
import { CurveParameters } from "../src/lib/Types.sol";
import { BancorBondingCurve } from "../src/math/BancorBondingCurve.sol";
import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    uint32 internal RATIO = 10 ** 4;
    uint64 internal ONE_DAY = 86_400;

    DAOFactory constant factory = DAOFactory(0x3ff1681f31f68Ff2723d25Cf839bA7500FE5d218); // mumbai
    PluginRepo constant repo = PluginRepo(0xA65e5B74bBd522b78091520E92934521eD436663); // mumbai

    DAOFactory.DAOSettings private settings = DAOFactory.DAOSettings({
        trustedForwarder: address(0),
        daoURI: "https://daobox.app",
        subdomain: "liquidityDaokjdalkjd",
        metadata: "0x00"
    });

    DAOFactory.PluginSettings[] private pluginSettings;

    function run() public broadcaster returns (address dao) {
        pluginSettings.push(
            DAOFactory.PluginSettings({
                pluginSetupRef: PluginSetupRef({
                    versionTag: PluginRepo.Tag({ release: 1, build: 1 }),
                    pluginSetupRepo: repo
                }),
                data: abi.encode(
                    "Continuous DAO",
                    "CDAO",
                    0xe11A86849d99F524cAC3E7A0Ec1241828e332C62,
                    MajorityVotingBase.VotingSettings({
                        votingMode: MajorityVotingBase.VotingMode.Standard,
                        supportThreshold: 50 * RATIO,
                        minParticipation: 10 * RATIO,
                        minDuration: ONE_DAY,
                        minProposerVotingPower: 1
                    }),
                    CurveParameters({
                        theta: 250_000, // 25% in RATIO_BASE
                        friction: 10_000, // 1% in RATIO_BASE
                        reserveRatio: 333_333, // 33.33% in RATIO_BASE
                        formula: new BancorBondingCurve()
                    }),
                    0x47d80912400ef8f8224531EBEB1ce8f2ACf4b75a
                    )
            })
        );
        dao = address(factory.createDao(settings, pluginSettings));
    }
}
