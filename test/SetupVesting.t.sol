// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import { IDAO } from "@aragon/core/plugin/PluginCloneable.sol";

import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { console } from "forge-std/console.sol";
import { stdStorage, StdStorage, Test } from "forge-std/Test.sol";

import { Utils } from "./utils/Utils.sol";
import { Vesting } from "../src/core/Vesting.sol";
import { MockBondedToken } from "../src/mocks/MockBondedToken.sol";
import { VestingSchedule } from "../src/lib/Types.sol";

contract SetupVesting is Test {
    using Address for address;
    using Clones for address;

    Utils internal utils;
    address payable[] internal users;

    address internal vestingBase;
    Vesting internal vesting;
    MockBondedToken internal token;
    VestingSchedule internal schedule;

    address internal dao;
    address internal beneficiary;

    function setUp() public virtual {
        // createFork("mainnet", 17_328_640);
        utils = new Utils();
        users = utils.createUsers(3);

        dao = users[0];
        vm.label(dao, "DAO");

        beneficiary = users[1];
        vm.label(beneficiary, "Beneficiary");

        token = new MockBondedToken();

        vestingBase = address(new Vesting());
        vesting = Vesting(vestingBase.clone());

        schedule = VestingSchedule({
            initialized: true,
            cliff: 30 days,
            start: block.timestamp,
            duration: 365 days,
            slicePeriodSeconds: 60 seconds,
            revocable: true,
            amountTotal: 1000 ether,
            released: 0,
            revoked: false
        });
    }

    function createFork(string memory network, uint256 blockNumber) public {
        // Silently pass this test if there is no API key.
        string memory alchemyApiKey = vm.envOr("API_KEY_ALCHEMY", string(""));
        if (bytes(alchemyApiKey).length == 0) {
            return;
        }
        // Otherwise, run the test against the mainnet fork.
        vm.createSelectFork({urlOrAlias: network, blockNumber: blockNumber});
        console.log("Curent Block: ", blockNumber);
    }

    function setupVesting() public {
        token.mint(address(vesting), 1000 ether);
        vesting.initialize(dao, beneficiary, address(token), schedule);
    }

    // function openTrading() public {
    //     address[] memory seedAddresses = new address[](1);
    //     uint256[] memory values = new uint256[](1);
    //     seedAddresses[0] = owner;
    //     values[0] = 100 ether;

    //     vm.prank(owner);
    //     token.openTrading{value: 100 ether}(seedAddresses, values);
    // }
}
