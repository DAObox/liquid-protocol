// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

import {console} from "forge-std/console.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

import {Utils} from "./utils/Utils.sol";
import {LiquidToken} from "../tokens/LiquidToken.sol";
import {BancorBondingCurve} from "../curves/BancorBondingCurve.sol";

import {CurveParameters} from "../lib/Types.sol";

contract BaseSetup is Test {
    Utils internal utils;
    address payable[] internal users;
    LiquidToken internal token;
    BancorBondingCurve internal formula;
    uint256 public constant ONE_TOKEN = 1e18;
    uint16 public constant ONE_PERCENT = 100;

    address internal alice;
    address internal bob;
    address internal owner;

    function setUp() public virtual {
        utils = new Utils();
        users = utils.createUsers(3);

        owner = users[0];
        vm.label(owner, "Owner");

        alice = users[1];
        vm.label(alice, "Alice");

        bob = users[2];
        vm.label(bob, "Bob");

        formula = new BancorBondingCurve();

        CurveParameters memory curve =
            CurveParameters({fundingRate: 3000, exitFee: 420, formula: formula, reserveRatio: 300_000});

        vm.prank(owner);
        token = new LiquidToken();
        token.initialize(address(owner), "Khalid Coin", "KK", curve);
    }

    function openTrading() public {
        address[] memory seedAddresses = new address[](1);
        uint256[] memory values = new uint256[](1);
        seedAddresses[0] = owner;
        values[0] = 100 ether;

        vm.prank(owner);
        token.openTrading{value: 100 ether}(seedAddresses, values);
    }
}
