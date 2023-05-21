// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.17 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { Vm } from "forge-std/Vm.sol";

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { TokenVoting } from "@aragon/plugins/governance/majority-voting/token/TokenVoting.sol";
import { MajorityVotingBase } from "@aragon/plugins/governance/majority-voting/MajorityVotingBase.sol";
import { PluginRepoFactory } from "@aragon/framework/plugin/repo/PluginRepoFactory.sol";
import { DAOFactory } from "@aragon/framework/dao/DAOFactory.sol";
import { PluginRepo } from "@aragon/framework/plugin/repo/PluginRepoFactory.sol";
import { DAO } from "@aragon/core/dao/DAO.sol";
import { PluginSetupRef } from "@aragon/framework/plugin/setup/PluginSetupProcessorHelpers.sol";
import { ContinuousDaoSetup } from "../src/core/ContinuousDaoSetup.sol";
import { CurveParameters } from "../src/lib/Types.sol";
import { IBondingCurve } from "../src/interfaces/IBondingCurve.sol";
import { MarketMaker } from "../src/core/MarketMaker.sol";
import { GovernanceBurnableERC20 } from "../src/core/GovernanceBurnableERC20.sol";
import { BancorBondingCurve } from "../src/math/BancorBondingCurve.sol";
import { MockUSDC } from "../src/mocks/MockUSDC.sol";

contract DAOParams {
    uint32 internal RATIO = 10 ** 4;
    uint64 internal ONE_DAY = 86_400;
    bytes internal EMPTY_BYTES = "";
    uint256 internal TOKEN = 10 ** 18;

    MajorityVotingBase.VotingSettings internal votingSettings = MajorityVotingBase.VotingSettings({
        votingMode: MajorityVotingBase.VotingMode.Standard,
        supportThreshold: 50 * RATIO,
        minParticipation: 10 * RATIO,
        minDuration: ONE_DAY,
        minProposerVotingPower: 1
    });

    DAOFactory.DAOSettings internal daoSettings = DAOFactory.DAOSettings({
        trustedForwarder: address(0),
        daoURI: "http://daobox.app",
        subdomain: "continuous-dao",
        metadata: "0x00"
    });
}

// NOTE: This should be run against a fork of mainnet
contract IntegrationBase is DAOParams, PRBTest, StdCheats {
    DAOFactory internal daoFactory;
    PluginRepoFactory internal repoFactory;
    ContinuousDaoSetup internal continuousSetup;
    PluginRepo internal continuousRepo;
    MockUSDC internal externalToken;
    IBondingCurve internal bondingCurve;
    CurveParameters internal curveParams;
    DAOFactory.PluginSettings[] internal pluginSettings;

    DAO internal dao;
    MarketMaker internal marketMaker;
    GovernanceBurnableERC20 internal governanceToken;
    TokenVoting internal voting;
    address internal hatchAdmin;

    function setUp() public virtual {
        setupRepo();
        deployContracts();
        deployDAO();
    }

    function setupRepo() public {
        daoFactory = DAOFactory(0xA03C2182af8eC460D498108C92E8638a580b94d4);
        repoFactory = PluginRepoFactory(0x96E54098317631641703404C06A5afAD89da7373);
        continuousSetup = new ContinuousDaoSetup();
        continuousRepo = repoFactory.createPluginRepoWithFirstVersion({
            _subdomain: "continuous-dao",
            _pluginSetup: address(continuousSetup),
            _maintainer: address(this),
            _releaseMetadata: "0x00",
            _buildMetadata: "0x00"
        });
        vm.label(address(continuousRepo), "continuousRepo");
        vm.label(address(continuousSetup), "continuousSetup");
        vm.label(address(repoFactory), "repoFactory");
        vm.label(address(daoFactory), "daoFactory");
    }

    function deployContracts() public {
        bondingCurve = IBondingCurve(new BancorBondingCurve());
        externalToken = new MockUSDC();
        curveParams = CurveParameters({ theta: 250_000, friction: 5000, reserveRatio: 300_000, formula: bondingCurve });
        vm.label(address(bondingCurve), "bondingCurve");
        vm.label(address(externalToken), "USDC");
    }

    function deployDAO() public {
        pluginSettings.push(
            DAOFactory.PluginSettings({
                pluginSetupRef: PluginSetupRef({
                    versionTag: PluginRepo.Tag({ release: 1, build: 1 }),
                    pluginSetupRepo: continuousRepo
                }),
                data: abi.encode("Continuous DAO", "CDAO", externalToken, votingSettings, curveParams, address(this))
            })
        );

        vm.recordLogs();

        dao = daoFactory.createDao(daoSettings, pluginSettings);

        Vm.Log[] memory entries = Vm(address(vm)).getRecordedLogs();

        for (uint256 i = 0; i < entries.length; i++) {
            if (entries[i].topics[0] == keccak256("DeployedContracts(address,address,address,address)")) {
                (address _tokenVoting, address _token, address _marketMaker, address _hatchAdmin) =
                    abi.decode(entries[i].data, (address, address, address, address));
                marketMaker = MarketMaker(_marketMaker);
                governanceToken = GovernanceBurnableERC20(_token);
                voting = TokenVoting(_tokenVoting);
                hatchAdmin = _hatchAdmin;

                vm.label(address(dao), "dao");
                vm.label(address(marketMaker), "marketMaker");
                vm.label(address(governanceToken), "governanceToken");
                vm.label(address(voting), "voting");
                vm.label(address(hatchAdmin), "hatchAdmin");
            }
        }
    }
}
