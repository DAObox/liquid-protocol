// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity 0.8.17;

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {PluginSetup, IPluginSetup} from "@aragon/framework/plugin/setup/PluginSetup.sol";
import {PermissionLib} from "@aragon/core/permission/PermissionLib.sol";
import {TokenVoting} from "@aragon/plugins/governance/majority-voting/token/TokenVoting.sol";
import {MajorityVotingBase} from "@aragon/plugins/governance/majority-voting/MajorityVotingBase.sol";
import {IDAO} from "@aragon/core/plugin/PluginCloneable.sol";
import {DAO} from "@aragon/core/dao/DAO.sol";
import {MarketMaker} from "./MarketMaker.sol";
import {SimpleHatch} from "./SimpleHatch.sol";
import {GovernanceBurnableERC20} from "./GovernanceBurnableERC20.sol";
import {VestingSchedule, HatchParameters, CurveParameters} from "../lib/Types.sol";
import {IBondedToken} from "../interfaces/IBondedToken.sol";

contract ContinuousDaoSetup is PluginSetup {
    using Address for address;
    using Clones for address;

    /// @notice The address of the `TokenVoting` base contract.
    address private immutable tokenVotingBase;

    address private immutable hatchBase;

    address private immutable governanceERC20Base;

    address private immutable marketMakerBase;

    /// @notice The contract constructor, that deploys the bases.
    constructor() {
        tokenVotingBase = address(new TokenVoting());
        governanceERC20Base = address(new GovernanceBurnableERC20());
        hatchBase = address(new SimpleHatch());
        marketMakerBase = address(new MarketMaker());
    }

    function prepareInstallation(address _dao, bytes calldata _data)
        external
        returns (address plugin, PreparedSetupData memory preparedSetupData)
    {
        (
            string memory name,
            string memory symbol,
            address externalToken,
            MajorityVotingBase.VotingSettings memory votingSettings,
            HatchParameters memory hatchParameters,
            VestingSchedule memory schedule,
            CurveParameters memory curve
        ) = abi.decode(
            _data,
            (
                string,
                string,
                address,
                MajorityVotingBase.VotingSettings,
                HatchParameters,
                VestingSchedule,
                CurveParameters
            )
        );

        address[] memory helpers = new address[](3);

        // adding addresses directly into the helpers array to get around the stack limit
        helpers[0] = governanceERC20Base.clone();
        helpers[1] = marketMakerBase.clone();
        helpers[2] = hatchBase.clone();

        GovernanceBurnableERC20(helpers[0]).initialize(IDAO(_dao), name, symbol);
        MarketMaker(helpers[1]).initialize(IDAO(_dao), IBondedToken(helpers[0]), IERC20(externalToken), curve);
        SimpleHatch(helpers[2]).initialize(IDAO(_dao), hatchParameters, schedule);

        plugin = createERC1967Proxy(
            address(tokenVotingBase),
            abi.encodeWithSelector(TokenVoting.initialize.selector, _dao, votingSettings, helpers[0])
        );

        // Prepare permissions
        PermissionLib.MultiTargetPermission[] memory permissions = new PermissionLib.MultiTargetPermission[](6);

        // Voting Permissions
        permissions[0] = PermissionLib.MultiTargetPermission(
            PermissionLib.Operation.Grant,
            plugin,
            _dao,
            PermissionLib.NO_CONDITION,
            TokenVoting(tokenVotingBase).UPDATE_VOTING_SETTINGS_PERMISSION_ID()
        );

        permissions[1] = PermissionLib.MultiTargetPermission(
            PermissionLib.Operation.Grant,
            plugin,
            _dao,
            PermissionLib.NO_CONDITION,
            TokenVoting(tokenVotingBase).UPGRADE_PLUGIN_PERMISSION_ID()
        );

        permissions[2] = PermissionLib.MultiTargetPermission(
            PermissionLib.Operation.Grant,
            _dao,
            plugin,
            PermissionLib.NO_CONDITION,
            DAO(payable(_dao)).EXECUTE_PERMISSION_ID()
        );

        // Token Permissions
        permissions[3] = PermissionLib.MultiTargetPermission(
            PermissionLib.Operation.Grant,
            helpers[0], // Token
            helpers[1], // MarketMaker
            PermissionLib.NO_CONDITION,
            GovernanceBurnableERC20(helpers[0]).MINTER_ROLE_ID()
        );

        // MatketMaker Permission
        permissions[4] = PermissionLib.MultiTargetPermission(
            PermissionLib.Operation.Grant,
            helpers[0], // Token
            helpers[2], // Hatch
            PermissionLib.NO_CONDITION,
            MarketMaker(helpers[1]).HATCH_PERMISSION_ID()
        );

        permissions[5] = PermissionLib.MultiTargetPermission(
            PermissionLib.Operation.Grant,
            helpers[0], // Token
            plugin,
            PermissionLib.NO_CONDITION,
            MarketMaker(helpers[1]).CONFIGURE_PERMISSION_ID()
        );

        preparedSetupData.helpers = helpers;
        preparedSetupData.permissions = permissions;
    }

    function prepareUninstallation(address _dao, SetupPayload calldata _payload)
        external
        view
        returns (PermissionLib.MultiTargetPermission[] memory permissions)
    {}

    function implementation() external view virtual override returns (address) {
        return address(tokenVotingBase);
    }
}
